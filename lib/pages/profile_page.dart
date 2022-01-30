import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapbox_flutter/services/auth_social.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  void _onSubmit() async {
    await AuthSocial().signInWithGoogle();

    setState(() {
      print(FirebaseAuth.instance.currentUser);
    });

    // setState(() => _isLoading = true);
    // Future.delayed(
    //   const Duration(seconds: 2),
    //   () => setState(() => _isLoading = false),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profil',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xff504F5E)),
                ),
                SizedBox(
                  height: 20,
                ),
                (FirebaseAuth.instance.currentUser == null)
                    ? isNotLogin()
                    : isLogin()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget isNotLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _onSubmit,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              primary: Colors.black.withOpacity(.6),
              elevation: 2),
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
      ],
    );
  }

  Widget isLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 170,
          child: Container(
            alignment: Alignment(0.0, 2.5),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser!.photoURL.toString()),
              radius: 60.0,
            ),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Text(
          FirebaseAuth.instance.currentUser!.displayName.toString(),
          style: TextStyle(
              fontSize: 25.0,
              color: Colors.blueGrey,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          FirebaseAuth.instance.currentUser!.email.toString(),
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.black45,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              primary: Colors.black.withOpacity(.6),
              elevation: 2),
          icon: Icon(Icons.logout),
          label: const Text('Logout'),
        )
      ],
    );
  }
}
