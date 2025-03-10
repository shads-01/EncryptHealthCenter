// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:eh/pages/categoryDoctorList.dart';
import 'package:eh/pages/homeSlider.dart';
import 'package:flutter/material.dart';
import 'package:eh/pages/appointmentList.dart';
import 'package:eh/pages/searchPage.dart';
import 'package:eh/pages/userProfile.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../firestore-data/topRatedList.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: HomeSlider(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20, top: 20),
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
        SizedBox(
            height: 135,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            categoryDoctorList(category: cards[index].doctor),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 14),
                    width: 135,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
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
                        SizedBox(height: 10),
                        Text(
                          cards[index].doctor,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20, top: 20),
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
        // SizedBox(height: 20),
        Expanded(child: TopRatedList()),
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
  new Cards("Medicine", 0xFFec407a, TablerIcons.medicine_syrup),
  new Cards("Cardiologist", 0xFF1565C0, TablerIcons.heartbeat),
  new Cards("Neurologist", 0xFFF6A192, TablerIcons.brain),
  new Cards("Paediatrician", 0xFF2E7D32, TablerIcons.baby_carriage_filled),
  new Cards("Gynecologist", 0xFFE91E63, Icons.pregnant_woman_rounded),
  new Cards("Pulmonologist", 0xFFE34E45, TablerIcons.lungs_filled),
  new Cards("Dentist", 0xFDE34E87, TablerIcons.dental),
];
