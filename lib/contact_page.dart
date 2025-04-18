import 'package:flutter/material.dart';

import 'home_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İletişim")),
      drawer: HomePage(title: 'İletişim').buildDrawer(context),
      body: Container(
        color: const Color(0xFFD5CE9D),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "İletişim",
              textAlign: TextAlign.center,
              style: TextStyle(
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
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.black54),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "847/1 Sokak No:8 303 Sağlık İş Merkezi\nKonak / İzmir",
                            style: TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.black54),
                        SizedBox(width: 10),
                        Text(
                          "0232 484 17 04",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.black54),
                        SizedBox(width: 10),
                        Text(
                          "info@drydays.net",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
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
