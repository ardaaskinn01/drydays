/* import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'alarm_records_screen.dart';
import 'language_provider.dart';
import 'main.dart';

bool isBluetoothStarted = false;
double _alarmVolume = 0.8;
String? _selectedAlarm;
Timer? _scanTimer;
bool _isPlaying = false;
String? _currentlyPlaying;
String? _alarmingDeviceName;
bool _isAnimating = true;
bool alarmingDeviceStillExists = false;

AudioPlayer _audioPlayer = AudioPlayer();
List<String> foundDevices = [];

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  bool _isAuthorized = false;
  TextEditingController _passwordController = TextEditingController();
  Timer? scanTimer;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentRecordId;

  Future<void> logAlarmStart(String deviceName) async {
    final username = await getUsernameFromPrefs();
    final date = getFormattedDate();
    final recordId = await getNextRecordId(username, date);

    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm:ss').format(now);

    await _firestore
        .collection(username)
        .doc(date)
        .collection('alarmrecords')
        .doc(recordId)
        .set({
      'device': deviceName,
      'startTime': formattedTime,
      'endTime': null, // sonra güncellenir
    });

    // Aktif kaydın id'sini sakla
    currentRecordId = recordId;
  }

  Future<void> logAlarmStop(String deviceName) async {
    if (currentRecordId == null) return;

    final username = await getUsernameFromPrefs();
    final date = getFormattedDate();

    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm:ss').format(now);

    await _firestore
        .collection(username)
        .doc(date)
        .collection('alarmrecords')
        .doc(currentRecordId!)
        .update({
      'endTime': formattedTime,
    });

    currentRecordId = null;
  }
// Bugünün tarihini döndürür: 05.05.2025
  String getFormattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";
  }

  Future<String> getUsernameFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'unknown_user';
  }

// Bugünkü kayıt sayısını bulur (01, 02, ...)
  Future<String> getNextRecordId(String username, String date) async {
    final snapshot = await _firestore
        .collection(username)
        .doc(date)
        .collection('alarmrecords')
        .get();
    final count = snapshot.docs.length + 1;
    return count.toString().padLeft(2, '0');
  }

  Future<void> stopBluetooth() async {
    await FlutterBluePlus.stopScan();
    WakelockPlus.disable();
    scanTimer?.cancel();
    scanTimer = null;
    setState(() {
      isBluetoothStarted = false;
      foundDevices.clear();
      _alarmingDeviceName = null;
    });
  }


  Future<void> requestPermissions() async {
    await [Permission.bluetoothScan, Permission.location, Permission.notification
    ].request();
  }

  Future<void> startBluetooth() async {
    // await initializeService();

    if (_selectedAlarm == null) {
      String message = LanguageProvider.translate(context, 'pleaseSelectAlarm');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    await requestPermissions();

    final isOn = await FlutterBluePlus.isOn;
    if (!isOn) {
      String message = LanguageProvider.translate(context, 'turnOnBluetooth');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    setState(() {
      isBluetoothStarted = true;
      foundDevices.clear();
    });

    // Tarama işlemini her 10 saniyede bir tekrarla
    scanTimer?.cancel(); // varsa önceki taramayı durdur
    scanTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
        androidScanMode: AndroidScanMode.lowLatency,
      );
    });

    // Cihazları dinle
    FlutterBluePlus.scanResults.listen((results) async {
      bool alarmingDeviceStillExists = false;

      for (ScanResult result in results) {
        final name = result.device.name;

        if (name == "Islak1") {
          if (!foundDevices.contains(name)) {
            setState(() {
              foundDevices.add(name);
            });
          }

          if (!_isPlaying && _selectedAlarm != null) {
            await playAlarm(_selectedAlarm!, name);  // name burada cihaz adı
            setState(() {
              _alarmingDeviceName = name;
            });
          }


          alarmingDeviceStillExists = true;
        }
      }

      // Islak1 artık görünmüyorsa alarmı durdur
      if (_isPlaying && !alarmingDeviceStillExists) {
        await stopAlarm();
        await logAlarmStop(_alarmingDeviceName ?? "Unknown");
        setState(() {
          _alarmingDeviceName = null;
          foundDevices.remove("Islak1");
        });
      }
    });
  }


  void startNameAnimation() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!_isPlaying) {
        timer.cancel();
        setState(() => _isAnimating = false);
      } else {
        setState(() {
          _isAnimating = !_isAnimating;
        });
      }
    });
  }

  Future<void> playAlarm(String fileName, String deviceName) async {
    if (_audioPlayer.state == PlayerState.stopped || _audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.stop();
    } else {
      _audioPlayer = AudioPlayer();
    }

    await logAlarmStart(deviceName);

    await _audioPlayer.setVolume(_alarmVolume);
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('alarms/$fileName'));

    await WakelockPlus.enable();

    setState(() {
      _isPlaying = true;
      _isAnimating = true;
    });

    startNameAnimation();
  }



  Future<void> stopAlarm() async {
    await _audioPlayer.stop();
    await logAlarmStop(_alarmingDeviceName ?? "Unknown");
    await _audioPlayer.setReleaseMode(ReleaseMode.release);

    setState(() {
      _isPlaying = false;
      _isAnimating = false;
      _alarmingDeviceName = null;
    });
  }


  Future<void> loadSelectedAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedAlarm = prefs.getString('selected_alarm');
      _alarmVolume = prefs.getDouble('alarm_volume') ?? 0.5;
    });
  }

  Future<void> selectAlarm(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(LanguageProvider.translate(context, 'selectingAlarm')),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final fileName = '${index + 1}.mp3';
                    final isSelected = _selectedAlarm == fileName;
                    final isPlaying = _currentlyPlaying == fileName;

                    return ListTile(
                      leading: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.circle_outlined),
                      title: Text(
                        '${LanguageProvider.translate(context, 'alarm')} ${index + 1}',
                      ),
                      trailing: IconButton(
                        icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                        onPressed: () async {
                          if (isPlaying) {
                            await _audioPlayer.stop();
                            setState(() {
                              _currentlyPlaying = null;
                            });
                            setStateDialog(() {});
                          } else {
                            await _audioPlayer.stop();
                            await _audioPlayer.play(
                              AssetSource('alarms/$fileName'),
                            );
                            setState(() {
                              _currentlyPlaying = fileName;
                            });
                            setStateDialog(() {});
                          }
                        },
                      ),
                      onTap: () async {
                        await prefs.setString('selected_alarm', fileName);
                        setState(() {
                          _selectedAlarm = fileName;
                        });
                        await _audioPlayer.stop();
                        setState(() {
                          _currentlyPlaying = null;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );

    await _audioPlayer.stop();
    setState(() {
      _currentlyPlaying = null;
    });
  }

  Future<void> _showPasswordDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(LanguageProvider.translate(context, 'passwordTitle')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LanguageProvider.translate(context, 'passwordHint')),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: LanguageProvider.translate(context, 'passwordLabel'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_passwordController.text == "1234") {
                  setState(() {
                    _isAuthorized = true;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(LanguageProvider.translate(context, 'wrongPassword'))),
                  );
                }
              },
              child: Text(LanguageProvider.translate(context, 'loginButton')),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _showPasswordDialog);

    _audioPlayer.setAudioContext(AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        //options: {AVAudioSessionOptions.defaultToSpeaker},
      ),
      android: const AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
    ));
    loadSelectedAlarm();
  }

  void printCallback() {
    print("Alarm tetiklendi! Uygulama uyanık.");

  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _audioPlayer.dispose();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthorized) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F5F2),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        centerTitle: true,
        title: Text(
          LanguageProvider.translate(context, 'bluetoothSettings'),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlarmRecordsScreen()),
              );
            },
            child: Text(
              LanguageProvider.translate(context, 'alarmRecords'),
              style: const TextStyle(
                color: Colors.amberAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Icon(Icons.bluetooth_rounded, size: 100, color: Colors.blue[700]),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: isBluetoothStarted ? stopBluetooth : startBluetooth,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isBluetoothStarted ? Colors.red[600] : Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 5,
            ),
            icon: Icon(isBluetoothStarted ? Icons.stop : Icons.play_arrow),
            label: Text(
              isBluetoothStarted
                  ? LanguageProvider.translate(context, 'stopBluetooth')
                  : LanguageProvider.translate(context, 'startBluetooth'),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:
                    isBluetoothStarted
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LanguageProvider.translate(context, 'foundDevices')),
                            const Divider(),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.separated(
                                itemCount: foundDevices.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 6),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      const Icon(
                                        Icons.bluetooth_audio,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        foundDevices[index],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                        : Center(
                          child: Text(LanguageProvider.translate(context, 'bluetoothNotStarted')),
                        ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (_isPlaying && _alarmingDeviceName != null) ...[
            Center(
              child: Column(
                children: [
                  Text(
                    LanguageProvider.translate(context, 'alarmActive'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  AnimatedScale(
                    scale: _isAnimating ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    child: Text(
                      _alarmingDeviceName!,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: stopAlarm,
                    icon: const Icon(Icons.stop),
                    label: Text(LanguageProvider.translate(context, 'stopAlarm')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageProvider.translate(context, 'alarmSettings')),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => selectAlarm(context),
                      icon: const Icon(Icons.music_note, size: 20),
                      label: Text(LanguageProvider.translate(context, 'selectAlarm')),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _selectedAlarm != null
                            ? "${LanguageProvider.translate(context, 'selected')}: Alarm ${_selectedAlarm!.split('.').first}"
                            : LanguageProvider.translate(context, 'noAlarmSelected'),
                      ),
                    ),
                    IconButton(
                      onPressed:
                          _selectedAlarm != null
                              ? () async {
                                if (_isPlaying) {
                                  await stopAlarm();
                                } else {
                                  await playAlarm(_selectedAlarm!, "");
                                }
                              }
                              : null,
                      icon: Icon(
                        _isPlaying ? Icons.stop_circle : Icons.play_circle_fill, color: Colors.blue, size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(LanguageProvider.translate(context, 'volume')),
                Slider(
                  value: _alarmVolume,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _alarmVolume = value;
                    });

                    await prefs.setDouble('alarm_volume', value);

                    // Eğer alarm çalıyorsa, ses seviyesini güncelle
                    if (_isPlaying) {
                      await _audioPlayer.setVolume(_alarmVolume);
                    }
                  },
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: "${(_alarmVolume * 100).round()}%",
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.blue[100],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/