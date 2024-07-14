import 'package:chatapp1/constants.dart';
import 'package:chatapp1/helper/show_snack_bar.dart';
import 'package:chatapp1/pages/chat_page.dart';
import 'package:chatapp1/pages/register_page.dart';
import 'package:chatapp1/widgets/custom_button.dart';
import 'package:chatapp1/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static String id = 'Login page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;
  bool isloading = false;

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
                      'LOGIN',
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
                        await loginuser();
                        showsnackbar(context, 'successfully registered');
                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showsnackbar(context, 'user not found');
                        } else if (e.code == 'wrong-password') {
                          showsnackbar(context, 'wrong password');
                        }
                      } catch (e) {
                        showsnackbar(context, 'there was an error');
                      }
                      isloading = false;
                      setState(() {});
                    } else {}
                  },
                  text: 'LOGIN',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'don\'t have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: const Text(
                        '  REGISTER',
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

  Future<void> loginuser() async {
    UserCredential user =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
