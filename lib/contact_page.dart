import 'package:flutter/material.dart';

import 'home_page.dart';
import 'language_provider.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider.translate;

    return Scaffold(
      appBar: AppBar(title: Text(lang(context, 'contact'))),
      drawer: HomePage(title: lang(context, 'contact')).buildDrawer(context),
      body: Container(
        color: const Color(0xFFD5CE9D),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              lang(context, 'contact'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.black54),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lang(context, 'address'),
                            style: const TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.black54),
                        const SizedBox(width: 10),
                        Text(
                          lang(context, 'phone'),
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.black54),
                        const SizedBox(width: 10),
                        Text(
                          lang(context, 'email'),
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
