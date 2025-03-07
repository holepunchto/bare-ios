import BareKit
import SwiftUI
import UserNotifications
import os.log

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "App")

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
    logger.info("✅ APNs Device Token: \(tokenString)")
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    logger.info("❌ Failed to register for remote notifications: \(error.localizedDescription)")
  }
}

@main
struct App: SwiftUI.App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  private var worklet = Worklet()

  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          worklet.start(name: "app", ofType: "bundle")
          requestPushNotificationPermission()
        }
        .onDisappear {
          worklet.terminate()
        }
    }
    .onChange(of: scenePhase) { phase in
      switch phase {
      case .background:
        worklet.suspend()
      case .active:
        worklet.resume()
      default:
        break
      }
    }
  }
  private func requestPushNotificationPermission() {
    let center = UNUserNotificationCenter.current()

    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        logger.info("❌ Push Notification Authorization Error: \(error.localizedDescription)")
      } else if granted {
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
          logger.info("✅ Push Notification Authorization Granted")
        }
      } else {
        logger.info("❌ Push Notification Authorization Denied")
      }
    }
  }
}

struct ContentView: View {
  var body: some View {
    Text("Hello SwiftUI!")
  }
}
