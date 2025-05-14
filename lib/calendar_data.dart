import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'language_provider.dart';

class CalendarDataPage extends StatefulWidget {
  final DateTime selectedDate;
  final String username;

  const CalendarDataPage({
    super.key,
    required this.selectedDate,
    required this.username,
  });

  @override
  State<CalendarDataPage> createState() => _CalendarDataPageState();
}

class _CalendarDataPageState extends State<CalendarDataPage> {
  final TextEditingController _alarmCountController = TextEditingController();
  TimeOfDay? bedTime;
  TimeOfDay? wakeTime;
  String? morningStatus;
  String? moodStatus;
  List<TimeOfDay?> alarmTimes = [];
  List<String> diaperWetness = [];
  List<String> outsideUrine = [];

  bool _hasRecord = false;

  @override
  void initState() {
    super.initState();
    _loadExistingRecord();
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null || !timeString.contains(':')) return null;
    final parts = timeString.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _loadExistingRecord() async {
    final doc = await FirebaseFirestore.instance
        .collection(widget.username)
        .doc(_formattedDate(widget.selectedDate))
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          _hasRecord = true;
          bedTime = _parseTimeOfDay(data['bedTime']);
          wakeTime = _parseTimeOfDay(data['wakeTime']);
          morningStatus = data['morningStatus'] ?? LanguageProvider.translate(context, 'tamKuru');
          moodStatus = data['moodStatus'] ?? LanguageProvider.translate(context, 'normal');
          alarmTimes = List<String>.from(data['alarmTimes'] ?? [])
              .map((t) => _parseTimeOfDay(t))
              .toList();
          diaperWetness = List<String>.from(data['diaperWetness'] ?? []);
          outsideUrine = List<String>.from(data['outsideUrine'] ?? []);
          _alarmCountController.text = alarmTimes.length.toString();
        });
      }
    }
  }

  Future<void> _pickTime(BuildContext context, bool isBedTime) async {
    final TimeOfDay initialTime = isBedTime ? bedTime ?? TimeOfDay.now() : wakeTime ?? TimeOfDay.now();

    int selectedHour = initialTime.hour;
    int selectedMinute = initialTime.minute;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 250,
          child: Column(
            children: [
              Text(
                LanguageProvider.translate(context, isBedTime ? 'selectBedTime' : 'selectWakeTime'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Saat Seçici
                    SizedBox(
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selectedHour),
                        itemExtent: 40,
                        onSelectedItemChanged: (int index) {
                          selectedHour = index;
                        },
                        children: List.generate(24, (index) {
                          return Center(
                            child: Text(
                              NumberFormat('00').format(index),
                              style: const TextStyle(fontSize: 22),
                            ),
                          );
                        }),
                      ),
                    ),
                    const Text(":", style: TextStyle(fontSize: 24)),
                    // Dakika Seçici
                    SizedBox(
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selectedMinute),
                        itemExtent: 40,
                        onSelectedItemChanged: (int index) {
                          selectedMinute = index;
                        },
                        children: List.generate(60, (index) {
                          return Center(
                            child: Text(
                              NumberFormat('00').format(index),
                              style: const TextStyle(fontSize: 22),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final selectedTime = TimeOfDay(hour: selectedHour, minute: selectedMinute);
                    if (isBedTime) {
                      bedTime = selectedTime;
                    } else {
                      wakeTime = selectedTime;
                    }
                  });
                  Navigator.pop(context);
                },
                child: Text(LanguageProvider.translate(context, 'confirm'), style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveData() async {
    final today = _formattedDate(widget.selectedDate);
    final docRef =
    FirebaseFirestore.instance.collection(widget.username).doc(today);

    await docRef.set({
      'createdAt': today,
      'bedTime': bedTime?.format(context),
      'wakeTime': wakeTime?.format(context),
      'alarmCount': alarmTimes.length,
      'alarmTimes': alarmTimes.map((t) => t?.format(context) ?? '').toList(),
      'diaperWetness': diaperWetness,
      'outsideUrine': outsideUrine,
      'morningStatus': morningStatus,
      'moodStatus': moodStatus,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LanguageProvider.translate(context, 'saveSuccess')),
      ),
    );
    setState(() {
      _hasRecord = true;
    });
  }


  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    // Boş bir seçenek başa ekleniyor
    final List<DropdownMenuItem<String>> dropdownItems = [
      DropdownMenuItem(
        value: null,
        child: Text(LanguageProvider.translate(context, 'pleaseSelect')), // örn. "Lütfen seçiniz"
      ),
      ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    ];

    return DropdownButtonFormField<String>(
      value: value,
      items: dropdownItems,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAlarmInput(BuildContext context) {
    final tr = (String key) => LanguageProvider.translate(context, key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberInput(
          controller: _alarmCountController,
          label: tr('alarmCount'),
          icon: Icons.alarm,
          onChanged: (val) {
            final count = int.tryParse(val) ?? 0;
            setState(() {
              alarmTimes = List.generate(count, (_) => null);
              diaperWetness = List.generate(count, (_) => tr('less'));
              outsideUrine = List.generate(count, (_) => tr('less'));
            });
          },
        ),
        const SizedBox(height: 20),
        for (int i = 0; i < alarmTimes.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${tr('alarm')} ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      alarmTimes[i] = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    alarmTimes[i]?.format(context) ?? tr('selectTime'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                value: diaperWetness[i],
                label: tr('diaperWetness'),
                items: [tr('less'), tr('medium'), tr('much')],
                icon: Icons.invert_colors,
                onChanged: (val) => setState(() => diaperWetness[i] = val!),
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                value: outsideUrine[i],
                label: tr('outsideUrine'),
                items: [tr('less'), tr('medium'), tr('much')],
                icon: Icons.bloodtype,
                onChanged: (val) => setState(() => outsideUrine[i] = val!),
              ),
              const Divider(),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formattedDate(widget.selectedDate);
    final tr = (String key) => LanguageProvider.translate(context, key);

    return Scaffold(
      appBar: AppBar(
        title: Text('$formattedDate ${tr('dailyRecord')}'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTimeTile(
              context,
              title: bedTime == null
                  ? LanguageProvider.translate(context, 'selectBedTime')
                  : '${LanguageProvider.translate(context, 'bedTime')}: ${bedTime!.format(context)}',
              icon: Icons.nightlight_round,
              onTap: () => _pickTime(context, true),
            ),
            const SizedBox(height: 20),
            _buildTimeTile(
              context,
              title: wakeTime == null
                  ? LanguageProvider.translate(context, 'selectWakeTime')
                  : '${LanguageProvider.translate(context, 'wakeTime')}: ${wakeTime!.format(context)}',
              icon: Icons.wb_sunny,
              onTap: () => _pickTime(context, false),
            ),
            const SizedBox(height: 20),
            _buildAlarmInput(context),
            const SizedBox(height: 20),
            _buildDropdown(
              value: morningStatus,
              label: tr('morningStatus'),
              items: [tr('completelyDry'), tr('withAlarm'), tr('wet')],
              icon: Icons.wb_cloudy,
              onChanged: (val) => setState(() => morningStatus = val!),
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              value: moodStatus,
              label: tr('mood'),
              items: [tr('happy'), tr('unhappy'), tr('normal')],
              icon: Icons.mood,
              onChanged: (val) => setState(() => moodStatus = val!),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveData,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(tr('save'), style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTile(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.keyboard_arrow_down),
        onTap: onTap,
      ),
    );
  }
}