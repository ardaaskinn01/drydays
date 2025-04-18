import 'package:flutter/material.dart';

class RaporOlusturmaPage extends StatelessWidget {
  const RaporOlusturmaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapor Oluşturma'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Rapor Oluşturma Sayfası'),
      ),
    );
  }
}
