import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/admin_dashboared_service/admin_dashboared_service.dart';

class FeeManagementScreen extends StatelessWidget {
  FeeManagementScreen({Key? key}) : super(key: key);
  final AdminServiceData _service = AdminServiceData();

  /// OPTIONAL: Call this once to insert sample data
  Future<void> _insertSampleData() async {
    // Sample course
    await _service.addCourse(Course(
      id: 'course1',
      name: 'Flutter Development',
      description: 'Learn Flutter from scratch',
      fee: 15000.0,
    ));

    // Sample student
    await _service.addStudent(Student(
      id: 'student1',
      name: 'Ali Khan',
      courseId: 'course1',
      contact: '03001234567',
    ));

    // Sample fee
    await _service.addFee(Fee(
      id: 'fee1',
      studentId: 'student1',
      courseId: 'course1',
      amount: 15000.0,
      dueDate: DateTime.now().add(Duration(days: 30)),
      status: 'pending',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fee Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<List<Fee>>(
        stream: _service.getFees(),
        builder: (context, feeSnapshot) {
          if (!feeSnapshot.hasData) return const Center(child: CircularProgressIndicator());
          final fees = feeSnapshot.data!;
          if (fees.isEmpty) return const Center(child: Text('No fees found.'));

          return StreamBuilder<List<Student>>(
            stream: _service.getStudents(),
            builder: (context, studentSnapshot) {
              if (!studentSnapshot.hasData) return const Center(child: CircularProgressIndicator());
              final students = studentSnapshot.data!;

              return ListView.builder(
                itemCount: fees.length,
                itemBuilder: (context, index) {
                  final fee = fees[index];
                  final student = students.firstWhere(
                        (s) => s.id == fee.studentId,
                    orElse: () => Student(id: '', name: 'Unknown', courseId: '', contact: ''),
                  );
                  return FeeFoldingCard(fee: fee, studentName: student.name);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FeeFoldingCard extends StatelessWidget {
  final Fee fee;
  final String studentName;

  FeeFoldingCard({Key? key, required this.fee, required this.studentName}) : super(key: key);

  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  Widget build(BuildContext context) {
    return SimpleFoldingCell.create(
      key: _foldingCellKey,
      frontWidget: _buildFrontCard(context),
      innerWidget: _buildInnerCard(context),
      cellSize: Size(MediaQuery.of(context).size.width, 150),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      animationDuration: const Duration(milliseconds: 400),
      borderRadius: 12,
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _foldingCellKey.currentState?.toggleFold(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.orange.shade800,
              child: Text(studentName.isNotEmpty ? studentName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(studentName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Invoice ID: ${fee.id}', style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('PKR ${fee.amount.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                Text('Due: ${fee.dueDate.day}/${fee.dueDate.month}/${fee.dueDate.year}',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _foldingCellKey.currentState?.toggleFold(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fee Breakdown', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Tuition'),
              Text('PKR ${fee.amount.toStringAsFixed(2)}'),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Status'),
              Text(fee.status),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Due Date'),
              Text('${fee.dueDate.day}/${fee.dueDate.month}/${fee.dueDate.year}'),
            ]),
          ],
        ),
      ),
    );
  }
}

class CoursesScreen extends StatelessWidget {
  CoursesScreen({Key? key}) : super(key: key);
  final AdminServiceData _service = AdminServiceData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<List<Course>>(
        stream: _service.getCourses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final courses = snapshot.data!;
          if (courses.isEmpty) return const Center(child: Text('No courses found.'));

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseFoldingCard(course: course);
            },
          );
        },
      ),
    );
  }
}

class CourseFoldingCard extends StatelessWidget {
  final Course course;
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  final AdminServiceData _service = AdminServiceData();

  CourseFoldingCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleFoldingCell.create(
      key: _foldingCellKey,
      frontWidget: _buildFrontCard(context),
      innerWidget: _buildInnerCard(context),
      cellSize: Size(MediaQuery.of(context).size.width, 120),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      animationDuration: const Duration(milliseconds: 400),
      borderRadius: 12,
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _foldingCellKey.currentState?.toggleFold(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade700,
              child: Text(course.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(course.name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Text('PKR ${course.fee.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _foldingCellKey.currentState?.toggleFold(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Text('Name: ${course.name}', style: GoogleFonts.poppins()),
            Text('Description: ${course.description}', style: GoogleFonts.poppins()),
            Text('Fee: PKR ${course.fee.toStringAsFixed(2)}', style: GoogleFonts.poppins()),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Update'),
                  onPressed: () {
                    _showUpdateDialog(context);
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await _service.deleteCourse(course.id);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final nameController = TextEditingController(text: course.name);
    final descriptionController = TextEditingController(text: course.description);
    final feeController = TextEditingController(text: course.fee.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Course'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: feeController, decoration: const InputDecoration(labelText: 'Fee'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedCourse = Course(
                id: course.id,
                name: nameController.text,
                description: descriptionController.text,
                fee: double.tryParse(feeController.text) ?? course.fee,
              );
              await _service.updateCourse(updatedCourse);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}


class StudentsScreen extends StatelessWidget {
  StudentsScreen({Key? key}) : super(key: key);
  final AdminServiceData _service = AdminServiceData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<List<Student>>(
        stream: _service.getStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final students = snapshot.data!;
          if (students.isEmpty) return const Center(child: Text('No students found.'));

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentFoldingCard(student: student);
            },
          );
        },
      ),
    );
  }
}

class StudentFoldingCard extends StatelessWidget {
  final Student student;
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  StudentFoldingCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleFoldingCell.create(
      key: _foldingCellKey,
      frontWidget: _buildFrontCard(context),
      innerWidget: _buildInnerCard(context),
      cellSize: Size(MediaQuery.of(context).size.width, 120),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      animationDuration: const Duration(milliseconds: 400),
      borderRadius: 12,
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _foldingCellKey.currentState?.toggleFold(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green.shade700,
              child: Text(student.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(student.name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _foldingCellKey.currentState?.toggleFold(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student Details',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Text('Name: ${student.name}', style: GoogleFonts.poppins()),
            Text('Course ID: ${student.courseId}', style: GoogleFonts.poppins()),
            Text('Contact: ${student.contact}', style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );
  }
}
