import 'package:drydays/rapor_olusturma_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_page.dart';
import 'calendar_page.dart';
import 'language_provider.dart';
import 'ogretici_page.dart';
import 'products_page.dart';
import 'enuresis_page.dart';
import 'how_to_use_page.dart';
import 'blog_page.dart';
import 'contact_page.dart';
import 'bluetooth_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    BuildContext context,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown[800]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFD8C980),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF61A4BB), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/drydays.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          _buildDrawerItem(
            Icons.home,
            LanguageProvider.translate(context, 'home'),
            context,
            HomePage(title: LanguageProvider.translate(context, 'home')),
          ),
          _buildDrawerItem(
            Icons.play_circle,
            LanguageProvider.translate(context, 'howToUse'),
            context,
            const HowToUsePage(),
          ),
          _buildDrawerItem(
            Icons.contact_mail,
            LanguageProvider.translate(context, 'contact'),
            context,
            const ContactPage(),
          ),
          const Divider(),
          _buildDrawerItem(
            Icons.calendar_month,
            LanguageProvider.translate(context, 'calendar'),
            context,
            const CalendarPage(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.teal),
            title: Text(
              LanguageProvider.translate(context, 'language'),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text(
                      LanguageProvider.translate(context, 'languageSelect'),
                    ),
                    content: Consumer<LanguageProvider>(
                      builder: (context, lang, _) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile(
                              title: Text(
                                LanguageProvider.translate(context, 'turkish'),
                              ),
                              value: 'tr',
                              groupValue: lang.currentLocale.languageCode,
                              onChanged: (value) {
                                lang.changeLanguage(value as String);
                                Navigator.of(context).pop();
                              },
                            ),
                            RadioListTile(
                              title: Text(
                                LanguageProvider.translate(
                                  context,
                                  '🇦🇿 Azərbaycan',
                                ),
                              ),
                              value: 'az',
                              groupValue: lang.currentLocale.languageCode,
                              onChanged: (value) {
                                lang.changeLanguage(value as String);
                                Navigator.of(context).pop();
                              },
                            ),
                            RadioListTile(
                              title: Text(
                                LanguageProvider.translate(
                                  context,
                                  '🇬🇧 English',
                                ),
                              ),
                              value: 'en',
                              groupValue: lang.currentLocale.languageCode,
                              onChanged: (value) {
                                lang.changeLanguage(value as String);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _peeCountController = TextEditingController();
  final TextEditingController _wetCountController = TextEditingController();

  String? savedName;
  TimeOfDay? bedTime;
  TimeOfDay? wakeTime;
  String? morningStatus;
  String? moodStatus;
  final TextEditingController _alarmCountController = TextEditingController();
  List<TimeOfDay?> alarmTimes = [];
  List<String> diaperWetness = [];
  List<String> outsideUrine = [];

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

  Future<void> _loadSavedName() async {
    await _showPrivacyNoticeDialog(); // Önce gizlilik bildirimi göster

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const TutorialDialog(),
        );
      });
      await prefs.setBool('isFirstLaunch', false);
    }

    final name = prefs.getString('username');

    if (name != null && name.isNotEmpty) {
      setState(() {
        savedName = name;
        _nameController.text = name;
      });
      await _loadTodayData();
    } else {
      await _promptForName();
    }
  }

  Future<void> _showPrivacyNoticeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenNotice = prefs.getBool('hasSeenPrivacyNotice') ?? false;

    if (!hasSeenNotice) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(LanguageProvider.translate(context, 'privacyNoticeTitle')),
          content: Text(LanguageProvider.translate(context, 'privacyNoticeContent')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(LanguageProvider.translate(context, 'ok')),
            ),
          ],
        ),
      );

      await prefs.setBool('hasSeenPrivacyNotice', true);
    }
  }

  Future<void> _promptForName() async {
    String enteredName = "";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 48, color: Colors.teal),
                const SizedBox(height: 16),
                Text(
                  LanguageProvider.translate(context, 'enterName'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: LanguageProvider.translate(context, 'nameHint'),
                    prefixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    enteredName = value.trim();
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (enteredName.isNotEmpty) {
                        final doc = await FirebaseFirestore.instance
                            .collection('all_users')
                            .doc(enteredName)
                            .get();

                        if (doc.exists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(LanguageProvider.translate(context, 'nameExists')),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          await FirebaseFirestore.instance
                              .collection('all_users')
                              .doc(enteredName)
                              .set({'createdAt': Timestamp.now()});
                          await FirebaseFirestore.instance
                              .collection(enteredName)
                              .doc('meta')
                              .set({'createdAt': Timestamp.now()});

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('username', enteredName);

                          setState(() {
                            savedName = enteredName;
                            _nameController.text = enteredName;
                          });

                          Navigator.of(context).pop();
                          await _loadTodayData();
                        }
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: Text(LanguageProvider.translate(context, 'save')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
      },
    );
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }

  String _formattedDate(DateTime date) {
    final localTime = DateTime.now();
    final adjustedTime =
        localTime.hour >= 22
            ? localTime.add(const Duration(days: 1))
            : localTime;
    return DateFormat('dd.MM.yyyy').format(adjustedTime);
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
    final name = _nameController.text.trim();
    if (name.isEmpty || bedTime == null || wakeTime == null) return;

    await _saveName(name);

    final now = DateTime.now();
    DateTime saveDate = now;
    if (now.hour >= 22) {
      saveDate = DateTime(now.year, now.month, now.day + 1);
    }

    final today = _formattedDate(saveDate);
    final docRef = FirebaseFirestore.instance.collection(name).doc(today);

    await docRef.set({
      'createdAt': today,
      'bedTime': bedTime!.format(context),
      'wakeTime': wakeTime!.format(context),
      'alarmCount': alarmTimes.length,
      'alarmTimes': alarmTimes.map((t) => t?.format(context) ?? '').toList(),
      'diaperWetness': diaperWetness,
      'outsideUrine': outsideUrine,
      'morningStatus': morningStatus,
      'moodStatus': moodStatus,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Bilgiler kaydedildi")));
  }

  Future<void> _loadTodayData() async {
    if (savedName == null) return;

    final today = _formattedDate(DateTime.now());
    final docRef = FirebaseFirestore.instance.collection(savedName!).doc(today);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          final contextVal = context;
          bedTime = _parseTimeOfDay(data['bedTime']);
          wakeTime = _parseTimeOfDay(data['wakeTime']);
          _peeCountController.text = (data['peeCount'] ?? 0).toString();
          _wetCountController.text = (data['wetCount'] ?? 0).toString();
          morningStatus = data['morningStatus'] ?? LanguageProvider.translate(context, 'tamKuru');
          moodStatus = data['moodStatus'] ?? LanguageProvider.translate(context, 'normal');
        });
      }
    }
  }

  TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null || !timeString.contains(':')) return null;
    final parts = timeString.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
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

  @override
  Widget build(BuildContext context) {
    final tr = (String key) => LanguageProvider.translate(context, key);
    return Scaffold(
      backgroundColor: Color(0xFFE3E4D6), // <-- Bu satırı ekle
      appBar: AppBar(
        title: Text(LanguageProvider.translate(context, 'pageTitle')),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      drawer: HomePage(title: "İşlem Girişi").buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBABD66), Color(0xFFE3E4D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (savedName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.teal[50],
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.teal),
                      title: Text(
                        '${LanguageProvider.translate(context, 'nameSurname')}: $savedName',
                      ),
                      subtitle: Text(
                        '${LanguageProvider.translate(context, 'day')}: ${_formattedDate(DateTime.now())}',
                      ),
                    ),
                  ),
                ),
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
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveData,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: Text(LanguageProvider.translate(context, 'save'), style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50), // Araya biraz boşluk koyuyorum
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RaporOlusturmaPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.description, color: Colors.white),
                  label: Text(LanguageProvider.translate(context, 'generateReport'), style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // En son biraz boşluk bırakalım
            ],
          ),
        ),
      ),
    );
  }
}
