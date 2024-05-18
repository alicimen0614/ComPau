import 'package:community_social_media/const/context_extension.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.btnTitle,
    required this.onPressed,
    this.btnColor = Colors.blue,
    this.textColor = Colors.black,
    this.borderRadius = 8.0,
    this.paddingVertical = 10.0,
    this.paddingHorizontal = 15.0,
    this.mrgHorizontal = 5.0,
    this.mrgVertical = 5.0,
  }) : super(key: key);

  final String btnTitle;
  final VoidCallback onPressed;
  final Color btnColor;
  final Color textColor;
  final double borderRadius;
  final double paddingVertical;
  final double paddingHorizontal;
  final double mrgVertical;
  final double mrgHorizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: mrgVertical,
        horizontal: mrgHorizontal,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(btnColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: paddingVertical,
            horizontal: paddingHorizontal,
          ),
          child: Text(btnTitle, style: context.textTheme.titleMedium),
        ),
      ),
    );
  }
}
