import 'package:flutter/material.dart';

class Appointmentlist extends StatelessWidget {
  const Appointmentlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 138, 201, 250),
      )
    );
  }
}