import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/student_registration_project/home_screen/update_screen.dart';
import 'package:firebase_app/view/screens/firebase_store/fetchdata.dart';
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
        title: const Text('Registered Students',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        actions: [
          Container(
            height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
              ),
              child: TextButton(onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditStudentScreen(
                //   customId:,
                //   studentData: {
                // },)));
              }, child: Text('Update Screen',style: TextStyle(color: Color(0xff113F67)),))),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final student = docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(student['name'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Father Name: ${student['father_name'] ?? ''}"),
                      Text("Email: ${student['email'] ?? ''}"),
                      Text("Roll Number: ${student['roll_number'] ?? ''}"),
                      Text("Marks: ${student['marks'] ?? ''}"),
                      Text("Department: ${student['department'] ?? ''}"),
                    ],
                  ),
                  onLongPress: (){

                  },
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Student'),
                        content: const Text('Are you sure you want to delete this student?'),
                        actions: [
                          TextButton(
                            onPressed: ()async{
                              await FirebaseFirestore.instance
                                  .collection(FirebaseAuth.instance.currentUser!.uid)
                                  .doc(student.id)
                                  .delete()
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Student deleted successfully!')),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to delete student: $error')),
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
