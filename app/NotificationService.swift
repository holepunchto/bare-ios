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
    if let type = reply["type"] as? String {
      switch type {
      case "call":
        print("Received call push")
        let caller = reply["caller"] as? String ?? "Anonymous"

        CXProvider.reportNewIncomingVoIPPushPayload(["caller": caller]) { error in
          if let error = error {
            print("\(error)")
          }
        }
        return UNNotificationContent()  // Silence the notification

      case "notif":
        print("Received notification push")
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = reply["title"] as? String ?? "Hello!"
        notificationContent.body = reply["body"] as? String ?? "World!"
        return notificationContent

      default:
        return UNNotificationContent()
      }
    }
    return UNNotificationContent()
  }
}
