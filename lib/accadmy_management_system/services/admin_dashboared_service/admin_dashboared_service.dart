import 'package:cloud_firestore/cloud_firestore.dart';

// ----------------- MODELS -----------------
class Course {
  String id;
  String name;
  String description;
  double fee;

  Course({required this.id, required this.name, required this.description, required this.fee});

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'fee': fee,
  };

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      fee: (data['fee'] as num).toDouble(),
    );
  }
}

class Student {
  String id;
  String name;
  String courseId;
  String contact;

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
  String id;
  String studentId;
  String courseId;
  double amount;
  DateTime dueDate;
  String status;

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

// ----------------- SERVICE -----------------
class AdminServiceData {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Courses
  Stream<List<Course>> getCourses() =>
      _db.collection('courses').snapshots().map((snap) => snap.docs.map((doc) => Course.fromFirestore(doc)).toList());

  Future<void> addCourse(Course course) => _db.collection('courses').doc(course.id).set(course.toMap());
  Future<void> updateCourse(Course course) => _db.collection('courses').doc(course.id).update(course.toMap());
  Future<void> deleteCourse(String id) => _db.collection('courses').doc(id).delete();

  // Students
  Stream<List<Student>> getStudents() =>
      _db.collection('students').snapshots().map((snap) => snap.docs.map((doc) => Student.fromFirestore(doc)).toList());

  Future<void> addStudent(Student student) => _db.collection('students').doc(student.id).set(student.toMap());
  Future<void> updateStudent(Student student) => _db.collection('students').doc(student.id).update(student.toMap());
  Future<void> deleteStudent(String id) => _db.collection('students').doc(id).delete();

  // Fees
  Stream<List<Fee>> getFees() =>
      _db.collection('fees').snapshots().map((snap) => snap.docs.map((doc) => Fee.fromFirestore(doc)).toList());

  Future<void> addFee(Fee fee) => _db.collection('fees').doc(fee.id).set(fee.toMap());
  Future<void> updateFee(Fee fee) => _db.collection('fees').doc(fee.id).update(fee.toMap());
  Future<void> deleteFee(String id) => _db.collection('fees').doc(id).delete();
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
