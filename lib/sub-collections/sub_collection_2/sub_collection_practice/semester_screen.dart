import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/sub-collections/sub_collection_2/sub_collection_practice/sub_collection_practice.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class SemesterScreen extends StatefulWidget {
  final String depId;
  const SemesterScreen({super.key, required this.depId});

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  TextEditingController semController = TextEditingController();
  Future<void> addSemester() async {
    if (semController.text.isEmpty) return;

    final semId = DateTime.now().microsecond.toString(); // safe ID

    await FirebaseFirestore.instance
        .collection('departments')
        .doc(widget.depId)
        .collection('semester')
        .doc(semId)
        .set({
      'semester': semController.text,
    });

    semController.clear();
  }
  Future<void> updateSemester(String semId, String newName) async {
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(widget.depId)
        .collection('semester')
        .doc(semId)
        .update({'semester': newName});
  }

  // Delete Semester
  Future<void> deleteSemester(String semId) async {
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(widget.depId)
        .collection('semester')
        .doc(semId)
        .delete();
  }

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
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)),
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
                        letterSpacing: 1.2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: semController,
                    decoration: InputDecoration(
                      hintText: 'Enter Semester',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addSemester,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
           SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('departments')
                  .doc(widget.depId)
                  .collection('semester')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final semDocs = snapshot.data!.docs;
                if (semDocs.isEmpty) {
                  return const Center(child: Text('No Semesters Found'));
                }

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
                                colors: [Colors.purple, Colors.deepPurple]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading:
                             Icon(Icons.school, color: Colors.white),
                            title: Text(
                              sem['semester'] ?? 'No Semester',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle:  Text('Tap to manage',
                                style: TextStyle(color: Colors.white70)),
                          ),
                        ),
                        back: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                sem['semester'] ?? 'No Semester',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Spacer(),
                              IconButton(
                                icon:
                                const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () async {
                                  TextEditingController editController =
                                  TextEditingController(
                                      text: sem['semester']);
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Edit Semester"),
                                      content: TextField(
                                        controller: editController,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await updateSemester(
                                                sem.id, editController.text);
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
                                icon:  Icon(Icons.arrow_forward,
                                    color: Colors.purple),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddStudentScreen(
                                          depId: widget.depId, semsId: sem.id),
                                    ),
                                  );
                                },
                              ),

                              // Delete
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await deleteSemester(sem.id);
                                },
                              ),
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
