import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'next_screen.dart';

class InsertData extends StatefulWidget {
  const InsertData({super.key});
  @override
  State<InsertData> createState() => _InsertDataState();
}
class _InsertDataState extends State<InsertData> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFDCDC),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Color(0xffFF90BB),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Color(0xffE53888),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Color(0xffE53888),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Color(0xffFF90BB),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(
                        color: Color(0xffE53888),
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Insert data into fields ....',
                      style: TextStyle(
                        color: Color(0xff7D8D86),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffC71E64)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xffC71E64)),
                        ),
                        hintText: 'Enter your name',
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Color(0xff000000)),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: fnameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffC71E64)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xffC71E64)),
                        ),
                        hintText: 'Enter your father name',
                        labelText: 'Father Name',
                        labelStyle: TextStyle(color: Color(0xff000000)),
                      ),
                    ),
                    SizedBox(height: 25),
                    isLoading
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () async {
                              if (nameController.text.isEmpty ||
                                  fnameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please fill all fields"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                String id = DateTime.now().microsecond
                                    .toString();
                                await FirebaseFirestore.instance
                                    .collection(
                                      FirebaseAuth.instance.currentUser!.uid,
                                    )
                                    .doc(id)
                                    .set({
                                      'name': nameController.text,
                                      'fname': fnameController.text,
                                      'id': id,
                                    });
                                setState(() {
                                  isLoading = false;
                                });

                                nameController.clear();
                                fnameController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Data inserted successfully!",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NextScreen(),
                                  ),
                                );
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Data not inserted: ${e.toString()}",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Color(0xffFF90BB),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
