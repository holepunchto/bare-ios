import BareKit
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
  private let worklet = Worklet(
    configuration: Worklet.Configuration(memoryLimit: 8 * 1024 * 1024))

  override func didReceive(
    _ request: UNNotificationRequest,
    withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
  ) {
    worklet.start(name: "push", ofType: "bundle")

    let content =
      (request.content.mutableCopy() as? UNMutableNotificationContent)
      ?? UNMutableNotificationContent()

    let payload = try? JSONSerialization.data(withJSONObject: request.content.userInfo)

    Task {
      defer { worklet.terminate() }

      if let payload,
        let reply = try? await worklet.push(data: payload),
        let fields = try? JSONSerialization.jsonObject(with: reply) as? [String: Any]
      {
        if let title = fields["title"] as? String { content.title = title }
        if let body = fields["body"] as? String { content.body = body }
      }

      contentHandler(content)
    }
  }
}
