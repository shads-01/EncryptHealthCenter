// ignore_for_file: prefer_const_constructors

import 'package:eh/pages/login_page.dart';
import 'package:flutter/material.dart';

class Userprofile extends StatelessWidget {
  const Userprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsetsDirectional.only(top: 60),
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
              '[username]',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              '[email]',
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
                  buildProfileButton('Favorite', Icons.favorite),
                  SizedBox(height: 10),
                  buildProfileButton('Appointment History', Icons.description),
                  SizedBox(height: 10),
                  buildProfileButton('Medical History', Icons.history),
                  SizedBox(height: 10),
                  buildProfileButton('Help and Support', Icons.help),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 13, 51, 82), fontWeight: FontWeight.w700),
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
    child: Container(
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    ),
  );
}
