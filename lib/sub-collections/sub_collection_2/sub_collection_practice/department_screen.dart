import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/sub-collections/sub_collection_2/sub_collection_practice/semester_screen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  TextEditingController depController = TextEditingController();

  //-------------------- Add new department -----------
  Future<void> addDepartment() async {
    if (depController.text.isEmpty) return;

    final depId = DateTime.now().microsecond.toString();

    await FirebaseFirestore.instance.collection('departments').doc(depId).set({
      'name': depController.text,
      'id': depId,
    });

    depController.clear();
  }

  //-------------------- Delete department -----------
  Future<void> deleteDepartment(String depId) async {
    await FirebaseFirestore.instance.collection('departments').doc(depId).delete();
  }

  //-------------------- Update department -----------
  Future<void> updateDepartment(String depId, String newName) async {
    await FirebaseFirestore.instance.collection('departments').doc(depId).update({
      'name': newName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
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
                    'Departments',
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
           SizedBox(height: 30),

          // Add Department
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: depController,
              decoration: InputDecoration(
                labelText: 'Add New Department',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addDepartment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Department',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // -----------------Fetch Departments-------------
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('departments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final depDocs = snapshot.data!.docs;

                if (depDocs.isEmpty) {
                  return const Center(child: Text('No Department found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: depDocs.length,
                  itemBuilder: (context, index) {
                    final dep = depDocs[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        front: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade300,
                                Colors.deepPurpleAccent,
                              ],
                            ),
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
                            leading: const Icon(
                              Icons.cast_for_education,
                              color: Colors.white,
                            ),
                            title: Text(
                              dep['name'] ?? "No Department",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: const Text(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dep['name'] ?? 'No Department',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.purple,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SemesterScreen(depId: dep.id),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      TextEditingController editController =
                                      TextEditingController(
                                          text: dep['name']);
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                          const Text('Edit Department'),
                                          content: TextField(
                                            controller: editController,
                                            decoration: const InputDecoration(
                                              labelText: 'Department Name',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await updateDepartment(
                                                    dep.id,
                                                    editController.text);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      // Optional: show confirm dialog
                                      await deleteDepartment(dep.id);
                                    },
                                  ),
                                ],
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
