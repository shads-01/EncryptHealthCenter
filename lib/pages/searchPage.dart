// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctorProfile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              padding: WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              leading: Icon(Icons.search_rounded),
              hintText: 'Search Doctor',
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Rectangular shape
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var filteredDoctors = snapshot.data!.docs.where((doctor) {
                  String name = doctor['name'].toLowerCase();
                  String category = doctor['specification'].toLowerCase();
                  return name.contains(_searchText) || category.contains(_searchText);
                }).toList();

                if (filteredDoctors.isEmpty) {
                  return Center(
                    child: Text(
                      'No doctors found!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    var doctor = filteredDoctors[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(doctor['image']),
                      ),
                      title: Text(doctor['name']),
                      subtitle: Text(doctor['specification']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          SizedBox(width: 5),
                          Text(doctor['rating'].toString()),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorProfile(doctorId: doctor['docId']),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
