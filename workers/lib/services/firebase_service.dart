import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Send OTP to phone number
  static Future<String> sendOTP({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onAutoVerify,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    String formattedPhone = phoneNumber;
    if (!phoneNumber.startsWith('+')) {
      formattedPhone = '+91$phoneNumber'; // Add India country code
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      verificationCompleted: onAutoVerify,
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Timeout
      },
      timeout: const Duration(seconds: 60),
    );

    return formattedPhone;
  }

  // Verify OTP
  static Future<UserCredential?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Invalid OTP: ${e.toString()}');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if worker profile exists
  static Future<Map<String, dynamic>?> getWorkerProfile(String uid) async {
    try {
      final doc = await _firestore.collection('workers').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get profile: ${e.toString()}');
    }
  }

  // Create/Update worker profile
  static Future<void> saveWorkerProfile({
    required String uid,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      await _firestore.collection('workers').doc(uid).set(
        {
          ...profileData,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save profile: ${e.toString()}');
    }
  }

  // Get jobs matching worker skills and region
  static Future<List<Map<String, dynamic>>> getJobs({
    List<String>? workerSkills,
    String? workerLocation,
    int limit = 50,
  }) async {
    try {
      // Fetch all public jobs (we'll filter client-side)
      final snapshot = await _firestore
          .collection('jobs')
          .where('isPublic', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit * 2) // Fetch more to allow filtering
          .get();

      List<Map<String, dynamic>> allJobs = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      // If no filters, return all
      if (workerSkills == null && workerLocation == null) {
        return allJobs.take(limit).toList();
      }

      // Client-side filtering
      List<Map<String, dynamic>> filteredJobs = allJobs.where((job) {
        bool skillMatch = false;
        bool regionMatch = false;

        // Check skill match
        if (workerSkills != null && workerSkills.isNotEmpty) {
          List<String> jobSkills = List<String>.from(job['skills'] ?? []);
          skillMatch = workerSkills.any((skill) => jobSkills.contains(skill));
        }

        // Check region match (flexible location matching)
        if (workerLocation != null && workerLocation.isNotEmpty) {
          String jobLocation = (job['location'] ?? '').toString().toLowerCase();
          String workerLoc = workerLocation.toLowerCase();
          
          // Extract district/state for smart matching
          regionMatch = jobLocation.contains(workerLoc) || 
                       workerLoc.contains(jobLocation) ||
                       _isSameRegion(jobLocation, workerLoc);
        }

        // Show job if EITHER skills match OR region matches
        return (workerSkills != null ? skillMatch : true) || 
               (workerLocation != null ? regionMatch : true);
      }).toList();

      return filteredJobs.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch jobs: ${e.toString()}');
    }
  }

  // Helper: Check if two locations are in same region
  static bool _isSameRegion(String loc1, String loc2) {
    // Extract common parts (district/state)
    final commonRegions = ['west bengal', 'bengal', 'kolkata'];
    
    for (var region in commonRegions) {
      if (loc1.contains(region) && loc2.contains(region)) {
        return true;
      }
    }
    
    // Check for district names
    final districts = [
      'murshidabad', 'north 24 parganas', 'south 24 parganas',
      'howrah', 'hooghly', 'nadia', 'bardhaman'
    ];
    
    for (var district in districts) {
      if (loc1.contains(district) && loc2.contains(district)) {
        return true;
      }
    }
    
    return false;
  }

  // Get job by ID
  static Future<Map<String, dynamic>?> getJobById(String jobId) async {
    try {
      final doc = await _firestore.collection('jobs').doc(jobId).get();
      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch job: ${e.toString()}');
    }
  }

  // Apply to a job
  static Future<void> applyToJob({
    required String jobId,
    required String workerId,
    required Map<String, dynamic> applicationData,
  }) async {
    try {
      await _firestore.collection('applications').add({
        'jobId': jobId,
        'workerId': workerId,
        'status': 'pending',
        ...applicationData,
        'appliedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to apply: ${e.toString()}');
    }
  }

  // Get worker's applications
  static Future<List<Map<String, dynamic>>> getWorkerApplications(
    String workerId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('workerId', isEqualTo: workerId)
          .orderBy('appliedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch applications: ${e.toString()}');
    }
  }
}
