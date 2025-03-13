import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hw37/screens/result_screen.dart';

class Hw37 extends StatefulWidget {
  const Hw37({super.key});

  @override
  State<Hw37> createState() => _Hw37State();
}

class _Hw37State extends State<Hw37> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).textTheme.titleMedium!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Country ! ',
          style: GoogleFonts.alef(color: themeColor.color, fontSize: 26),
        ),
      ),
      body: ResultScreen(),
    );
  }
}
