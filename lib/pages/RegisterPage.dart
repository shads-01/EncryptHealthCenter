import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eh/components/my_button.dart';
import 'package:eh/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

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
        dobController.text = "\${pickedDate.day}/\${pickedDate.month}/\${pickedDate.year}";
      });
    }
  }

  void registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "First Name": firstNameController.text.trim(),
        "Last Name": lastNameController.text.trim(),
        "Gender": selectedGender,
        "Date of Birth": dobController.text.trim(),
        "Blood Group": selectedBloodGroup,
        "Contact Number": contactController.text.trim(),
        "Email": emailController.text.trim(),
        "Address": addressController.text.trim(),
        "uid": uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful!"), backgroundColor: Colors.green),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      if (e.code == 'email-already-in-use') {
        errorMessage = "The email is already registered.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: \$e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (value) => value!.isEmpty ? "First name is required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? "Last name is required" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(labelText: "Select Gender"),
                items: genders.map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) => setState(() => selectedGender = value),
                validator: (value) => value == null ? "Please select a gender" : null,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dobController,
                    decoration: const InputDecoration(labelText: "Date of Birth"),
                    validator: (value) => value!.isEmpty ? "Date of Birth is required" : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedBloodGroup,
                decoration: const InputDecoration(labelText: "Select Blood Group"),
                items: bloodGroups.map((group) {
                  return DropdownMenuItem(value: group, child: Text(group));
                }).toList(),
                onChanged: (value) => setState(() => selectedBloodGroup = value),
                validator: (value) => value == null ? "Please select a blood group" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Contact Number"),
                validator: (value) => value!.isEmpty ? "Contact number is required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Email is required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Create Password"),
                validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirm Password"),
                validator: (value) => value != passwordController.text ? "Passwords do not match" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Present Address"),
                validator: (value) => value!.isEmpty ? "Address is required" : null,
              ),
              const SizedBox(height: 10),
              MyButton(
                onTap: registerUser,
                text: "Register",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
