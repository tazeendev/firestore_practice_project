import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app/student_registration_project/auth_screens/text_feild_widget/text_feild_widget.dart';

// ---------- Add Student ----------
class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(title: const Text('Add Student',style: TextStyle(color: Colors.blue),),centerTitle: true,backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              controller: nameController,
              hintText: 'Name',
              prefixIcon: Icons.person,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: fatherController,
              hintText: 'Father Name',
              prefixIcon: Icons.person,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              prefixIcon: Icons.email,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                final userId = DateTime.now().microsecond.toString();
                await FirebaseFirestore.instance
                    .collection('userData')
                    .doc(userId)
                    .set({
                      'Name': nameController.text,
                      'FatherName': fatherController.text,
                      'Email': emailController.text,
                      'userId': userId,
                    })
                    .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>FetchStudentsScreen())));
              },
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Fetch Students ----------
class FetchStudentsScreen extends StatelessWidget {
  const FetchStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('userData').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final student = docs[index];
              return ListTile(
                title: Text(student['Name'] ?? 'No Name'),
                subtitle: Text(student['Email'] ?? 'No Email'),
                trailing: IconButton(
                  icon:Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DepartmentScreen(userId: student.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ---------- Add Department ----------
class DepartmentScreen extends StatefulWidget {
  final String userId;
  const DepartmentScreen({super.key, required this.userId});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  TextEditingController depController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Departments')),
      body: Column(
        children: [
           SizedBox(height: 20),
          CustomTextField(
            controller: depController,
            hintText: 'Department',
            prefixIcon: Icons.cast_for_education,
            textInputType: TextInputType.text,
          ),
           SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (depController.text.isEmpty) return;
              await FirebaseFirestore.instance
                  .collection('userData')
                  .doc(widget.userId)
                  .collection('departData')
                  .add({'depart': depController.text});
              depController.clear();
            },
            child: Text('Add Department'),
          ),
           SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userData')
                  .doc(widget.userId)
                  .collection('departData')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final depDocs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: depDocs.length,
                  itemBuilder: (context, index) {
                    final dep = depDocs[index];
                    return ListTile(
                      title: Text(dep['depart'] ?? 'No Department'),
                      trailing: IconButton(
                        icon:  Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SemesterScreen(
                                userId: widget.userId,
                                depId: dep.id,
                              ),
                            ),
                          );
                        },
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

// ---------- Add Semester ----------
class SemesterScreen extends StatefulWidget {
  final String userId;
  final String depId;
  const SemesterScreen({super.key, required this.userId, required this.depId});

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  TextEditingController semController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semesters')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CustomTextField(
            controller: semController,
            hintText: 'Semester',
            prefixIcon: Icons.school,
            textInputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('userData')
                  .doc(widget.userId)
                  .collection('departData')
                  .doc(widget.depId)
                  .collection('semesterData')
                  .add({'semester': semController.text});
              semController.clear();
            },
            child: const Text('Add Semester'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userData')
                  .doc(widget.userId)
                  .collection('departData')
                  .doc(widget.depId)
                  .collection('semesterData')
                  .snapshots(),
              builder: (context, snapshot) {
                final semDocs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: semDocs.length,
                  itemBuilder: (context, index) {
                    final sem = semDocs[index];
                    return ListTile(
                      title: Text(sem['semester'] ?? 'No Semester'),
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
