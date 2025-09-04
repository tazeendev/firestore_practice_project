
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/admin_model/admin_model.dart';
// ----------------- SERVICE -----------------
class AdminServiceData {
  final FirebaseFirestore firestore= FirebaseFirestore.instance;

  //------------ Courses--------------
  Stream<List<Course>> getCourses() =>
      firestore.collection('courses').snapshots().map((snap) => snap.docs.map((doc) => Course.fromFireStore(doc)).toList());

  Future<void> addCourse(Course course) => firestore.collection('courses').doc(course.id).set(course.toMap());
  Future<void> updateCourse(Course course) => firestore.collection('courses').doc(course.id).update(course.toMap());
  Future<void> deleteCourse(String id) => firestore.collection('courses').doc(id).delete();

  //---------- Students-------
  Stream<List<Student>> getStudents() =>
      firestore.collection('students').snapshots().map((snap) => snap.docs.map((doc) => Student.fromFirestore(doc)).toList());

  Future<void> addStudent(Student student) => firestore.collection('students').doc(student.id).set(student.toMap());
  Future<void> updateStudent(Student student) => firestore.collection('students').doc(student.id).update(student.toMap());
  Future<void> deleteStudent(String id) => firestore.collection('students').doc(id).delete();

  //--------- Fees------------------
  Stream<List<Fee>> getFees() =>
      firestore.collection('fees').snapshots().map((snap) => snap.docs.map((doc) => Fee.fromFirestore(doc)).toList());

  Future<void> addFee(Fee fee) => firestore.collection('fees').doc(fee.id).set(fee.toMap());
  Future<void> updateFee(Fee fee) => firestore.collection('fees').doc(fee.id).update(fee.toMap());
  Future<void> deleteFee(String id) => firestore.collection('fees').doc(id).delete();
}
extension SampleData on AdminServiceData {
  Future<void> addSampleData() async {
    // 1️⃣ Create a course
    final course = Course(
      id: 'course1',
      name: 'Flutter Development',
      description: 'Learn Flutter from scratch',
      fee: 15000.0,
    );
    await addCourse(course);

    // 2️⃣ Create a student
    final student = Student(
      id: 'student1',
      name: 'Ali Khan',
      courseId: course.id,
      contact: '03001234567',
    );
    await addStudent(student);

    // 3️⃣ Create a fee
    final fee = Fee(
      id: 'fee1',
      studentId: student.id,
      courseId: course.id,
      amount: 15000.0,
      dueDate: DateTime.now().add(const Duration(days: 30)),
      status: 'pending',
    );
    await addFee(fee);

    print('Sample data added successfully!');
  }
}
