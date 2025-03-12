import BareKit
import CallKit
import OSLog
import UserNotifications

let logger = Logger(
  subsystem: Bundle.main.bundleIdentifier ?? "to.holepunch.bare.ios.NotificationServiceExtension",
  category: "NotificationServiceExtension")

class NotificationServiceDelegate: BareKit.NotificationServiceDelegate {
  func workletDidReply(_ reply: [AnyHashable: Any]) -> UNNotificationContent {
    if let type = reply["type"] as? String {
      switch type {
      case "call":
        logger.debug("Received call push")
        let caller = reply["caller"] as? String ?? "Anonymous"
        CXProvider.reportNewIncomingVoIPPushPayload(["caller": caller]) { error in
          if let error = error {
            logger.error("CXProvider.reportNewIncomingVoIPPushPayload: \(error)")
          }
        }
        return UNMutableNotificationContent()  // Silence the notification

      case "notif":
        logger.debug("Received notification push")
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = reply["title"] as? String ?? "Hello!"
        notificationContent.body = reply["body"] as? String ?? "World!"
        return notificationContent

      default:
        return UNMutableNotificationContent()
      }
    }
    return UNMutableNotificationContent()
  }
}

class NotificationService: BareKit.NotificationService {
  override init() {
    super.init(
      resource: "push", ofType: "bundle",
      configuration: Worklet.Configuration(
        memoryLimit: 8 * 1024 * 1024
      ))
    self.delegate = NotificationServiceDelegate()
  }
}
