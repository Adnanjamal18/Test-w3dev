import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:interntest/screens/tabs.dart';
import 'package:lottie/lottie.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  @override
  Widget build(BuildContext context) {
   
Future<void> showSuccessDialog(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Successfully Logged In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 10),
            Text(user?.displayName ?? 'Anonymous'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => BottomNavBar()),
              );
            },
            child: const Text("OK"),
            style: TextButton.styleFrom(
              minimumSize: const Size(141, 50),
              backgroundColor: const Color.fromRGBO(223, 207, 196, 1),
              foregroundColor: const Color.fromRGBO(125, 66, 26, 1),
            ),
          ),
        ],
      );
    },
  );
}



Future<void> _handleGoogleSignIn(BuildContext context) async {
  try {
  
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser == null) return;
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email, 
      'displayName': user.displayName, 
      'photoURL': user.photoURL, 
    });


if (mounted) {
  setState(() {
    showSuccessDialog(context);
  });
}

  } catch (e) {
    print("Google Sign-In Error: $e");
  }
}

 final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
 return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.3,
            child:  Lottie.asset('assets/loties/Animation - 1740077316567.json'),
          ),
           SizedBox(height: 20),
          Text(
            'Login using google Account',
            style: GoogleFonts.adamina(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color:  const Color.fromARGB(255, 103, 112, 110),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          ElevatedButton.icon(
            onPressed: () => _handleGoogleSignIn(context),
            icon:  Image.asset(
              'assets/icons/pngwin.png',
              height: screenHeight * 0.03,
            ),
            label:  Text(
              "Continue with Google",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 51, 61, 59),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              minimumSize:  Size(screenWidth * 0.8, screenHeight * 0.06),
              padding:
                  EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02, horizontal: screenWidth * 0.06
                    ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.08),
                side: const BorderSide(color: Colors.tealAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
