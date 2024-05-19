import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/models/post_model.dart';
import 'package:community_social_media/screens/explore_screen/add_post_screen.dart';
import 'package:community_social_media/services/firestore_service.dart';
import 'package:community_social_media/widgets/post_item_widget.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isLoading = false;
  final _firestoreService = FirestoreService();
  List<PostModel> postList = [];
  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF007dc4),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: _buildAppBar(context),
      body: isLoading == false
          ? ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return PostItemWidget(
                  post: PostModel(
                      description: postList[index].description,
                      postId: postList[index].postId,
                      postImageUrl: postList[index].postImageUrl,
                      timestamp: postList[index].timestamp,
                      userId: postList[index].userId,
                      userName: postList[index].userName,
                      likes: postList[index].likes,
                      userImage: postList[index].userImage),
                );
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Keşfet',
        style: context.textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            _viewShowDialog(context);
          },
          icon: const Icon(
            Icons.add_box_outlined,
            color: Colors.amber,
            size: 20 * .9,
          ),
        )
      ],
    );
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

  void getPosts() async {
    setState(() {
      isLoading = true;
    });
    postList = await _firestoreService.getPosts();
    setState(() {
      isLoading = false;
    });
  }
}
