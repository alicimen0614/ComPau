class UserModel {
  String? uid;
  String? userName;
  String? profilePhoto;
  String? accountType;
  List<String>? communitiesFollowed;

  UserModel(
      {this.uid,
      this.userName,
      this.profilePhoto,
      this.accountType,
      this.communitiesFollowed});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      userName: json['userName'],
      profilePhoto: json['profilePhoto'],
      accountType: json['accountType'],
      communitiesFollowed: json['communitiesFollowed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'profilePhoto': profilePhoto,
      'accountType': accountType,
      'communitiesFollowed': communitiesFollowed,
    };
  }
}
