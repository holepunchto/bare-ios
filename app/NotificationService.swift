import BareKit

class NotificationService: BareKit.NotificationService {
  override init() {
    super.init(
      resource: "push", ofType: "bundle",
      configuration: Worklet.Configuration(
        memoryLimit: 4 * 1024 * 1024
      ))
  }
}
