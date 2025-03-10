import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eh/pages/login_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String firstName = "";
  String lastName = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          firstName = userDoc["First Name"] ?? "";
          lastName = userDoc["Last Name"] ?? "";
          email = user.email ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsetsDirectional.only(top: 80),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREmaQdvWJzdLZ2M0QpDmDxHXY5K_5Uz2ZSNg&s'),
            ),
            SizedBox(height: 16),
            Text(
              "$firstName $lastName",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
              child: Column(
                children: [
                  buildProfileButton('Edit Profile', Icons.edit),
                  SizedBox(height: 10),
                  buildProfileButton('Settings', Icons.settings),
                  SizedBox(height: 10),
                  buildProfileButton('Appointment History', Icons.description),
                  SizedBox(height: 10),
                  buildProfileButton('Medical History', Icons.history),
                  SizedBox(height: 10),
                  buildProfileButton('Help and Support', Icons.help),
                ],
              ),
            ),
            SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Ensures text contrasts well with the background
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

Widget buildProfileButton(String title, IconData icon) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),
        Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ],
    ),
  );
}
