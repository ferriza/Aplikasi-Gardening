import 'package:flutter/material.dart';

class LogPage extends StatelessWidget {
  const LogPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Page'),
      ),
      body: Center(
        child: Text(
          'Log Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
