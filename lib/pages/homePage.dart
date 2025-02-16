// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:eh/pages/appointmentList.dart';
import 'package:eh/pages/searchPage.dart';
import 'package:eh/pages/userProfile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20, top: 100),
          child: Text(
            "Specialists",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 14),
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(cards[index].cardBackground),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400]!,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 29,
                        child: Icon(
                          cards[index].cardIcon,
                          size: 26,
                          color: Color(cards[index].cardBackground),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        cards[index].doctor,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20, top: 30),
          child: Text(
            "Top Rated Doctors",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: doctorCards.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(doctorCards[index].imagePath),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorCards[index].name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            doctorCards[index].designation,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.star, size: 15, color: Colors.blueAccent,),
                    Text(doctorCards[index].rating.toString(), style: TextStyle(fontSize: 12),),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Cards {
  String doctor;
  int cardBackground;
  var cardIcon;

  Cards(this.doctor, this.cardBackground, this.cardIcon);
}

List<Cards> cards = [
  new Cards("General", 0xFFec407a, Icons.medical_services_rounded),
  new Cards("Orthopaedic", 0xFF1565C0, Icons.wheelchair_pickup_sharp),
  new Cards("Paediatrician", 0xFF2E7D32, Icons.child_care),
  new Cards("Gynecologist", 0xFFE91E63, Icons.woman_2),
];

class DoctorCards {
  String name;
  String designation;
  String imagePath;
  double rating = 0;

  DoctorCards(this.name, this.designation, this.imagePath, this.rating);
}

List<DoctorCards> doctorCards = [
  new DoctorCards("Doctor 1", "Cardiologist", "", 4.2),
  new DoctorCards("Doctor 2", "General", "", 4.7),
  new DoctorCards("Doctor 3", "Dentist", "", 4),
];
