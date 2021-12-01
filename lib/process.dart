import 'package:flutter/material.dart';

Process process = const Process();

class Process extends StatefulWidget {
  const Process({ Key? key }) : super(key: key);

  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('Process'),
    );
  }
}