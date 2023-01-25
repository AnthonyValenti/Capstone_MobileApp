import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../authentication.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.grey,
      ),
      body: const Center(
        child: GoogleSignInWidget(),
      ),
    );
  }
}

class GoogleSignInWidget extends StatefulWidget {
  const GoogleSignInWidget({super.key});

  @override
  State<GoogleSignInWidget> createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  bool signedIn = false;
  User? user;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
              width: 300,
              height: 80,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      try {
                        user = await Authentication.signInWithGoogle(
                            context: context);

                        if (user != null && mounted) {
                          setState(() {
                            signedIn = true;
                          });
                          print(user?.displayName);
                        }
                      } catch (e) {
                        if (e is FirebaseAuthException) {
                          print(e.message!);
                        }
                      }
                    },
                  ))),
          const SizedBox(height: 100),
          Text(
            "Name: $name",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
