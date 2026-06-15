import BareKit
import SwiftUI
import UserNotifications

@main
struct App: SwiftUI.App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  @StateObject private var model = SyncModel()

  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView(model: model)
        .onAppear {
          requestPushNotificationPermission()
        }
    }
    .onChange(of: scenePhase) { phase in
      switch phase {
      case .background:
        model.suspend()
      case .active:
        model.resume()
      default:
        break
      }
    }
  }

  private func requestPushNotificationPermission() {
    let center = UNUserNotificationCenter.current()

    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("\(error.localizedDescription)")
      } else if granted {
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      } else {
        print("Notification authorization denied")
      }
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken token: Data
  ) {
    print("Token: \(token.map { String(format: "%02x", $0) }.joined())")
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("\(error.localizedDescription)")
  }
}
