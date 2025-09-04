import 'package:cloud_firestore/cloud_firestore.dart';

// ----------------- MODELS -----------------
class Course{
  final String id;
  final String name;
  final String description;
  double fee;
  Course({required this.id,required this.description,required this.fee,required this.name});
  Map<String,dynamic> toMap()=>{
    'name':name,
    'des':description,
    'fee':fee
  };
factory Course.fromFireStore(DocumentSnapshot doc){
  final data=doc.data() as Map<String ,dynamic>;return Course(id:doc.id, description: data['des'], fee: (data['fee'] as num).toDouble(),
  name: data['name']);
}
}

class Student {
 final  String id;
 final String name;
 final  String courseId;
  final String contact;

  Student({required this.id, required this.name, required this.courseId, required this.contact});

  Map<String, dynamic> toMap() => {
    'name': name,
    'courseId': courseId,
    'contact': contact,
  };
  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'],
      courseId: data['courseId'],
      contact: data['contact'],
    );
  }
}

class Fee {
 final  String id;
  final String studentId;
 final  String courseId;
 final double amount;
 final DateTime dueDate;
 final String status;

  Fee({required this.id, required this.studentId, required this.courseId, required this.amount, required this.dueDate, required this.status});

  Map<String, dynamic> toMap() => {
    'studentId': studentId,
    'courseId': courseId,
    'amount': amount,
    'dueDate': dueDate,
    'status': status,
  };

  factory Fee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Fee(
      id: doc.id,
      studentId: data['studentId'],
      courseId: data['courseId'],
      amount: (data['amount'] as num).toDouble(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      status: data['status'],
    );
  }
}