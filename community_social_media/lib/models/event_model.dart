class EventModel {
  String? eventId;
  String? organizer;
  String? organizerId;
  String? eventTitle;
  String? category;
  DateTime? eventDate;
  String? description;
  String? eventImageUrl;
  String? location;
  String? likes;
  List<String>? participants;
  String? organizerImage;

  EventModel(
      {this.eventId,
      this.organizer,
      this.organizerId,
      this.eventTitle,
      this.category,
      this.eventDate,
      this.description,
      this.eventImageUrl,
      this.location,
      this.likes,
      this.participants,
      this.organizerImage});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
        eventId: json['eventId'],
        organizer: json['organizer'],
        organizerId: json['organizerId'],
        eventTitle: json['eventTitle'],
        category: json['category'],
        eventDate: DateTime.parse(json['eventDate']),
        description: json['description'],
        eventImageUrl: json['eventImageUrl'],
        location: json['location'],
        likes: json['likes'],
        organizerImage: json['organizerImage']);
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'organizer': organizer,
      'organizerId': organizerId,
      'eventTitle': eventTitle,
      'category': category,
      'eventDate': eventDate?.toIso8601String(),
      'description': description,
      'eventImageUrl': eventImageUrl,
      'location': location,
      'likes': likes,
      'organizerImage': organizerImage
    };
  }
}
