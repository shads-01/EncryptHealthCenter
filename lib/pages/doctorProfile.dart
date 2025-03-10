import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'bookingScreen.dart';

class DoctorProfile extends StatelessWidget {
  final String doctorId;

  const DoctorProfile({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            print(snapshot);
            return const Center(child: Text('Doctor not found'));
          }

          var doctorData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      doctorData['image'],
                    )
                ),
                SizedBox(height: 15),
                Text(
                  doctorData['name'] ?? 'Doctor Name',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  doctorData['specification'] ?? 'Specialist',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < doctorData['rating'].floor(); i++)
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.indigoAccent,
                        size: 25,
                      ),
                    if (doctorData['rating'] % 1 != 0)
                      const Icon(
                        Icons.star_half_rounded,
                        color: Colors.indigoAccent,
                        size: 25,
                      ),
                    for (var i = 0; i < (5 - doctorData['rating']).floor(); i++)
                      const Icon(
                        Icons.star_border_rounded,
                        color: Colors.black12,
                        size: 25,
                      ),
                  ],
                ),

                SizedBox(height: 10),
                Text(
                  doctorData['description'] ?? 'No description available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.black54),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        doctorData['address'] ?? 'Unknown Location',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      doctorData['phone'].toString() ?? 'Not Available',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded),
                    SizedBox(width: 8),
                    Text(
                      'Working Hours: ${doctorData['openHour'] ?? 'N/A'} - ${doctorData['closeHour'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.blue[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(doctorName: doctorData['name'] ?? '', doctorSpecification: doctorData['specification'] ?? '', docId: doctorData['docId'] ?? ''),
                        ),
                      );
                    },
                    child: Text(
                      'Book an Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
