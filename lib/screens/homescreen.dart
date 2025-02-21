import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black,
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        title: Text('Home Screen', style: GoogleFonts.adamina(
             // fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color:  const Color.fromARGB(255, 166, 221, 209),
            ),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Dummy Home Screen!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.tealAccent,
                 fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Go to Details Page'),
            ),
          ],
        ),
      ),
    );
  }
}
