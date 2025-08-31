
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/view/screens/firebase_store/fetchdata.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key, });

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  TextEditingController depController = TextEditingController();
  String? selectDepartment;
   List<String> depData=[];
  void FetchDep()async{
    final snapshot=await FirebaseFirestore.instance.collection('departments').orderBy('created').get();
    final  deps=snapshot.docs.map((doc)=>doc['name'].toString()).toList();
    setState(() {
      depData=deps;
    });
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
                    ' Select Departments',
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
            child: depData.isEmpty? CircularProgressIndicator()  :DropdownButtonFormField(items: depData.map((deps){
              return DropdownMenuItem(child: Text(deps));
            }).toList() ,onChanged:(val){
              setState(() {
                selectDepartment=val;
              });
            })     ),
           SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (depController.text.isEmpty) return;
                  await FetchData();
                  depController.clear();
                  setState(() {
                    selectDepartment = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Department',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          //-------------- Department list with Flip Cards
          Expanded(
            child:  StreamBuilder(stream: FirebaseFirestore.instance.collection('departments').snapshots(),
              builder: (context, snapshot) {
               if(!snapshot.hasData){
                 return CircularProgressIndicator();
               }
               final depDocs=snapshot.data!.docs;
if(depDocs.isEmpty){
  return Text('No Department found');
}
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: depDocs.length,
                  itemBuilder: (context, index) {
final dep =depDocs[index]   ;                 return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        front: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.purple.shade300, Colors.deepPurpleAccent]),
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
                            leading: const Icon(Icons.cast_for_education, color: Colors.white),
                            title: Text(
                              // dep['depart'] ?? 'No Department',
                              dep['name']?? "Not department",
                              style:  TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                            ),
                            subtitle:  Text(
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
                              Text(dep['name']??'No Department',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward, color: Colors.purple),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => SemesterScreen(
                                      //
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                  ),
                                  IconButton(onPressed: (){
                                    TextEditingController editController=TextEditingController(text: dep['name']);
                                    showDialog(context: (context), builder:(ctx)=>AlertDialog(
                                      content: Text('Edit Department'),actions: [
                                        Container(height: 30,
                                        width: 60,decoration: BoxDecoration(
                                            color: Colors.deepPurple,
                                          ),
                                        child: TextButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child:Text('Cancel')),),
                                      TextButton(onPressed: ()async{
                                        await FirebaseFirestore.instance.collection('departments').doc(dep.id).update({'name':editController.text});
                                      }, child:Text('Save'))
                                    ],

                                    ));
                                  }, icon: Icon(Icons.edit,color:Colors.deepPurple,)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('departments').doc(dep.id).delete();
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

