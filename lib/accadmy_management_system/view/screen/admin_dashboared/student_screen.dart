import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../model/admin_model/admin_model.dart';
import '../../../services/admin_dashboared_service/admin_dashboared_service.dart';

class StudentsScreen extends StatelessWidget {
  StudentsScreen({Key? key}) : super(key: key);
  final AdminServiceData _service = AdminServiceData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<List<Student>>(
        stream: _service.getStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data!;
          if (students.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentFoldingCard(student: student);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// ---------------- Add Student Dialog ----------------
  void _showAddStudentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final courseController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: 'Course ID'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newStudent = Student(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                courseId: courseController.text,
                contact: contactController.text,
              );
              await _service.addStudent(newStudent);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// ---------------- Student Folding Card ----------------
class StudentFoldingCard extends StatelessWidget {
  final Student student;
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  final AdminServiceData _service = AdminServiceData();

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
              child: Text(
                student.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                student.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
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
            Text(
              'Student Details',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(),
            Text('Name: ${student.name}', style: GoogleFonts.poppins()),
            Text('Course ID: ${student.courseId}', style: GoogleFonts.poppins()),
            Text('Contact: ${student.contact}', style: GoogleFonts.poppins()),
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
                    await _service.deleteStudent(student.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- Update Student Dialog ----------------
  void _showUpdateDialog(BuildContext context) {
    final nameController = TextEditingController(text: student.name);
    final courseController = TextEditingController(text: student.courseId);
    final contactController = TextEditingController(text: student.contact);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: 'Course ID'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedStudent = Student(
                id: student.id,
                name: nameController.text,
                courseId: courseController.text,
                contact: contactController.text,
              );
              await _service.updateStudent(updatedStudent);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
