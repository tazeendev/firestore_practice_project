import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/student_registration_project/home_screen/update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FetchUserData extends StatefulWidget {
  const FetchUserData({super.key});
  @override
  State<FetchUserData> createState() => _FetchUserDataState();
}

class _FetchUserDataState extends State<FetchUserData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registered Students', // title english hi rakha
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),

      // yahan se data firestore se realtime stream mn aata hai
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),

        builder: (context, snapshot) {
          // agar abhi data load ho raha hai to circular loader dikhao
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // agar koi error aaya to wo show karo
          if (snapshot.hasError) {
            return Center(child: Text("Error aaya: ${snapshot.error}"));
          }

          // agar data empty hai to message show karo
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Abhi tak koi student add nahi hua"));
          }

          final docs = snapshot.data!.docs;

          // listview builder lagaya students dikhane ke liye
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final student = docs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text("Name: ${student['name'] ?? ''}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Father Name: ${student['father_name'] ?? ''}"),
                      Text("Email: ${student['email'] ?? ''}"),
                      Text("Roll Number: ${student['roll_number'] ?? ''}"),
                      Text("Marks: ${student['marks'] ?? ''}"),
                      Text("Department: ${student['department'] ?? ''}"),

                      const SizedBox(height: 15),

                      // update button
                      Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xff113F67),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // yahan se update screen pe jao
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditStudentScreen(
                                  customId: student.id,
                                  studentData: student.data(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Update Screen',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // jab kisi card pe tap karo to delete ka dialog khulta hai
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Student'),
                        content: const Text(
                            'Kya aap sure hain k ye student delete karna hai?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection(
                                  FirebaseAuth.instance.currentUser!.uid)
                                  .doc(student.id)
                                  .delete()
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Student successfully delete ho gaya!'),
                                  ),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                    Text('Delete fail hua: $error'),
                                  ),
                                );
                              });
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
