import CallKit
import PushKit

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
    print("🔔 VoIP token: \(voipToken)")
  }

  func pushRegistry(
    _ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType, completion: @escaping () -> Void
  ) {
    print("🔔 Received incoming call \(payload.dictionaryPayload)")

    let caller = payload.dictionaryPayload["caller"] as? String ?? "Unknown"

    callManager?.reportIncomingCall(uuid: UUID(), handle: caller)
    completion()
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
        print("Error reporting incoming call: \(error.localizedDescription)")
      }
    }
  }

  func providerDidReset(_ provider: CXProvider) {}

  func provider(
    _ provider: CXProvider,
    perform action: CXAnswerCallAction
  ) {
    print("Call answered")
    action.fulfill()
  }

  func provider(
    _ provider: CXProvider,
    perform action: CXEndCallAction
  ) {
    print("Call ended")
    action.fulfill()
  }

}
