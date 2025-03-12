import BareKit

import SwiftUI
import UserNotifications

@main
struct App: SwiftUI.App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private var worklet = Worklet()
  private let callManager = CallManager()
  private var pushManager = PushKitRegistryDelegate()

  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView(callManager: callManager)
        .onAppear {
          pushManager.setCallManager(callManager)
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

struct ContentView: View {
  var callManager: CallManager

  var body: some View {
    VStack(spacing: 20) {
      Text("Hello SwiftUI!")

      Button(action: {
        callManager.reportIncomingCall(uuid: UUID(), handle: "John Doe")
      }) {
        Text("Trigger Fake Call")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
    }
    .padding()
  }
}

