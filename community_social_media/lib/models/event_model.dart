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
  List<String>? likes;
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
    List<String>? likesAsString = [];

    if (json['likes'] != null) {
      final v = json['likes'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      likesAsString = arr0;
    }
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
      likes: likesAsString,
      organizerImage: json['organizerImage'],
    );
  }

  Map<String, dynamic> toJson() {
    final arr0 = [];
    if (likes != null) {
      final v = likes;

      v!.forEach((v) {
        arr0.add(v);
      });
    }
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
      'likes': arr0,
      'organizerImage': organizerImage
    };
  }
}
