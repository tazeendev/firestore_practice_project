import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FetchUserData extends StatefulWidget {
  const FetchUserData({super.key});
  @override
  State<FetchUserData> createState() => _FetchUserDataState();
}

class _FetchUserDataState extends State<FetchUserData> {
  // Delete student by document ID
  void deleteData(String docId) async {
    await FirebaseFirestore.instance
        .collection("StudentRegisterForm")
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete student: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Students'),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('StudentRegisterForm')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var student = docs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(student['name'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Father's Name: ${student['father_name'] ?? ''}"),
                      Text("Email: ${student['email'] ?? ''}"),
                      Text("Roll Number: ${student['roll_number'] ?? ''}"),
                      Text("Marks: ${student['marks'] ?? ''}"),
                      Text("Department: ${student['department'] ?? ''}"),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Student'),
                        content: const Text('Are you sure you want to delete this student?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              deleteData(student.id);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
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
