import UIKit
import Flutter
import FirebaseCore
import flutter_local_notifications
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase debug logları (isteğe bağlı)
    FirebaseConfiguration.shared.setLoggerLevel(.debug)

    // Firebase başlatma
    FirebaseApp.configure()

    // Flutter eklentileri
    GeneratedPluginRegistrant.register(with: self)

    // Bildirim izinleri (flutter_local_notifications için)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}