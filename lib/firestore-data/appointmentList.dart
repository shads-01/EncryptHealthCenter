import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _documentID;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {}); // Update UI once the user is fetched
    }
  }

  Future<void> deleteAppointment(String docID) async {
    if (_user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(docID) // Directly using the appointment document ID
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Appointment deleted successfully."),
          backgroundColor: Colors.green,
          showCloseIcon: true,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete appointment: $e"),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
    }
  }

  void showAlertDialog(BuildContext context, String docID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this appointment?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                deleteAppointment(docID);
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.grey[100],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('uid', isEqualTo: _user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Appointments Scheduled',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];

              String doctorName = document['doctor'];
              String date = document['date'];
              String time = document['time'];
              String patientName = document['patient']; // Corrected field name

              return Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide.none,
                ),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide.none,
                  ),
                  backgroundColor: Colors.white,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    "Dr. $doctorName",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  collapsedTextColor: Colors.black,
                  textColor: Colors.blue,
                  iconColor: Colors.blue,

                  subtitle: Text("Date: $date"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patient Name: $patientName",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Time: $time",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          IconButton(
                            tooltip: 'Delete Appointment',
                            icon: const Icon(Icons.delete, color: Colors.black,),
                            onPressed: () => showAlertDialog(context, document.id),
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
