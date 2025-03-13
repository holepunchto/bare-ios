import BareKit
import CallKit
import UserNotifications

class NotificationService: BareKit.NotificationService, BareKit.NotificationServiceDelegate {
  override init() {
    super.init(
      resource: "push", ofType: "bundle",
      configuration: Worklet.Configuration(
        memoryLimit: 8 * 1024 * 1024
      ))

    delegate = self
  }

  func workletDidReply(_ reply: [AnyHashable: Any]) -> UNNotificationContent {
    let content = UNMutableNotificationContent()

    switch reply["type"] as? String {
    case "call":
      print("Received call push")

      let caller = reply["caller"] as? String ?? "Anonymous"

      CXProvider.reportNewIncomingVoIPPushPayload(["caller": caller]) { error in
        if let error = error {
          print("\(error.localizedDescription)")
        }
      }

      break

    case "notification":
      print("Received notification push")

      content.title = reply["title"] as? String ?? "Hello!"
      content.body = reply["body"] as? String ?? "World!"

      break

    default:
      break
    }

    return content
  }
}
