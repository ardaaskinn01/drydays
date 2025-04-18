import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await WakelockPlus.enable();


  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Bluetooth Alarm",
      content: "Bluetooth taraması çalışıyor...",
    );
  }

  if (Platform.isAndroid) {
    final androidService = service as AndroidServiceInstance;
    await androidService.setAsForegroundService();
    await androidService.setAsBackgroundService(); // Ekstra WakeLock
  }

  final prefs = await SharedPreferences.getInstance();
  final selectedAlarm = prefs.getString('selected_alarm');
  final alarmVolume = prefs.getDouble('alarm_volume') ?? 0.5;

  final player = AudioPlayer()
    ..setPlayerMode(PlayerMode.mediaPlayer) // Android için kritik
    ..setReleaseMode(ReleaseMode.loop)
    ..setAudioContext(AudioContext(
      android: AudioContextAndroid(
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.alarm,
        stayAwake: true
      ),
    ));
  String? alarmingDeviceName;
  bool isPlaying = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Servisin foreground bildirimini her döngüde güncelle
  Timer.periodic(const Duration(seconds: 12), (timer) async {

    final isOn = await FlutterBluePlus.isOn;
    if (!isOn) return;

    final isScanning = await FlutterBluePlus.isScanningNow;
    if (!isScanning) {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 12),
        androidScanMode: AndroidScanMode.lowLatency,
      );
    }

    FlutterBluePlus.scanResults.listen((results) async {
      bool alarmingDeviceStillExists = false;
      bool deviceNameChanged = false;

      for (var result in results) {
        final name = result.device.name;

        if (name.toLowerCase().contains("band") && name.endsWith("4") && selectedAlarm != null) {
          if (!isPlaying) {
            await player.stop();
            await player.setVolume(alarmVolume);
            await player.setReleaseMode(ReleaseMode.loop);
            await player.play(AssetSource('alarms/$selectedAlarm'));
            await WakelockPlus.enable();
            isPlaying = true;
            alarmingDeviceName = name;
          }
          alarmingDeviceStillExists = true;
        }

        if (alarmingDeviceName != null && name == alarmingDeviceName && !name.endsWith("4")) {
          deviceNameChanged = true;
        }
      }

      if (isPlaying && (!alarmingDeviceStillExists || deviceNameChanged)) {
        await player.stop();
        await player.setReleaseMode(ReleaseMode.loop);
        await WakelockPlus.disable();
        isPlaying = false;
        alarmingDeviceName = null;
      }
    });
  });
}
