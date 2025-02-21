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
   
//  final VoidCallback onSignIn; // Callback to notify sign-in
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
              Navigator.pop(context); // Close the dialog
              // Navigate to BottomNavBar after dialog is closed
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
    // Step 1: Sign in with Google
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser == null) return; // User canceled sign-in

    // Step 2: Get Google authentication details
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // Step 3: Create a Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Step 4: Sign in to Firebase with the Google credential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Step 5: Get the signed-in user
    final user = userCredential.user;
    if (user == null) return;

    // Step 6: Store user data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email, 
      'displayName': user.displayName, // Username
      'photoURL': user.photoURL, // Profile Picture URL
    });

    // Step 7: Show Success Dialog and then Navigate to Home Screen
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
