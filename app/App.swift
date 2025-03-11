import BareKit
import SwiftUI
import UserNotifications
import CallKit
import OSLog

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.BareKitExample", category: "App")

@main
struct App: SwiftUI.App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  private var worklet = Worklet()
  private let callManager = CallManager()

  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView(callManager: callManager)
        .onAppear {
          worklet.start(name: "app", ofType: "bundle")

          requestPushNotificationPermission()
            
          DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            callManager.reportIncomingCall(uuid: UUID(), handle: "John Doe")
          }
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

class CallManager: NSObject, CXProviderDelegate {
    private var provider: CXProvider
    
    override init() {
        let conf = CXProviderConfiguration()
        conf.supportsVideo = false
        
        provider = CXProvider(configuration: conf)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    func reportIncomingCall(uuid: UUID, handle: String) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        update.hasVideo = false

        provider.reportNewIncomingCall(with: uuid, update: update) { error in
          if let error = error {
              logger.error("Error reporting incoming call: \(error.localizedDescription)")
          }
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(
      _ provider: CXProvider,
      perform action: CXAnswerCallAction
    ) {
      logger.debug("Call answered")
      action.fulfill()
    }

    func provider(
      _ provider: CXProvider,
      perform action: CXEndCallAction
    ) {
      logger.debug("Call ended")
      action.fulfill()
    }
        
}
