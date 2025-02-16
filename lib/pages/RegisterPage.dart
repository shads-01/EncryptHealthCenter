import 'package:flutter/material.dart';
import 'package:eh/components/my_button.dart';
import 'package:eh/components/my_textfield.dart';
import 'package:eh/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();

  String? selectedGender;
  String? selectedBloodGroup;

  final List<String> genders = ["Male", "Female", "Other"];
  final List<String> bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];

  void pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void registerUser() {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Patient Registration"),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // First Name
              MyTextField(
                controller: firstNameController,
                hintText: "First Name",
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // Last Name
              MyTextField(
                controller: lastNameController,
                hintText: "Last Name",
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // Gender Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  hint: const Text("Select Gender"),
                  items: genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Date of Birth
              GestureDetector(
                onTap: pickDate,
                child: AbsorbPointer(
                  child: MyTextField(
                    controller: dobController,
                    hintText: "Date of Birth (DD/MM/YYYY)",
                    obscureText: false,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Blood Group Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: selectedBloodGroup,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  hint: const Text("Select Blood Group"),
                  items: bloodGroups.map((group) {
                    return DropdownMenuItem(
                      value: group,
                      child: Text(group),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBloodGroup = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Contact Number
              MyTextField(
                controller: contactController,
                hintText: "Contact Number",
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // Email
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // Create Password
              MyTextField(
                controller: passwordController,
                hintText: "Create Password",
                obscureText: true,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // Address
              MyTextField(
                controller: addressController,
                hintText: "Address",
                obscureText: false,
              ),

              const SizedBox(height: 25),

              // Register Button
              MyButton(
                onTap: registerUser,
                text: "Register",
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
