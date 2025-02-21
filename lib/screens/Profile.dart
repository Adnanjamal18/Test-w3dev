import 'dart:typed_data';
import 'dart:convert'; // For encoding and decoding images as base64
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  String? _name;
  String? _email;
  String? _profileImageBase64;
  Uint8List? _profileImageBytes;


  // Future<void> _pickImage() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: 
  //     ImageSource.gallery);
  //     if (pickedFile != null) {
  //       final bytes = await pickedFile.readAsBytes(); // Read image as Uint8List
  //       final base64Image = base64Encode(bytes);

  //       await _updateProfileImage(base64Image);

  //       setState(() {
  //         _profileImageBytes = bytes;
  //       });
  //     }
  //   } catch (error) {
  //     print('Error picking image: $error');
  //   }
  // }

  // Future<void> _updateProfileImage(String base64Image) async {
  //   try {
  //     final currentUser = _firebaseAuth.currentUser;
  //     if (currentUser != null) {
  //       await _firestore.collection('users').doc(currentUser.uid).update({
  //         'profileImageBase64': base64Image,
  //       });

  //       setState(() {
  //         _profileImageBase64 = base64Image;
  //       });
  //     }
  //   } catch (error) {
  //     print('Error updating profile image: $error');
  //   } 
  // }

  Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}

  Widget _buildProfileOption(
    IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon,color: Colors.white,),
      title: Text(title, style: GoogleFonts.adamina(
             // fontSize: 16,
              fontWeight: FontWeight.bold,
              color:  const Color.fromARGB(255, 255, 255, 255),
            ),),
      trailing: Icon(Icons.arrow_forward_ios, size: 16,color: Colors.white,),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 160, 154, 154) ,
        title: Text("Profile", style: GoogleFonts.adamina(
              fontWeight: FontWeight.bold,
              color:  const Color.fromARGB(255, 103, 112, 110),
            ),),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              // onTap: () {
              //   _pickImage();
              // },
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(    
                  color: Colors.black,    
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:  Colors.tealAccent, 
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 30,
                       backgroundImage:user?.photoURL != null
                  ? NetworkImage(user!.photoURL!) // Load profile image
                  : null,
                   child: user?.photoURL == null
                  ? Icon(Icons.person, size: 50) // Fallback icon
                  : null,
                           ),

                    SizedBox(width: 16), // Fixed SizedBox syntax
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         user?.displayName ?? 'Anonymous',
                          style:   GoogleFonts.adamina(
              //fontSize: 18,
              fontWeight: FontWeight.bold,
              color:  const Color.fromARGB(255, 103, 112, 110),
            ),
                        ),
                        Text(
                          user!.email!,
                          style: GoogleFonts.adamina(
              //fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color:  const Color.fromARGB(255, 103, 112, 110),
            ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.edit, ),
                      onPressed: () {
                        
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            _buildProfileOption(Icons.person, "Account", () {}),
            _buildProfileOption(Icons.color_lens, "Appearance", () {}),
            _buildProfileOption(Icons.notifications, "Notification", () {}),
            _buildProfileOption(Icons.privacy_tip, "Privacy", () {}),
            _buildProfileOption(Icons.help, "Help", () {}),
            _buildProfileOption(Icons.share, "Invite Your Friends", () {}),
             _buildProfileOption(Icons.logout, "logout", () {signOut();}),
          ],
        ),
      ),
    );
  }
}