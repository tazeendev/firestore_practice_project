import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/student_registration_project/auth_screens/text_feild_widget/text_feild_widget.dart';
import 'package:firebase_app/student_registration_project/home_screen/fetch_user_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rollNumberController = TextEditingController();
  TextEditingController marksController = TextEditingController();

  bool isLoading = false;
  String? selectedDepartment;
  final List<String> departments = [
    'Computer Science',
    'Electrical',
    'Artificial Intelligence',
    'Civil',
    'Mathematics',
  ];
  void createData() async {
    if (nameController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        rollNumberController.text.isEmpty ||
        marksController.text.isEmpty ||
        selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    String customId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore.instance
        .collection('StudentRegisterForm')
        .doc(customId)
        .set({
      'name': nameController.text.trim(),
      'father_name': fatherNameController.text.trim(),
      'email': emailController.text.trim(),
      'roll_number': rollNumberController.text.trim(),
      'marks': marksController.text.trim(),
      'department': selectedDepartment,
      'created_at': FieldValue.serverTimestamp(),
    }).then((_) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student registered successfully!')),
      );
      nameController.clear();
      fatherNameController.clear();
      emailController.clear();
      rollNumberController.clear();
      marksController.clear();
      setState(() {
        selectedDepartment = null;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register student: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Register Student'),
        centerTitle: true,
        elevation: 0,
        actions: [
          FloatingActionButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FetchUserData()));
          })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Student Registration",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Fill in the details below",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Name
            CustomTextField(
              controller: nameController,
              textInputType: TextInputType.text,
              hintText: 'Student Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),

            // Father's Name
            CustomTextField(
              controller: fatherNameController,
              textInputType: TextInputType.text,
              hintText: "Father's Name",
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            // Email
            CustomTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              hintText: "Email Address",
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),

            // Roll Number
            CustomTextField(
              controller: rollNumberController,
              textInputType: TextInputType.number,
              hintText: "Roll Number",
              prefixIcon: Icons.confirmation_num,
            ),
            const SizedBox(height: 16),

            // Marks
            CustomTextField(
              controller: marksController,
              textInputType: TextInputType.number,
              hintText: "Marks",
              prefixIcon: Icons.grade,
            ),
            const SizedBox(height: 16),

            // Department Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedDepartment,
                hint: const Text("Select Department"),
                items: departments.map((dept) {
                  return DropdownMenuItem<String>(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                },
                underline: const SizedBox(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : createData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Register Student",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
