import BareKit
import CallKit
import OSLog
import PushKit
import SwiftUI
import UserNotifications

let logger = Logger(
  subsystem: Bundle.main.bundleIdentifier ?? "com.example.BareKitExample", category: "App")

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

class PushKitRegistryDelegate: NSObject, PKPushRegistryDelegate {
  private var pushRegistry: PKPushRegistry!
  private var callManager: CallManager?

  override init() {
    super.init()
    self.pushRegistry = PKPushRegistry(queue: .main)
    self.pushRegistry.delegate = self
    self.pushRegistry.desiredPushTypes = [.voIP]
  }

  func setCallManager(_ callManager: CallManager?) {
    self.callManager = callManager
  }

  func pushRegistry(
    _ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType
  ) {
    let voipToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
    logger.debug("✅ VoIP Token: \(voipToken)")
  }

  func pushRegistry(
    _ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType, completion: @escaping () -> Void
  ) {
    logger.debug("🔔 Received incoming call \(payload.dictionaryPayload)")

    let caller = payload.dictionaryPayload["caller"] as? String ?? "Unknown"

    callManager?.reportIncomingCall(uuid: UUID(), handle: caller)
    completion()
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
