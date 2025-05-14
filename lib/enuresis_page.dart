import 'package:flutter/material.dart';

import 'home_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'language_provider.dart';

class EnuresisPage extends StatelessWidget {
  const EnuresisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang(context, 'whatIsEnuresis')),
      ),
      drawer: HomePage(title: lang(context, 'whatIsEnuresis')).buildDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Color(0xFFD5CE9D),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang(context, 'whatIsEnuresis'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/ensuresis.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                lang(context, 'whatIsEnuresisDetail'),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text(
                lang(context, 'treatment'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                lang(context, 'treatmentDetail'),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
