import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eh/pages/myAppointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final String doctorName;
  final String doctorSpecification;
  final String docId;

  const BookingScreen({
    super.key,
    required this.doctorName,
    required this.doctorSpecification,
    required this.docId, // Corrected to match Firestore
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? _uid;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid; // Store the UID
      });
    }
  }

  // Function to pick date
  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Function to pick time
  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _bookAppointment() async {
    if (_nameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields."),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctor': widget.doctorName,
        'docId': widget.docId, // Corrected field name
        'patient': _nameController.text,
        'uid': _uid, // Corrected field name for user ID
        'description': _descriptionController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'phone': _mobileController.text, // Added missing field
        'status': 'pending',
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Appointment booked successfully!"),
          backgroundColor: Colors.green,
          showCloseIcon: true,
        ),
      );

      // Clear input fields after successful booking
      _nameController.clear();
      _mobileController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _timeController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyAppointments()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error booking appointment: $e"),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Book Appointment",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'lib/images/appointment.jpg',
                  height: 200,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Doctor Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Dr. ${widget.doctorName}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(
                      widget.doctorSpecification,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter Patient Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTextField("Patient Name*", _nameController),
              _buildTextField("Mobile*", _mobileController),
              _buildTextField("Description", _descriptionController),
              const SizedBox(height: 10),
              _buildDateTimeField("Select Date", _dateController, _selectDate, Icons.calendar_today),
              const SizedBox(height: 10),
              _buildDateTimeField("Select Time", _timeController, _selectTime, Icons.access_time),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Book Appointment",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(String label, TextEditingController controller, VoidCallback onTap, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

