import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:folding_cell/folding_cell.dart';
class FeeManagementScreen extends StatelessWidget {
  const FeeManagementScreen({Key? key}) : super(key: key);
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
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return FeeFoldingCard();
        },
      ),
    );
  }
}

class FeeFoldingCard extends StatelessWidget {
  FeeFoldingCard({Key? key}) : super(key: key);

  // Each card needs its own GlobalKey
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  Widget build(BuildContext context) {
    return SimpleFoldingCell.create(
      key: _foldingCellKey,
      frontWidget: _buildFrontCard(context),
      innerWidget: _buildInnerCard(context),
      cellSize: Size(MediaQuery.of(context).size.width, 150),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      animationDuration: Duration(milliseconds: 400),
      borderRadius: 12,
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _foldingCellKey.currentState?.toggleFold(); // Trigger fold/unfold
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.orange.shade800,
              child: Text('D', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Student Name', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Invoice ID: XXX', style: GoogleFonts.poppins(color: Colors.grey.shade600)),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('PKR 0.00', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                Text('Due: --', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _foldingCellKey.currentState?.toggleFold(); // Tap inner card to fold back
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fee Breakdown', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Tuition'), Text('PKR 0.00')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Library'), Text('PKR 0.00')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Lab'), Text('PKR 0.00')],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(onPressed: () {}, icon: Icon(Icons.download), label: Text('Receipt')),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.payment),
                  label: Text('Pay Now'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
