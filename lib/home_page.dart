import 'package:drydays/rapor_olusturma_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_page.dart';
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
            'Ana Sayfa',
            context,
            HomePage(title: "Ana Sayfa"),
          ),
          /* _buildDrawerItem(
            Icons.info,
            'Hakkımızda',
            context,
            const AboutPage(),
          ),
          _buildDrawerItem(
            Icons.shopping_bag,
            'Ürünler & Aksesuarlar',
            context,
            const ProductsPage(),
          ),*/
          _buildDrawerItem(
            Icons.question_answer,
            'Enürezis Nokturna Nedir',
            context,
            const EnuresisPage(),
          ),
         /* _buildDrawerItem(
            Icons.play_circle,
            'Dry Days Nasıl Kullanılır',
            context,
            const HowToUsePage(),
          ),*/
          _buildDrawerItem(Icons.article, 'Blog', context, const BlogPage()),
          _buildDrawerItem(
            Icons.contact_mail,
            'İletişim',
            context,
            const ContactPage(),
          ),
        /*  const Divider(),
          _buildDrawerItem(
            Icons.bluetooth,
            'Bluetooth',
            context,
            const BluetoothPage(),
          ),*/
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
    await _showPrivacyNoticeDialog(); // Bilgilendirme dialogunu ilk sıraya ekledik

    final prefs = await SharedPreferences.getInstance();
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
          title: const Text("Gizlilik Bilgilendirmesi"),
          content: const Text(
            "Bu uygulama, kullanıcıdan gelen verileri saklar. "
                "Geliştirici bu verilere erişmez ve işlemez. "
                "Uygulamanın amacı yalnızca kullanıcıların kendi süreçlerini takip etmelerini kolaylaştırmaktır.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        ),
      );

      // Kullanıcı bir kere gördü, bir daha gösterme
      await prefs.setBool('hasSeenPrivacyNotice', true);
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

    await _loadTodayData();
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
              Text(
                'Alarm ${i + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(alwaysUse24HourFormat: true),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
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
                label: 'Tuvalette Sonlandırma Miktarı',
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
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
    return Scaffold(
      backgroundColor: Color(0xFFE3E4D6), // <-- Bu satırı ekle
      appBar: AppBar(
        title: Text(widget.title),
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
                  label: const Text(
                    'Kaydet',
                    style: TextStyle(color: Colors.white),
                  ),
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
                  label: const Text(
                    'Rapor Oluştur',
                    style: TextStyle(color: Colors.white),
                  ),
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
