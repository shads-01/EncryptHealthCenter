import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/doctorProfile.dart';

class TopRatedList extends StatefulWidget {
  @override
  _TopRatedListState createState() => _TopRatedListState();
}

class _TopRatedListState extends State<TopRatedList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 8,
            itemBuilder: (context, index) {
              DocumentSnapshot doctor =
                  snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Card(
                  color: Colors.blue[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 10,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorProfile(
                              doctorId: doctor['docId'],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(doctor['image']),
                            radius: 25,
                          ),
                          const SizedBox(width: 10),

                          // Wrap Name and Specification inside Expanded to prevent overflow
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doctor['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  overflow:
                                      TextOverflow.ellipsis, // Prevent overflow
                                  maxLines: 1, // Show only one line
                                ),
                                Text(
                                  doctor['specification'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  overflow:
                                      TextOverflow.ellipsis, // Prevent overflow
                                  maxLines: 1, // Show only one line
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Rating Section
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.indigo[400],
                              ),
                              const SizedBox(width: 3),
                              Text(
                                doctor['rating'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
