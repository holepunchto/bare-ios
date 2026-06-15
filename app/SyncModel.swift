import BareKit
import Foundation
import HRPC
import Schema
import SwiftUI

// The view model. It owns the Bare worklet (the P2P backend on its own thread)
// and talks to it through the generated, typed hrpc interface. Every @Published
// property here is driven by an event from the worklet.
@MainActor
final class SyncModel: ObservableObject {
  @Published var on = false
  @Published var peers = 0
  @Published var publicKey = "..."
  @Published var topic = "..."

  private let worklet = Worklet()
  private var transport: BareTransport?
  private var rpc: HRPC?

  init() {
    start()
  }

  func start() {
    worklet.start(name: "app", ofType: "bundle")

    let ipc = IPC(worklet: worklet)
    let transport = BareTransport(ipc: ipc)
    let rpc = HRPC(delegate: transport)
    self.transport = transport
    self.rpc = rpc

    rpc.onNewState { [weak self] state in
      guard let state else { return }
      await MainActor.run { self?.on = state.on }
    }
    rpc.onPeersChanged { [weak self] peers in
      guard let peers else { return }
      await MainActor.run { self?.peers = Int(peers.count) }
    }
    rpc.onInfo { [weak self] info in
      guard let info else { return }
      await MainActor.run {
        self?.publicKey = info.publicKey
        self?.topic = info.topic
      }
    }

    transport.readLoop(into: rpc)
  }

  // UI -> worklet request. Update optimistically, then reconcile with the
  // authoritative state the worklet returns after broadcasting to peers.
  func setOn(_ value: Bool) {
    on = value
    Task { [weak self] in
      guard let rpc = self?.rpc else { return }
      if let result = try? await rpc.setState(SwitchState(on: value)) {
        await MainActor.run { self?.on = result.on }
      }
    }
  }

  func suspend() { worklet.suspend() }
  func resume() { worklet.resume() }
}
