import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/admin_dashboared_service/admin_dashboared_service.dart';

class FeeManagementScreen extends StatelessWidget {
  FeeManagementScreen({Key? key}) : super(key: key);
  final AdminServiceData _service = AdminServiceData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Management'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
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

              return StreamBuilder<List<Course>>(
                stream: _service.getCourses(),
                builder: (context, courseSnapshot) {
                  if (!courseSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final courses = courseSnapshot.data!;

                  return ListView.builder(
                    itemCount: fees.length,
                    itemBuilder: (context, index) {
                      final fee = fees[index];
                      final student = students.firstWhere(
                            (s) => s.id == fee.studentId,
                        orElse: () => Student(id: '', name: 'Unknown', courseId: '', contact: ''),
                      );
                      final course = courses.firstWhere(
                            (c) => c.id == student.courseId,
                        orElse: () => Course(id: '', name: 'Unknown', description: '', fee: 0),
                      );

                      final isOverdue = fee.dueDate.isBefore(DateTime.now());
                      final cellKey = GlobalKey<SimpleFoldingCellState>();
                      final amountController = TextEditingController(text: fee.amount.toStringAsFixed(2));
                      final statusController = TextEditingController(text: fee.status);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SimpleFoldingCell.create(
                          key: cellKey,
                          frontWidget: GestureDetector(
                            onTap: () => cellKey.currentState?.toggleFold(),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: isOverdue ? Colors.red.shade200 : Colors.green.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.orange,
                                    child: Text(student.name.isNotEmpty ? student.name[0] : '?',
                                        style: const TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(course.name, style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('PKR ${fee.amount.toStringAsFixed(2)}'),
                                      Text('${fee.dueDate.day}/${fee.dueDate.month}/${fee.dueDate.year}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          innerWidget: Stack(
                            children: [
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  color: isOverdue ? Colors.red.shade100 : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Fee Details', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const Divider(),
                                    Text('Student: ${student.name}'),
                                    Text('Course: ${course.name}'),
                                    Text('Amount: PKR ${fee.amount.toStringAsFixed(2)}'),
                                    Text('Status: ${fee.status}'),
                                    Text('Due Date: ${fee.dueDate.day}/${fee.dueDate.month}/${fee.dueDate.year}'),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Show update overlay
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text('Update Fee'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: amountController,
                                                      decoration: const InputDecoration(labelText: 'Amount'),
                                                      keyboardType: TextInputType.number,
                                                    ),
                                                    TextField(
                                                      controller: statusController,
                                                      decoration: const InputDecoration(labelText: 'Status'),
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
                                                      final newAmount = double.tryParse(amountController.text) ?? fee.amount;
                                                      final newStatus = statusController.text.isNotEmpty ? statusController.text : fee.status;
                                                      final updatedFee = Fee(
                                                        id: fee.id,
                                                        studentId: fee.studentId,
                                                        courseId: fee.courseId,
                                                        amount: newAmount,
                                                        dueDate: fee.dueDate,
                                                        status: newStatus,
                                                      );
                                                      await _service.updateFee(updatedFee);
                                                      Navigator.pop(context);
                                                      cellKey.currentState?.toggleFold();
                                                    },
                                                    child: const Text('Update'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text('Update'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: () async {
                                            await _service.deleteFee(fee.id);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          cellSize: Size(MediaQuery.of(context).size.width, 150),
                          padding: const EdgeInsets.all(0),
                          animationDuration: const Duration(milliseconds: 400),
                          borderRadius: 12,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
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
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final students = snapshot.data!;
          if (students.isEmpty)
            return const Center(child: Text('No students found.'));

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
            Text(
              'Course ID: ${student.courseId}',
              style: GoogleFonts.poppins(),
            ),
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
