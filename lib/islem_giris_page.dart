import 'package:flutter/material.dart';

class IslemGirisPage extends StatelessWidget {
  const IslemGirisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İşlem Girişi'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text('İşlem Girişi Sayfası'),
      ),
    );
  }
}
