import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart'; // DİKKAT! bu import gerekli
import 'home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LanguageProvider.translate(context, 'aboutTitle')),
            elevation: 0,
          ),
          drawer: HomePage(title: LanguageProvider.translate(context, 'aboutTitle'))
              .buildDrawer(context),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xFFD5CE9D),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LanguageProvider.translate(context, 'aboutTitle'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (int i = 1; i <= 7; i++) ...[
                    Text(
                      LanguageProvider.translate(context, 'aboutP$i'),
                      style:
                      const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}