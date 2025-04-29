import 'dart:io';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_page.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('tr_TR', null);

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();

    await AndroidAlarmManager.periodic(
      const Duration(minutes: 1),
      0,
      myAlarmTask,
      wakeup: true,
      exact: true,
    );
  }

  runApp(const MyApp());
}


 void myAlarmTask() async {
  // Bildirim gönder
  flutterLocalNotificationsPlugin.show(
    999,
    "Bluetooth Alarm",
    "Cihaz bulundu veya tetikleme zamanı!",
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'bluetooth_alarm',
        'Bluetooth Alarm',
        channelDescription: 'Bluetooth alarm bildirimi',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
      ),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // 🔔 Bildirim sistemi başlat
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'bluetooth_alarm',
      'Bluetooth Alarm Servisi',
      description: 'Bluetooth çalışıyor. Alarm hazır.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'bluetooth_alarm',
      initialNotificationTitle: 'Bluetooth Alarm',
      initialNotificationContent: 'Tarama başlatıldı',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  await service.startService();
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await WakelockPlus.enable();

  const androidDetails = AndroidNotificationDetails(
    'bluetooth_alarm',
    'Bluetooth Alarm',
    channelDescription: 'Bluetooth cihaz taraması',
    importance: Importance.max,
    priority: Priority.max,
    ongoing: true,
    visibility: NotificationVisibility.public,
    playSound: true,
    enableVibration: true,
  );

  final notificationDetails = NotificationDetails(android: androidDetails);

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  FlutterBluePlus.scanResults.listen((results) async {
    String status = "Tarama yapılıyor...";
    bool alarmingDeviceStillExists = false;

    for (var result in results) {
      final name = result.device.name;
      final manufacturerData = result.advertisementData.manufacturerData;

      if (name.toLowerCase().contains("esp32")) {
        // İsteğe bağlı: cihaz ismini statüye yazabiliriz
        status = "ESP32 bulundu: $name";

        if (manufacturerData.isNotEmpty) {
          final rawData = manufacturerData.values.first;
          final dataString = String.fromCharCodes(rawData);

          if (dataString.contains("nem=1")) {
            status = "Uyarı! ESP32 cihazı nem=1 gönderdi.";
            alarmingDeviceStillExists = true;
          }
        }
      }
    }

    // Bildirim güncelle
    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: "Bluetooth Alarm",
        content: status,
      );
    }

    await flutterLocalNotificationsPlugin.show(
      888,
      "Bluetooth Alarm",
      status,
      notificationDetails,
    );

    // Alarm durumu kontrolü (opsiyonel olarak background alarm tetikleme de yapılabilir)
  });

  Timer.periodic(const Duration(seconds: 15), (timer) async {
    if (!await FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidScanMode: AndroidScanMode.lowLatency,
      );
    }
  });
}

Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   Future<void> requestNotificationPermission() async {
    if (await Permission.notification.request().isGranted) {
      print("Bildirim izni verildi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DryDays',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // İngilizce
        Locale('az'), // Azerice
      ],
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage(title: 'Ana Sayfa')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2196F3), // açık mavi
              Color(0xFF0D47A1), // koyu mavi
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/drydays.png',
                width: MediaQuery.of(context).size.width
              ),
              const SizedBox(height: 40),
              const Text(
                'Uygulama Yükleniyor...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
