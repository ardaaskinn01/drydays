import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmRecordsScreen extends StatefulWidget {
  const AlarmRecordsScreen({super.key});

  @override
  State<AlarmRecordsScreen> createState() => _AlarmRecordsScreenState();
}

class _AlarmRecordsScreenState extends State<AlarmRecordsScreen> {
  String? _username;
  late Future<List<String>> _dates;

  Future<List<Map<String, dynamic>>> fetchAlarmDetails(String dateId) async {
    if (_username == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection(_username!)
        .doc(dateId)
        .collection('alarmrecords')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  void _showAlarmDetailsPopup(String dateId) async {
    final details = await fetchAlarmDetails(dateId);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$dateId - Alarm Detayları"),
        content: SizedBox(
          width: double.maxFinite,
          child: details.isEmpty
              ? const Text("Bu tarihe ait alarm bulunamadı.")
              : ListView.builder(
            shrinkWrap: true,
            itemCount: details.length,
            itemBuilder: (context, index) {
              final item = details[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Cihaz: ${item['device'] ?? 'Bilinmiyor'}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Başlangıç: ${item['startTime'] ?? '-'}"),
                    Text("Bitiş: ${item['endTime'] ?? '-'}"),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Kapat"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<List<String>> fetchAlarmDates() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');

    if (_username == null) return [];

    final snapshot =
    await FirebaseFirestore.instance.collection(_username!).get();

    List<String> validDates = [];

    for (var doc in snapshot.docs) {
      final alarmRecordsSnapshot = await doc.reference
          .collection('alarmrecords')
          .limit(1)
          .get();

      if (alarmRecordsSnapshot.docs.isNotEmpty) {
        validDates.add(doc.id);
      }
    }

    return validDates;
  }

  @override
  void initState() {
    super.initState();
    _dates = fetchAlarmDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm Kayıtları"),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF6F5F2),
      body: FutureBuilder<List<String>>(
        future: _dates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final dates = snapshot.data ?? [];

          if (dates.isEmpty) {
            return const Center(child: Text("Kayıtlı alarm bulunamadı."));
          }

          return ListView.separated(
            itemCount: dates.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final date = dates[index];
              return ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(date),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showAlarmDetailsPopup(date),
              );
            },
          );
        },
      ),
    );
  }
}
