class WorkerProfile {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final String? photoURL;
  final String? district;
  final String? block;
  final String? village;
  final List<String> skills;
  final int? experienceYears;
  final String? educationLevel;
  final String? aadhaarNumber;
  final String? email;
  final List<String> preferredJobTypes;
  final int rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkerProfile({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    this.photoURL,
    this.district,
    this.block,
    this.village,
    this.skills = const [],
    this.experienceYears,
    this.educationLevel,
    this.aadhaarNumber,
    this.email,
    this.preferredJobTypes = const [],
    this.rating = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkerProfile.fromMap(Map<String, dynamic> map) {
    return WorkerProfile(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoURL: map['photoURL'],
      district: map['district'],
      block: map['block'],
      village: map['village'],
      skills: List<String>.from(map['skills'] ?? []),
      experienceYears: map['experienceYears'],
      educationLevel: map['educationLevel'],
      aadhaarNumber: map['aadhaarNumber'],
      email: map['email'],
      preferredJobTypes: List<String>.from(map['preferredJobTypes'] ?? []),
      rating: map['rating'] ?? 0,
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'district': district,
      'block': block,
      'village': village,
      'skills': skills,
      'experienceYears': experienceYears,
      'educationLevel': educationLevel,
      'aadhaarNumber': aadhaarNumber,
      'email': email,
      'preferredJobTypes': preferredJobTypes,
      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String get location {
    List<String> parts = [];
    if (village != null && village!.isNotEmpty) parts.add(village!);
    if (block != null && block!.isNotEmpty) parts.add(block!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    return parts.join(', ');
  }
}
