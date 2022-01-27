import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapbox_flutter/services/auth_social.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  String userEmail = "Belum Login";

  void _onSubmit() async {
    UserCredential user = await AuthSocial().signInWithGoogle();

    getEmail();

    // setState(() => _isLoading = true);
    // Future.delayed(
    //   const Duration(seconds: 2),
    //   () => setState(() => _isLoading = false),
    // );
  }

  Future<void> getEmail() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // userEmail = prefs.getString('email').toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Email : $userEmail"),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.black.withOpacity(.6)),
              icon: _isLoading
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Image.asset(
                      'assets/icons/google.png',
                      width: 24,
                      height: 24,
                    ),
              label: const Text('Login with Google'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.black.withOpacity(.6)),
              icon: Icon(Icons.logout),
              label: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
