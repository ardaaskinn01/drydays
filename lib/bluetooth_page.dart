import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'main.dart';

bool isBluetoothStarted = false;
double _alarmVolume = 0.5;
String? _selectedAlarm;
Timer? _scanTimer;
bool _isPlaying = false;
String? _currentlyPlaying;
String? _alarmingDeviceName;
bool _isAnimating = true;
bool alarmingDeviceStillExists = false;

final AudioPlayer _audioPlayer = AudioPlayer();
List<String> foundDevices = [];

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {

  Future<void> stopBluetooth() async {
    FlutterBluePlus.stopScan();
    _scanTimer?.cancel();
    await WakelockPlus.disable();
    setState(() {
      isBluetoothStarted = false;
      foundDevices.clear();
    });
  }

  Future<void> requestPermissions() async {
    await [Permission.bluetoothScan, Permission.bluetoothConnect, Permission.location, Permission.notification
    ].request();
  }

  Future<void> startBluetooth() async {
    await initializeService();
    // Alarm seçili mi kontrol et
    if (_selectedAlarm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen önce bir alarm seçiniz")),
      );
      return;
    }

    await requestPermissions();

    final isOn = await FlutterBluePlus.isOn;
    if (!isOn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen Bluetooth'u açın")),
      );
      return;
    }

    setState(() {
      isBluetoothStarted = true;
      foundDevices.clear();
    });

    // İlk taramayı başlat
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 12),
      androidScanMode: AndroidScanMode.lowLatency,
    );

    // Sonuçları dinle
    FlutterBluePlus.scanResults.listen((results) async {
      bool alarmingDeviceStillExists = false;

      for (ScanResult result in results) {
        final name = result.device.name;
        final manufacturerData = result.advertisementData.manufacturerData;

        // ESP32 ise ve veri içeriyorsa
        if (name.toLowerCase().contains("esp32")) {
          // İsteğe bağlı: ESP32 isimli cihazları listeye ekleyebilirsin
          if (!foundDevices.contains(name)) {
            setState(() {
              foundDevices.add(name);
            });
          }

          // Örnek olarak "nem=1" verisi geldi mi?
          if (manufacturerData.isNotEmpty) {
            final rawData = manufacturerData.values.first;
            final dataString = String.fromCharCodes(rawData);

            if (dataString.contains("nem=1")) {
              if (!_isPlaying && _selectedAlarm != null) {
                await playAlarm(_selectedAlarm!);
                setState(() {
                  _alarmingDeviceName = name;
                });
              }
              alarmingDeviceStillExists = true;
            }
          }
        }
      }

      // Eğer alarm çalıyorsa ama artık veri yoksa durdur
      if (_isPlaying && !alarmingDeviceStillExists) {
        await stopAlarm();
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

  Future<void> playAlarm(String fileName) async {
    await _audioPlayer.stop();
    await _audioPlayer.setVolume(_alarmVolume);

    // 🔁 Sürekli tekrar etmesi için döngü modu ayarla
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);

    await _audioPlayer.play(AssetSource('alarms/$fileName'));

    // Alarm çalarken wakelock'u etkinleştir
    await WakelockPlus.enable();

    setState(() {
      _isPlaying = true;
      _isAnimating = true;
    });

    startNameAnimation();
  }

  Future<void> stopAlarm() async {
    await _audioPlayer.stop();

    // 🔁 Döngüyü devre dışı bırak
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
              title: const Text("Alarm Seç"),
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
                      leading:
                          isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green,)
                              : const Icon(Icons.circle_outlined),
                      title: Text("Alarm ${index + 1}"),
                      trailing: IconButton(
                        icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                        onPressed: () async {
                          if (isPlaying) {
                            await _audioPlayer.stop();
                            setState(() {
                              _currentlyPlaying = null;
                            });
                            setStateDialog(
                              () {},
                            ); // Dialog içindeki UI'ı yenile
                          } else {
                            await _audioPlayer.stop();
                            await _audioPlayer.play(
                              AssetSource('alarms/$fileName'),
                            );
                            setState(() {
                              _currentlyPlaying = fileName;
                            });
                            setStateDialog(() {}); // UI güncelle
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

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Bluetooth Ayarları',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
              isBluetoothStarted ? "Bluetooth'u Durdur" : "Bluetooth'u Başlat",
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
                            const Text(
                              'Bulunan Cihazlar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
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
                        : const Center(
                          child: Text("Bluetooth henüz başlatılmadı"),
                        ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (_isPlaying && _alarmingDeviceName != null) ...[
            Center(
              child: Column(
                children: [
                  const Text(
                    "🔔 ALARM!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
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
                    label: const Text("Alarmı Kapat"),
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
                const Text(
                  "🔔 Alarm Ayarları",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => selectAlarm(context),
                      icon: const Icon(Icons.music_note, size: 20),
                      label: const Text("Alarm Seç"),
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
                            ? "Seçili: Alarm ${_selectedAlarm!.split('.').first}"
                            : "Alarm seçilmedi",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      onPressed:
                          _selectedAlarm != null
                              ? () async {
                                if (_isPlaying) {
                                  await stopAlarm();
                                } else {
                                  await playAlarm(_selectedAlarm!);
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
                const Text(
                  "🔊 Ses Seviyesi",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: _alarmVolume,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _alarmVolume = value;
                    });
                    await prefs.setDouble('alarm_volume', value);
                  }, min: 0, max: 1, divisions: 10, label: "${(_alarmVolume * 100).round()}%", activeColor: Colors.blueAccent, inactiveColor: Colors.blue[100],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}