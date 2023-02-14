import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'authentication.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Login',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.grey,
      ),
      body: const GoogleSignInWidget(),
    ));
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
  String? name = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "Welcome!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          const Text(
            "Login to continue",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 200),
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
                            name = user!.displayName;
                          });
                        }
                      } catch (e) {
                        if (e is FirebaseAuthException) {
                          print(e.message!);
                        }
                      }
                      if (signedIn == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }
                    },
                  ))),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
