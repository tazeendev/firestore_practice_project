import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/main.dart';
import 'package:firebase_app/student_registration_project/auth_screens/text_feild_widget/text_feild_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CreateCollection extends StatefulWidget {
  const CreateCollection({super.key});

  @override
  State<CreateCollection> createState() => _CreateCollectionState();
}

class _CreateCollectionState extends State<CreateCollection> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController emailControlller = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Practice FireStore',
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          CustomTextField(
            controller: nameController,
            hintText: 'enter the name',
            prefixIcon: Icons.person,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 15),
          CustomTextField(
            controller: fatherController,
            hintText: 'enter the Father  name',
            prefixIcon: Icons.person,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 15),
          CustomTextField(
            controller: emailControlller,
            hintText: 'enter the email',
            prefixIcon: Icons.email,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 25),
          GestureDetector(
            onTap: ()async{
              final userId=DateTime.now().microsecond.toString();
              await FirebaseFirestore.instance.collection('classData').doc(userId).set({
                'Name':nameController.text,
                'FatherName':fatherController.text,
                'Email':emailControlller.text,
                'userId':userId,
              }).then((onValue){
                isLoading=false;
                Navigator.pop(context);
              });
              
            },
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.yellowAccent.shade100],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------insertSubdata---------
class FetchSubData extends StatefulWidget {
  const FetchSubData({super.key});

  @override
  State<FetchSubData> createState() => _FetchSubDataState();
}

class _FetchSubDataState extends State<FetchSubData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('classData').snapshots(), builder:(context,snapshots){
        final docs=snapshots.data!.docs;
        return ListView.builder(itemBuilder: (context ,index){
          final value=docs[index];
          return Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Text('Name:${value['Name']}?? No Name'),
                Text('FatherName:${value['FatherName']}?? No Name'),
                Text('Email:${value['Email']}?? No Email'),

              ],
            ),
          );
        });
      }),
    );
  }
}

//-----fetchStudents---------
class FetchStudentData extends StatefulWidget {
  const FetchStudentData({super.key});

  @override
  State<FetchStudentData> createState() => _FetchStudentDataState();
}

class _FetchStudentDataState extends State<FetchStudentData> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//--------------AddStudents--------
class AddStudents extends StatefulWidget {
  final String userId;
  const AddStudents({super.key, required this.userId});

  @override
  State<AddStudents> createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  TextEditingController departmentController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
CustomTextField(controller: departmentController, hintText:'enter the department', prefixIcon:Icons.cast_for_education,
    textInputType:TextInputType.text),
          GestureDetector(
            onTap: ()async{
              final dep=DateTime.now().toString();
              await FirebaseFirestore.instance.collection('ClassData').doc(widget.userId).collection('classData').doc(dep).set({
              'depart':departmentController.text,
              }).then((onValue){
                Navigator.pop(context);
              });
            },
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber,
              ),
              child: Text('Add Department'),
            ),
          )
        ],
      ),
    );
  }
}
//--------------addsemsester-----------
class AddSmester extends StatefulWidget {
  final String userId;
  final String dep;
  const AddSmester({super.key, required this.userId, required this.dep});

  @override
  State<AddSmester> createState() => _AddSmesterState();
}

class _AddSmesterState extends State<AddSmester> {
  TextEditingController semesterController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          CustomTextField(controller: semesterController, hintText:'enter the department', prefixIcon:Icons.cast_for_education,
              textInputType:TextInputType.text),
          GestureDetector(
            onTap: ()async{
              final semester=DateTime.now().microsecond.toString();
              await FirebaseFirestore.instance.collection('ClassData').doc(widget.userId)
                  .collection('ClassData').doc(widget.dep).collection('ClassData').doc(semester).set({
                'semester':semesterController.text
              });
              
            },
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber,
              ),
              child: Text('Add Department'),
            ),
          )
        ],
      ),
    );
  }
}
class FtechDepartment extends StatefulWidget {
  final 
  const FtechDepartment({super.key});

  @override
  State<FtechDepartment> createState() => _FtechDepartmentState();
}

class _FtechDepartmentState extends State<FtechDepartment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('ClassData').doc(), builder: builder)
    );
  }
}


