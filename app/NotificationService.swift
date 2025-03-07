import BareKit

class NotificationService: BareKit.NotificationService {
  override init() {
    super.init(resource: "push", ofType: "bundle")
  }
}
