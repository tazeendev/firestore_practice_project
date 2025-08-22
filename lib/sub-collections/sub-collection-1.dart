import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/student_registration_project/home_screen/update_screen.dart';
import 'package:firebase_app/view/screens/firebase_store/fetchdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubFetchUserData extends StatefulWidget {
  const SubFetchUserData({super.key});
  @override
  State<SubFetchUserData> createState() => _SubFetchUserDataState();
}
class _SubFetchUserDataState extends State<SubFetchUserData> {
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>INsertSubData()));
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditStudentScreen(
                //   customId:,
                //   studentData: {
                // },)));
              }, child: Text('Insert Data',style: TextStyle(color: Color(0xff113F67)),))),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('classData')
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
                  title: Text(student['className'] ?? 'No Name'),

                  onLongPress: (){

                  },
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FetchStudents(
                        classId: student['classId'])));

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

class INsertSubData extends StatefulWidget {
  const INsertSubData({super.key});

  @override
  State<INsertSubData> createState() => _INsertSubDataState();
}

class _INsertSubDataState extends State<INsertSubData> {
  TextEditingController classNameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextFormField(controller: classNameController,),
        TextButton(onPressed: ()async{
          String clasId=DateTime.now().microsecond.toString();
          await FirebaseFirestore.instance.collection('classData').doc(clasId).set({
            'className':classNameController.text,
            'classId':clasId
          }).then((onValue){
           Navigator.pop(context)
;            // Navigator.push(context, MaterialPageRoute(builder: (context)=>SubFetchUserData()));

          });
        }, child: Text('Add Class'))
      ],),
    );
  }
}


class FetchStudents extends StatefulWidget {
  final String classId;
  const FetchStudents({super.key, required this.classId});

  @override
  State<FetchStudents> createState() => _FetchStudentsState();
}

class _FetchStudentsState extends State<FetchStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>AddStudent(classID: widget.classId)));
      }),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('classData')
        .doc(widget.classId).collection('studentData')
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
                  title: Text(student['studentName'] ?? 'No Name'),

                  onLongPress: (){

                  },
                  onTap: () {

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

class AddStudent extends StatefulWidget {
  final String classID;
  const AddStudent({super.key, required this.classID});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController studentNameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextFormField(
          controller: studentNameController,
        ),
        TextButton(onPressed: ()async{
          String studentId=DateTime.now().microsecond.toString();
          print('Student id:-------------$studentId');
          print('ClassId:-----------${widget.classID}');
          await FirebaseFirestore.instance.
          collection('classData')
              .doc(widget.classID)
              .collection('studentData')
              .doc(studentId).set({
            'studentName':studentNameController.text,
            'studentId':studentId,
          }).then((onValue){
            Navigator.pop(context);
          });
        }, child: Text('Add student'))
      ],),
    );
  }
}

