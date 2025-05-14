import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'language_provider.dart';
import 'main.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  Future<void> downloadKilavuzPDF(BuildContext context) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        final byteData = await rootBundle.load('assets/images/kilavuz.pdf');
        final downloadDir = Directory('/storage/emulated/0/Download'); // Android için

        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }

        final file = File('${downloadDir.path}/kilavuz.pdf');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        // Bildirim Gönder
        _showDownloadNotification(context, file.path);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LanguageProvider.translate(context, 'download_failure'))),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageProvider.translate(context, 'download_failure'))),
      );
    }
  }

  void _showDownloadNotification(BuildContext context, String filePath) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_channel',
      'İndirilen Dosyalar',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      LanguageProvider.translate(context, 'download_success'),
      LanguageProvider.translate(context, 'tap_to_open'),
      notificationDetails,
      payload: filePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LanguageProvider.translate(context, 'how_to_use'))),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xFFD5CE9D),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LanguageProvider.translate(context, 'how_to_use'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text(
                LanguageProvider.translate(context, 'instruction'),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text(LanguageProvider.translate(context, 'download_guide'), style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => downloadKilavuzPDF(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}