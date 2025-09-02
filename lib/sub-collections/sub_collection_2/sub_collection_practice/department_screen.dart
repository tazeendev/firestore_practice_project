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
  String? selectDepartment;
  List<String> depData = [];
  @override
  void initState() {
    super.initState();
    fetchDepList();
  }

  //-------------------- Fetch departments for dropdown-------
  void fetchDepList() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('departments')
        .orderBy('created')
        .get();
    final deps = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      depData = deps;
    });
  }

  // Add new department
  Future<void> addDepartment() async {
    final depId=DateTime.now().microsecond.toString();
    if (depController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('departments').doc(depId).set({
      'name': depController.text,
      'created':Timestamp.now(),
    });
    depController.clear();
    fetchDepList(); // Refresh dropdown
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
                decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
            padding:  EdgeInsets.symmetric(horizontal: 20),
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
                child:  Text(
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

          //--------------------- Dropdown to select department------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: depData.isEmpty
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
              value: selectDepartment,
              items: depData.map((dep) {
                return DropdownMenuItem(
                  value: dep,
                  child: Text(dep),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectDepartment = val;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Department',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('departments')
                  .orderBy('created')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final depDocs = snapshot.data!.docs;
                if (depDocs.isEmpty) {
                  return Center(child: Text('No Department found'));
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
                          padding: EdgeInsets.all(20),
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
                                offset: Offset(0, 5),
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
                                offset: Offset(0, 5),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SemesterScreen(depId: dep.id)));
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      TextEditingController editController =
                                      TextEditingController(
                                          text: dep['name']);
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Edit Department'),
                                          content: TextField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                              labelText: 'Department Name',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('departments')
                                                    .doc(dep.id)
                                                    .update({
                                                  'name': editController.text,
                                                });
                                                Navigator.pop(context);
                                                fetchDepList();
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('departments')
                                          .doc(dep.id)
                                          .delete();
                                      fetchDepList();
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
