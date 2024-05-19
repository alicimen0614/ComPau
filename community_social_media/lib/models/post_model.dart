class PostModel {
  String? postId;
  String? userId;
  String? userName;
  DateTime? timestamp;
  String? description;
  String? postImageUrl;
  String? likes;
  String? userImage;

  PostModel(
      {this.postId,
      this.userId,
      this.userName,
      this.timestamp,
      this.description,
      this.postImageUrl,
      this.likes,
      this.userImage});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        postId: json['postId'],
        userId: json['userId'],
        userName: json['userName'],
        timestamp: DateTime.parse(json['timestamp']),
        description: json['description'],
        postImageUrl: json['postImageUrl'],
        likes: json['likes'],
        userImage: json['userImage']);
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp?.toIso8601String(),
      'description': description,
      'postImageUrl': postImageUrl,
      'likes': likes,
      'userImage': userImage
    };
  }
}
