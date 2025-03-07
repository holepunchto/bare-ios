import BareKit

class MyNotificationService: NotificationService {
    override init() {
        let configuration = Worklet.Configuration()
        super.init(resource: "push", ofType: "js", arguments: [], configuration: configuration)
    }
}
