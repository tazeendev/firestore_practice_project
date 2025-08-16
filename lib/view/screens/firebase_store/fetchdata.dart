import 'package:cloud_firestore/cloud_firestore.dart';
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
          stream: FirebaseFirestore.instance.collection('userData').snapshots(),// source of incoming data---firestore collection name---
          builder: (context,snapshot){
            final docs= snapshot.data!.docs;
            // docs is a list i which we store all of the data drom collection userData
             return ListView.builder(
                itemCount: docs.length,// last length
                itemBuilder: (context,index){
                  return ListTile(
                    onTap: ()async{
                      await FirebaseFirestore.instance.collection('userData').doc(docs[index]['id']).delete();
                    },
                    title: Text(docs[index]['name'].toString()==""?"N/A":docs[index]['name']),
                    subtitle:Text(docs[index]['fname']) ,
                    trailing: Text(docs[index]['id']),
                  );
                });
          }),
    );
  }
}
