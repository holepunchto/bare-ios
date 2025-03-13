import CallKit
import PushKit

class VoIP: NSObject, CXProviderDelegate, PKPushRegistryDelegate {
  private let provider: CXProvider
  private let registry: PKPushRegistry

  override init() {
    let configuration = CXProviderConfiguration()
    configuration.supportsVideo = false

    provider = CXProvider(configuration: configuration)
    registry = PKPushRegistry(queue: .main)

    super.init()

    provider.setDelegate(self, queue: nil)

    registry.delegate = self
    registry.desiredPushTypes = [.voIP]
  }

  func providerDidReset(_ provider: CXProvider) {}

  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    action.fulfill()
  }

  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    action.fulfill()
  }

  func pushRegistry(
    _ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType
  ) {
    print("VoIP token: \(credentials.token.map { String(format: "%02x", $0) }.joined())")
  }

  func pushRegistry(
    _ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType, completion: @escaping () -> Void
  ) {
    let caller = payload.dictionaryPayload["caller"] as! String

    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .generic, value: caller)
    update.hasVideo = false

    provider.reportNewIncomingCall(with: UUID(), update: update) { error in
      if let error = error {
        print("\(error.localizedDescription)")
      }
    }

    completion()
  }
}
