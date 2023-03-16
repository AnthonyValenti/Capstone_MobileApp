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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bkg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const GoogleSignInWidget(),
      ),
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
  bool visBool = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  User? user;
  User? emailUser;
  String? name = "";

  Future<void> login() async {
    try {
      emailUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text, password: passController.text))
          .user;
      login();
    } on FirebaseAuthException catch (e) {
      setState(() {
        visBool = true;
      });
    }
    if (user != null || emailUser != null) {
      setState(() {
        signedIn = true;
      });
      if (signedIn == true) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "GK02: Smart System",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 50),
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/login.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 60),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            onSubmitted: (value) async {},
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'email',
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            obscureText: true,
            controller: passController,
            cursorColor: Colors.white,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            onSubmitted: (value) async {},
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: 'password',
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, fixedSize: const Size(300, 50)),
            onPressed: () {
              login();
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
                        login();
                      } catch (e) {
                        if (e is FirebaseAuthException) {
                          print(e.message!);
                        }
                      }
                    },
                  ))),
          const SizedBox(height: 20),
          if (visBool == true)
            const Text(
              'Incorrect username or email',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
