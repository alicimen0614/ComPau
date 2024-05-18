import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    this.textInputType = TextInputType.text,
    this.autoCorrect = true,
    required this.prefixIconData,
    required this.validator,
    this.obscureText = false,
    this.useSuffixIcon = false,
    required this.label,
  });

  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool autoCorrect;
  final IconData prefixIconData;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool useSuffixIcon;
  final String label;
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
        label: Text(
          label,
        ),
        labelStyle: Theme.of(context).textTheme.titleMedium,
        suffixIcon:
            useSuffixIcon == true ? const Icon(Icons.remove_red_eye) : null,
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding: const EdgeInsets.all(15),
        prefixIcon:
            Icon(prefixIconData, size: 32, color: const Color(0xFFFBA834)),
        border: InputBorder.none,
      ),
    );
  }
}
