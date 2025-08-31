
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../student_registration_project/auth_screens/text_feild_widget/text_feild_widget.dart';
class SemesterScreen extends StatefulWidget {
  final String depId;
  const SemesterScreen({super.key, required this.depId});

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  TextEditingController semController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Top half-circle gradient header
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.lightBlue, Colors.blueAccent]),
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
                    'Semesters',
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
          const SizedBox(height: 30),
          // Input + Add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: semController,
                    hintText: 'Semester',
                    prefixIcon: Icons.school,
                    textInputType: TextInputType.text,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (semController.text.isEmpty) return ;
                    await FirebaseFirestore.instance
                        .collection('departments')
                        .doc(widget.depId)
                        .collection('semester')
                        .add({
                      'semester': semController.text,
                      'createdAt': Timestamp.now()
                    });
                    semController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Text('Add', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Semester List with Flip Cards
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('departments')
                  .doc(widget.depId)
                  .collection('semester')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final semDocs = snapshot.data!.docs;
                if (semDocs.isEmpty) return const Center(child: Text('No Semesters Found'));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: semDocs.length,
                  itemBuilder: (context, index) {
                    final sem = semDocs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        front: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.lightBlue.shade200, Colors.blueAccent.shade200]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.school, color: Colors.white),
                            title: Text(
                              sem['semester'] ?? 'No Semester',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              'Tap to manage',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        back: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sem['semester'] ?? 'No Semester',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () async {
                                      TextEditingController editController =
                                      TextEditingController(text: sem['semester']);
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Edit Semester"),
                                          content: TextField(controller: editController),
                                          actions: [
                                            TextButton(
                                                onPressed: () => Navigator.pop(ctx),
                                                child: const Text("Cancel")),
                                            TextButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('departments')
                                                    .doc(widget.depId)
                                                    .collection('semester')
                                                    .doc(sem.id)
                                                    .update({'semester': editController.text});
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('departments')
                                          .doc(widget.depId)
                                          .collection('semesterData')
                                          .doc(sem.id)
                                          .delete();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
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

