import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String gender = '';
  String bloodGroup = '';
  DateTime? dob;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _firstNameController.text = userDoc['First Name'] ?? '';
          _lastNameController.text = userDoc['Last Name'] ?? '';
          _contactNumberController.text = userDoc['Contact Number'] ?? '';
          _addressController.text = userDoc['Address'] ?? '';
          gender = userDoc['Gender'] ?? '';
          bloodGroup = userDoc['Blood Group'] ?? '';

          String dobStr = userDoc['Date of Birth'] ?? '';
          print("Fetched DOB from Firestore: $dobStr");

          if (dobStr.isNotEmpty) {
            try {
              dob = DateFormat('dd/MM/yyyy').parse(dobStr);
              _dobController.text = DateFormat('dd/MM/yyyy').format(dob!);
            } catch (_) {
              dob = null;
              _dobController.text = '';
            }
          }
        });
      }
    }
  }

  Future<void> saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'First Name': _firstNameController.text.trim(),
        'Last Name': _lastNameController.text.trim(),
        'Contact Number': _contactNumberController.text.trim(),
        'Address': _addressController.text.trim(),
        'Gender': gender,
        'Blood Group': bloodGroup,
        'Date of Birth': dob != null ? DateFormat('dd/MM/yyyy').format(dob!) : '',
      });
      Navigator.pop(context);
    }
  }

  Future<void> pickDateOfBirth() async {
    final DateTime initialDate = dob ?? DateTime(2000);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dob = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.grey[500],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('First Name', _firstNameController),
              buildTextField('Last Name', _lastNameController),
              buildTextField('Contact Number', _contactNumberController),
              buildTextField('Address', _addressController),
              buildDropdownField('Gender', genderOptions, gender, (val) => setState(() => gender = val)),
              buildDropdownField('Blood Group', bloodGroups, bloodGroup, (val) => setState(() => bloodGroup = val)),
              buildDatePickerField('Date of Birth', _dobController, pickDateOfBirth),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: saveUserData,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> options, String selectedValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: options.contains(selectedValue) ? selectedValue : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        validator: (val) => val == null || val.isEmpty ? 'Please select $label' : null,
      ),
    );
  }

  Widget buildDatePickerField(String label, TextEditingController controller, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Please select $label' : null,
          ),
        ),
      ),
    );
  }
}
