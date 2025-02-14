class Party {
  final String id;
  final String name;
  final DateTime dateTime;
  final String? location;
  final String hostId;
  final bool isPublic;
  final List<String> memberIds;

  Party({
    required this.id,
    required this.name,
    required this.dateTime,
    this.location,
    required this.hostId,
    required this.isPublic,
    required this.memberIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'hostId': hostId,
      'isPublic': isPublic,
      'memberIds': memberIds,
    };
  }

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'],
      name: json['name'],
      dateTime: DateTime.parse(json['dateTime']),
      location: json['location'],
      hostId: json['hostId'],
      isPublic: json['isPublic'],
      memberIds: List<String>.from(json['memberIds']),
    );
  }
}