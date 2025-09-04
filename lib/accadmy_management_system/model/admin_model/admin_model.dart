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

  factory Course.fromFirestore(doc) {
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

  factory Student.fromFirestore(doc) {
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

  factory Fee.fromFirestore(doc) {
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
