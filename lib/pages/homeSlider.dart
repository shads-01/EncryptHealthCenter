import 'dart:async';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  List<String> images = [
    'lib/images/slider1.jpg',
    'lib/images/slider2.jpg',
    'lib/images/slider3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 220,
          margin: EdgeInsets.only(left: 15, right: 15,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 3.0,
                spreadRadius: 1.0,
                offset: Offset(1, 1),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge, // Ensures rounded corners apply
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),
        Positioned(
          bottom: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentPage == index ? 9 : 8,
                height: _currentPage == index ? 9 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.white,
                  border: Border.all(color: Colors.blue),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}