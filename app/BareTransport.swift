import BareKit
import BareRPC
import Foundation
import HRPC

// Bridges the generated hrpc engine to the worklet's IPC byte stream.
//
// `bare-rpc` is transport-agnostic: it hands us frames to send via the delegate
// method, and we feed it inbound frames via `hrpc.receive`. It does its own
// length-framing, so there is no hand-rolled byte parsing here - the whole
// reason to use hrpc over raw IPC.
final class BareTransport: RPCDelegate {
  private let ipc: IPC

  init(ipc: IPC) {
    self.ipc = ipc
  }

  // RPC -> peer: write outbound frames to the worklet.
  func rpc(_ rpc: RPC, send data: Data) {
    Task { try? await ipc.write(data: data) }
  }

  // peer -> RPC: pump inbound frames from the worklet into the engine.
  func readLoop(into hrpc: HRPC) {
    Task {
      do {
        for try await chunk in ipc {
          await hrpc.receive(chunk)
        }
      } catch {
        // Stream closed; nothing to do.
      }
    }
  }
}
