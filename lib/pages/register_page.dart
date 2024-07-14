import 'package:chatapp1/constants.dart';
import 'package:chatapp1/helper/show_snack_bar.dart';
import 'package:chatapp1/pages/chat_page.dart';
import 'package:chatapp1/widgets/custom_button.dart';
import 'package:chatapp1/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

const primarycolor = Color(0xff4E1564);

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  bool isloading = false;
  bool passwordVisible = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                Image.asset(
                  'images/Chatapp.jpg',
                  width: 250,
                  height: 250,
                ),
                const Row(
                  children: [
                    Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFromField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintext: 'Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFromField(
                  obscureText: true,
                  onChanged: (data) {
                    password = data;
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  hintext: 'Password',
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      isloading = true;
                      setState(() {});
                      try {
                        await Registeruser();
                        showsnackbar(context, 'successfully registered');
                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showsnackbar(context, 'weak password');
                        } else if (e.code == 'email-already-in-use') {
                          showsnackbar(context, 'email already in-use');
                        }
                      } catch (e) {
                        showsnackbar(context, 'there was an error');
                      }
                      isloading = false;
                      setState(() {});
                    } else {}
                  },
                  text: 'REGISTER',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'already have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '  Login',
                        style: TextStyle(color: Color(0xffFEB201)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> Registeruser() async {
    UserCredential user =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
