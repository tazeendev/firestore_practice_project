import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app/student_registration_project/auth_screens/text_feild_widget/text_feild_widget.dart';

class AddStudentScreen extends StatefulWidget {
  final String depId;
  final String semsId;
  const AddStudentScreen({super.key, required this.depId, required this.semsId});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> addStudent() async {
    if (nameController.text.isEmpty ||
        fatherController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true);

    final userId = DateTime.now().microsecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(widget.depId)
        .collection('semester')
        .doc(widget.semsId)
        .collection('userData')
        .doc(userId)
        .set({
      'Name': nameController.text,
      'FatherName': fatherController.text,
      'Email': emailController.text,
      'userId': userId,
    });

    setState(() => isLoading = false);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FetchStudentsScreen(depId: widget.depId, semId: widget.semsId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Student Form',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomTextField(
                    controller: nameController,
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: fatherController,
                    hintText: 'Father Name',
                    prefixIcon: Icons.person,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : addStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Add Student',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FetchStudentsScreen extends StatelessWidget {
  final String depId;
  final String semId;
  const FetchStudentsScreen({super.key, required this.depId, required this.semId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
              ),
              Positioned(
                top: 70,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Students List',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('departments')
                  .doc(depId)
                  .collection('semester')
                  .doc(semId)
                  .collection('userData')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No Students Found'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final student = docs[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          student['Name'] ?? 'No Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          student['Email'] ?? 'No Email',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward,
                              color: Colors.lightBlue),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
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
