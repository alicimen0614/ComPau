import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/models/post_model.dart';
import 'package:flutter/material.dart';

class DetailedPostScreen extends StatefulWidget {
  const DetailedPostScreen({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  State<DetailedPostScreen> createState() => DdetailedPostScreenState();
}

class DdetailedPostScreenState extends State<DetailedPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.paddingVerticalHigh,
        child: Column(children: [
          _itemHeader(context),
          if (widget.post.description != null) _itemDescription(context),
          _itemBody(context),
          _itemBottom(),
          const SizedBox(
            height: 5,
          )
        ]),
      ),
    );
  }

  Widget _itemBottom() {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(25),
          ),
          width: 70,
          height: 40,
          child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border_rounded,
                  size: 25, color: Colors.grey[600])),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(25),
          ),
          width: 70,
          height: 40,
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 25,
                color: Colors.grey[600],
              )),
        )
      ],
    );
  }

  Padding _itemDescription(BuildContext context) {
    debugPrint('${widget.post.description}');
    return Padding(
      padding: context.paddingHorizontalLow,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${widget.post.description}',
          maxLines: 3,
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _itemBody(BuildContext context) {
    return Padding(
      padding: context.paddingVerticalDefault,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.post.postImageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemHeader(BuildContext context) {
    Color iconColor = Colors.blue;
    return Padding(
      padding: context.paddingAllLow,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IconButton(
            //     padding: EdgeInsets.zero,
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     icon: Icon(
            //       Icons.arrow_back,
            //       size: 35,
            //       color: iconColor,
            //     )),
            // SizedBox(
            //   height: context.dynamicHeight(0.01),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: iconColor,
                        )),
                    SizedBox(
                      width: context.dynamicHeight(0.01),
                    ),
                    CircleAvatar(
                      child: widget.post.userImage != null &&
                              widget.post.userImage != ""
                          ? ClipOval(
                              child: Image.network(widget.post.userImage!))
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                    Padding(
                      padding: context.paddingLeftLow,
                      child: Text(
                        widget.post.userName ?? 'User Name',
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 35,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              height: 0.1,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
