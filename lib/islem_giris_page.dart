import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IslemGirisPage extends StatefulWidget {
  const IslemGirisPage({super.key});

  @override
  State<IslemGirisPage> createState() => _IslemGirisPageState();
}

class _IslemGirisPageState extends State<IslemGirisPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _peeCountController = TextEditingController();
  final TextEditingController _wetCountController = TextEditingController();

  String? savedName;
  TimeOfDay? bedTime;
  TimeOfDay? wakeTime;
  String morningStatus = 'Kuru';
  String moodStatus = 'Normal';
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
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');

    if (name != null && name.isNotEmpty) {
      setState(() {
        savedName = name;
        _nameController.text = name;
      });
      await _loadTodayData();
    } else {
      // Eğer isim yoksa kullanıcıdan iste
      await _promptForName();
    }
  }

  Future<void> _promptForName() async {
    String enteredName = "";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String enteredName = '';

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 48, color: Colors.teal),
                const SizedBox(height: 16),
                const Text(
                  "İsim Giriniz",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "İsim Soyisim",
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
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('username', enteredName);
                        setState(() {
                          savedName = enteredName;
                          _nameController.text = enteredName;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Kaydet"),
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

    await _loadTodayData(); // isim kaydedildikten sonra günlük verileri yükle
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }

  String _formattedDate(DateTime date) {
    final localTime = DateTime.now(); // cihazın yerel saati
    final adjustedTime = localTime.hour >= 22
        ? localTime.add(const Duration(days: 1))
        : localTime;
    return DateFormat('dd.MM.yyyy').format(adjustedTime);
  }

  Future<void> _pickTime(bool isBedTime) async {
    final TimeOfDay? picked = await showTimePicker(
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
        if (isBedTime) {
          bedTime = picked;
        } else {
          wakeTime = picked;
        }
      });
    }
  }

  Future<void> _saveData() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || bedTime == null || wakeTime == null) return;

    await _saveName(name);

    // Bugünün tarihi
    final now = DateTime.now();

    // Eğer saat 22:00'den sonra ise, günü bir sonraki gün olarak ayarlıyoruz
    DateTime saveDate = now;
    if (now.hour >= 22) {
      saveDate = DateTime(now.year, now.month, now.day + 1); // Ertesi gün
    }

    final today = _formattedDate(saveDate);  // Tarih formatlama
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bilgiler kaydedildi")),
    );
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
          final contextVal = context; // context'in geçerli olduğunu garanti altına alalım

          bedTime = _parseTimeOfDay(data['bedTime']);
          wakeTime = _parseTimeOfDay(data['wakeTime']);
          _peeCountController.text = (data['peeCount'] ?? 0).toString();
          _wetCountController.text = (data['wetCount'] ?? 0).toString();
          morningStatus = data['morningStatus'] ?? 'Kuru';
          moodStatus = data['moodStatus'] ?? 'Normal';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İşlem Girişi'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                      'İsim Soyisim: $savedName',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Gün: ${_formattedDate(DateTime.now())}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            _buildTimeTile(
              context,
              title: bedTime == null
                  ? 'Gece yatma saati seçin'
                  : 'Yatma Saati: ${bedTime!.format(context)}',
              icon: Icons.nightlight_round,
              onTap: () => _pickTime(true),
            ),
            const SizedBox(height: 20),
            _buildTimeTile(
              context,
              title: wakeTime == null
                  ? 'Uyanma saati seçin'
                  : 'Uyanma Saati: ${wakeTime!.format(context)}',
              icon: Icons.wb_sunny,
              onTap: () => _pickTime(false),
            ),
            const SizedBox(height: 20),
            _buildAlarmInput(),
            const SizedBox(height: 20),
            _buildDropdown(
              value: morningStatus,
              label: 'Sabah Durumu',
              items: ['Kuru', 'Az Islak', 'Çok Islak'],
              icon: Icons.wb_cloudy,
              onChanged: (val) => setState(() => morningStatus = val!),
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              value: moodStatus,
              label: 'Ruh Hali',
              items: ['Mutlu', 'Mutsuz', 'Normal'],
              icon: Icons.mood,
              onChanged: (val) => setState(() => moodStatus = val!),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveData,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Kaydet', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTile(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
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

  Widget _buildAlarmInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberInput(
          controller: _alarmCountController,
          label: 'Alarm çalma sayısı',
          icon: Icons.alarm,
          onChanged: (val) {
            final count = int.tryParse(val) ?? 0;
            setState(() {
              alarmTimes = List.generate(count, (_) => null);
              diaperWetness = List.generate(count, (_) => 'Az');
              outsideUrine = List.generate(count, (_) => 'Az');
            });
          },
        ),
        const SizedBox(height: 20),
        for (int i = 0; i < alarmTimes.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alarm ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    alarmTimes[i]?.format(context) ?? 'Saat seçin',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                value: diaperWetness[i],
                label: 'Bez Islaklığı',
                items: ['Az', 'Orta', 'Çok'],
                icon: Icons.invert_colors,
                onChanged: (val) => setState(() => diaperWetness[i] = val!),
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                value: outsideUrine[i],
                label: 'Dışarı İşeme',
                items: ['Az', 'Orta', 'Çok'],
                icon: Icons.bloodtype,
                onChanged: (val) => setState(() => outsideUrine[i] = val!),
              ),
              const Divider(thickness: 1.0),
            ],
          ),
      ],
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    void Function(String)? onChanged, // onChanged eklendi
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged, // burada kullanıldı
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
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
