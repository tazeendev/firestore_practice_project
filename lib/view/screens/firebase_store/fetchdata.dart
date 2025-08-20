import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class FetchData extends StatefulWidget {
  const FetchData({super.key});
  @override
  State<FetchData> createState() => _FetchDataState();
}
class _FetchDataState extends State<FetchData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, '/data');
      }),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),// source of incoming data---firestore collection name---
          builder: (context,snapshot){
            final docs= snapshot.data!.docs;
            // docs is a list i which we store all of the data drom collection userData
             return ListView.builder(
                itemCount: docs.length,// last length
                itemBuilder: (context,index){
                  String id=docs[index]['id'];
                  return ListTile(
                    onLongPress: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateScreen(
                     docId: id,
                   )));
                    },
                    onTap: ()async{
                      await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(id).delete();
                    },
                    title: Text(docs[index]['name'].toString()==""?"N/A":docs[index]['name']),
                    subtitle:Text(docs[index]['fname']) ,
                    trailing: Text(id),
                  );
                });
          }),
    );
  }
}
class UpdateScreen extends StatefulWidget
{
 final String docId;
  const UpdateScreen({super.key, required this.docId});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(onPressed: ()async{
        await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(widget.docId).update({
        });
      }, child: Text('Update')),
    );
  }
}
