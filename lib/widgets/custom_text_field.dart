import 'package:flutter/material.dart';

class CustomTextFromField extends StatefulWidget {
  CustomTextFromField({
    super.key,
    this.hintext,
    this.onChanged,
    this.obscureText = false,
  });

  Function(String)? onChanged;
  String? hintext;

  bool? obscureText;

  @override
  State<CustomTextFromField> createState() => _CustomTextFromFieldState();
}

class _CustomTextFromFieldState extends State<CustomTextFromField> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: passwordVisible ? false : widget.obscureText!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'This field cannot be empty';
        }
      },
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(
              () {
                passwordVisible = !passwordVisible;
              },
            );
          },
        ),
        hintText: widget.hintext,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
    );
  }
}
