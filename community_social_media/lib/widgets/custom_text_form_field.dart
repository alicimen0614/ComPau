import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.textEditingController,
      this.textInputType = TextInputType.text,
      this.autoCorrect = true,
      required this.hintText,
      required this.prefixIconData,
      required this.validator,
      this.obscureText = false,
      this.useSuffixIcon = false});

  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool autoCorrect;
  final String hintText;
  final IconData prefixIconData;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool useSuffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      cursorColor: Colors.black,
      onEditingComplete: () {},
      controller: textEditingController,
      keyboardType: textInputType,
      autocorrect: autoCorrect,
      decoration: InputDecoration(
        suffixIcon:
            useSuffixIcon == true ? const Icon(Icons.remove_red_eye) : null,
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding: const EdgeInsets.all(15),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF124076),
            ),
            borderRadius: BorderRadius.circular(15)),
        prefixIcon:
            Icon(prefixIconData, size: 32, color: const Color(0xFFFBA834)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
