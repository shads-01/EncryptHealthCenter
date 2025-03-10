import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Appointmentlist extends StatefulWidget {
  @override
  _AppointmentlistState createState() => _AppointmentlistState();
}

class _AppointmentlistState extends State<Appointmentlist> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  String? _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
    setState(() {});
  }

  Future<void> deleteAppointment(String docID) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.email)
        .collection('pending')
        .doc(docID)
        .delete();
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this appointment?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                if (_documentID != null) {
                  deleteAppointment(_documentID!);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.grey[200],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'My Appointments',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .doc(user.uid)
            .collection('pending')
            .orderBy('date')
            .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return Center(
              child: Text(
                'No Appointment Scheduled',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
              String date = document['date'];
              String time = document['time'];
              print(document.data());

              return Card(
                color: Colors.white,
                elevation: 2,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(
                      //   document['doctor'],
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                  subtitle: Text(
                    "Date: $date",
                  ),
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 20, right: 10, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patient name: ${document['patient']}",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Time: $time",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          IconButton(
                            tooltip: 'Delete Appointment',
                            icon: Icon(Icons.delete, color: Colors.black87),
                            onPressed: () {
                              _documentID = document.id;
                              showAlertDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}