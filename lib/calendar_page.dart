import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'calendar_data.dart';
import 'language_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<String>> _markedDates = {};
  DateTime _startMonth = DateTime.now();
  String? _username;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startMonth = DateTime(now.year, now.month);
    _loadMarkedDates();
  }

  Future<void> _loadMarkedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null) return;

    setState(() {
      _username = username;
    });

    final snapshot = await FirebaseFirestore.instance.collection(username).get();
    Map<DateTime, List<String>> tempMarked = {};

    for (var doc in snapshot.docs) {
      final createdAt = doc['createdAt'];
      if (createdAt is String) {
        try {
          final parts = createdAt.split('.');
          final date = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          final formatted = DateFormat('dd.MM.yyyy').format(date);
          final key = DateTime(date.year, date.month, date.day);
          tempMarked[key] = [...(tempMarked[key] ?? []), formatted];
        } catch (e) {
          debugPrint('Tarih ayrıştırılamadı: $createdAt');
        }
      }
    }

    setState(() {
      _markedDates = tempMarked;
    });
  }

  List<String> _getEventsForDay(DateTime day) {
    return _markedDates[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _goToNextMonth() {
    setState(() {
      _startMonth = DateTime(_startMonth.year, _startMonth.month + 1);
    });
  }

  void _goToPreviousMonth() {
    final previousMonth = DateTime(_startMonth.year, _startMonth.month - 1);
    final earliestAllowedMonth = DateTime(2025, 4);

    if (previousMonth.isBefore(earliestAllowedMonth)) return;

    setState(() {
      _startMonth = previousMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime secondMonth = DateTime(_startMonth.year, _startMonth.month + 1);

    String getMonthName(BuildContext context, DateTime date) {
      final langCode = Provider.of<LanguageProvider>(context, listen: false).currentLocale;

      // Locale kodunu belirle
      String locale;
      switch (langCode.languageCode) {
        case 'az':
          locale = 'az_AZ';
          break;
        case 'en':
          locale = 'en_US';
          break;
        case 'tr':
        default:
          locale = 'tr_TR';
      }

      return DateFormat.yMMMM(locale).format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate(context, 'calendar')),
        actions: [
          if (_startMonth.isAfter(DateTime(2025, 4)))
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goToPreviousMonth,
            ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _goToNextMonth,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // İlk ay başlığı
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                getMonthName(context, _startMonth),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableCalendar(
              locale: 'tr_TR',
              firstDay: DateTime(2025, 4, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: _startMonth,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Ay',
              },
              headerVisible: false,
              selectedDayPredicate: (_) => false,
              eventLoader: _getEventsForDay,
              onDaySelected: (selectedDay, focusedDay) {
                final today = DateTime.now();
                final selectedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

                if (selectedDate.isAfter(DateTime(today.year, today.month, today.day))) {
                  // Gelecekteki tarihler tıklanamaz
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarDataPage(selectedDate: selectedDate, username: _username!),
                  ),
                );
              },
              calendarStyle: const CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // İkinci ay başlığı
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                getMonthName(context, secondMonth),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableCalendar(
              locale: 'tr_TR',
              firstDay: DateTime(2025, 4, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: secondMonth,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Ay',
              },
              headerVisible: false,
              selectedDayPredicate: (_) => false,
              eventLoader: _getEventsForDay,
              onDaySelected: (selectedDay, focusedDay) {},
              calendarStyle: const CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
