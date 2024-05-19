import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/screens/user_screen/detailed_post_screen.dart';
import 'package:community_social_media/services/auth_service.dart';
import 'package:community_social_media/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

AuthService _authService = AuthService();
FirestoreService _firestoreService = FirestoreService();

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _firestoreService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final activeUser = snapshot.data;
          return _buildBody(context, activeUser!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text("Error"));
        }
      },
    ));
  }

  Widget _buildBody(BuildContext context, UserModel user) {
    return SizedBox(
      height: context.height,
      child: Padding(
        padding: context.paddingHorizontalDefault,
        child: Column(
          children: [
            Expanded(
              flex: 35,
              child: _buildHeader(context, user),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Expanded(
              flex: 65,
              child: _buildConten(context),
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildConten(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder(
      future: _firestoreService.getPostsOfUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data!;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0, // Dikey aralıklar
              crossAxisSpacing: 8.0,
              mainAxisExtent: 150,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  debugPrint('post detay');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailedPostScreen(post: posts[index]),
                      ));
                },
                child: Container(
                    color: Colors.grey.withOpacity(.1),
                    height: 50,
                    width: 25,
                    child: Image.network(posts[index].postImageUrl!)),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    ));
  }

  Widget _buildHeader(BuildContext context, UserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: context.dynamicHeight(0.02),
          horizontal: context.dynamicWidth(.02)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconBtn(Icons.settings, () {
                    debugPrint('ayarlar');
                  }),
                  _buildIconBtn(
                    Icons.notifications_none,
                    () {
                      debugPrint('bildirim');
                    },
                  )
                ],
              ),
              _buildIconBtn(
                Icons.logout_rounded,
                () {
                  debugPrint('Çıkış');
                  _authService.signOut(context);
                },
              ),
            ],
          ),
          Expanded(
            flex: 15,
            child: CircleAvatar(
              radius: 50,
              child: user.profilePhoto != null && user.profilePhoto != ""
                  ? ClipOval(child: Image.network(user.profilePhoto!))
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 10,
            child: _viewText(
              Alignment.center,
              user.userName!,
              context.textTheme.titleLarge?.copyWith(
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: _viewText(
              Alignment.center,
              'Hesap Türü: Kullanıcı',
              context.textTheme.titleSmall,
            ),
          )
        ],
      ),
    );
  }

  IconButton _buildIconBtn(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: Colors.blue,
        size: 30,
      ),
    );
  }

  Align _viewText(
      AlignmentGeometry alignmentGeometry, String text, var textStyle) {
    return Align(
      alignment: alignmentGeometry,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
