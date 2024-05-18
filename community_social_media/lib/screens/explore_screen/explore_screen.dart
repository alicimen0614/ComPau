import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/models/post_model.dart';
import 'package:community_social_media/widgets/post_item_widget.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: PostItemWidget(
          post: PostModel(description: "asdadsadsa", postId: "asdasdsads"),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Text(
          'Sosyal Medya',
          style: context.textTheme.titleLarge,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _viewShowDialog(context);
            },
            icon: Icon(
              Icons.add_box_outlined,
              color: Colors.amber,
              size: 20 * .9,
            ),
          )
        ]);
  }

  Future<dynamic> _viewShowDialog(BuildContext context) {
    final textStyle = context.textTheme.bodyMedium;
    return showModalBottomSheet(
        backgroundColor: Colors.black,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  /*  debugPrint('Galeri');
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  final selectedImage =
                      await PostPhotoController().pickImageFromGaallery();
                  navigator.push(MaterialPageRoute(
                    builder: (context) => PostsScreen(
                      selectedImage: selectedImage,
                    ),
                  )); */
                },
                leading: const Icon(Icons.photo_outlined),
                title: Text(
                  'Fotograf Seç',
                  style: textStyle,
                ),
              ),
              ListTile(
                onTap: () async {
                  /*  debugPrint('Kamera');
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  final selectedImage =
                      await PostPhotoController().pickImageFromCamera();
                  if (selectedImage != null) {
                    navigator.push(MaterialPageRoute(
                      builder: (context) => PostsScreen(
                        selectedImage: selectedImage,
                      ),
                    ));
                  } */
                },
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(
                  'Fotograf Çek',
                  style: textStyle,
                ),
              )
            ],
          );
        });
  }
}
