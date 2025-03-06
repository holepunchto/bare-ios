import BareKitBridge

public class NotificationService: BareNotificationService {
    required override init(configuration: BareWorkletConfiguration?) {
        super.init(configuration: configuration)!
    }

    override init() {
        super.init(resource: "push", ofType: "js", arguments: nil, configuration: BareWorkletConfiguration.default())!
    }
}

