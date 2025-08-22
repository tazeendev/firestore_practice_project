import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app/student_registration_project/auth_screens/text_feild_widget/text_feild_widget.dart';
class EditStudentScreen extends StatefulWidget {
  final String customId;
  final  Map<String,dynamic> studentData;
  const EditStudentScreen({
    super.key,
    required this.customId,
    required this.studentData,
  });
  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}
class _EditStudentScreenState extends State<EditStudentScreen> {
  late TextEditingController nameController;
  late TextEditingController fatherNameController;
  late TextEditingController emailController;
  late TextEditingController rollNumberController;
  late TextEditingController marksController;
  String? selectedDepartment;
  final List<String> departments = [
    'Computer Science',
    'Electrical',
    'Artificial Intelligence',
    'Civil',
    'Mathematics',
  ];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.studentData['name']);
    fatherNameController =
        TextEditingController(text: widget.studentData['father_name']);
    emailController =
        TextEditingController(text: widget.studentData['email']);
    rollNumberController =
        TextEditingController(text: widget.studentData['roll_number']);
    marksController =
        TextEditingController(text: widget.studentData['marks']);
    selectedDepartment = widget.studentData['department'];
  }
  void updateStudent() async {
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
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(widget.customId)
        .update({
      'name': nameController.text.trim(),
      'father_name': fatherNameController.text.trim(),
      'email': emailController.text.trim(),
      'roll_number': rollNumberController.text.trim(),
      'marks': marksController.text.trim(),
      'department': selectedDepartment,
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated successfully!')),
      );
      Navigator.of(context).pop();
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update student: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              textInputType: TextInputType.text,
              hintText: 'Student Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: fatherNameController,
              textInputType: TextInputType.text,
              hintText: "Father's Name",
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              hintText: "Email Address",
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: rollNumberController,
              textInputType: TextInputType.number,
              hintText: "Roll Number",
              prefixIcon: Icons.confirmation_num,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: marksController,
              textInputType: TextInputType.number,
              hintText: "Marks",
              prefixIcon: Icons.grade,
            ),
            const SizedBox(height: 16),
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
                onPressed:  updateStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Update Student",
                  style: TextStyle(
                    color: Colors.white,
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
