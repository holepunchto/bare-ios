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

  override func workletDidReply(_ reply: [AnyHashable: Any]) -> UNNotificationContent {
    switch reply["type"] as? String {
    case "notification":
      return super.workletDidReply(reply)

    case "call":
      let caller = reply["caller"] as! String

      Task.init {
        try await VoIP.reportNewIncomingCall(caller: caller)
      }

      fallthrough

    default:
      return UNNotificationContent()
    }
  }
}
