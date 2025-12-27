class Job {
  final String id;
  final String title;
  final String description;
  final String location;
  final String? district;
  final String? block;
  final String salary;
  final String requirements;
  final String employerName;
  final String? employerPhoto;
  final String employerId;
  final bool isPublic;
  final DateTime? scheduledDate;
  final DateTime createdAt;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    this.district,
    this.block,
    required this.salary,
    required this.requirements,
    required this.employerName,
    this.employerPhoto,
    required this.employerId,
    this.isPublic = true,
    this.scheduledDate,
    required this.createdAt,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      district: map['district'],
      block: map['block'],
      salary: map['salary'] ?? '',
      requirements: map['requirements'] ?? '',
      employerName: map['employerName'] ?? 'Unknown',
      employerPhoto: map['employerPhoto'],
      employerId: map['recruiterId'] ?? '',
      isPublic: map['isPublic'] ?? true,
      scheduledDate: map['scheduledDate']?.toDate(),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'district': district,
      'block': block,
      'salary': salary,
      'requirements': requirements,
      'employerName': employerName,
      'employerPhoto': employerPhoto,
      'employerId': employerId,
      'isPublic': isPublic,
      'scheduledDate': scheduledDate,
      'createdAt': createdAt,
    };
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
