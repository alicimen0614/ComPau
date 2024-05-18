class EventModel {
  String? eventId;
  String? userId;
  String? userName;
  DateTime? timestamp;
  String? description;
  String? eventImageUrl;
  String? likes;
  List<String>? paticipants;

  EventModel({
    this.eventId,
    this.userId,
    this.userName,
    this.timestamp,
    this.description,
    this.eventImageUrl,
    this.likes,
    this.paticipants
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'],
      userId: json['userId'],
      userName: json['userName'],
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      eventImageUrl: json['eventImageUrl'],
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp?.toIso8601String(),
      'description': description,
      'eventImageUrl': eventImageUrl,
      'likes': likes,
    };
  }
}
