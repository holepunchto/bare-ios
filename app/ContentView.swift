import SwiftUI

struct ContentView: View {
  @ObservedObject var model: SyncModel

  var body: some View {
    VStack(spacing: 20) {
      Text("Bare <-> iOS")
        .font(.headline)

      Toggle(
        "Shared switch",
        isOn: Binding(get: { model.on }, set: { model.setOn($0) })
      )
      .font(.title3)

      Divider()

      Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
        GridRow {
          Text("Peers connected").foregroundColor(.secondary)
          Text("\(model.peers)").monospacedDigit()
        }
        GridRow {
          Text("Your key").foregroundColor(.secondary)
          Text(model.publicKey).font(.system(.callout, design: .monospaced))
        }
        GridRow {
          Text("Topic").foregroundColor(.secondary)
          Text(model.topic).font(.system(.callout, design: .monospaced))
        }
      }
      .font(.callout)

      Text(
        "Launch this app on another device - flip the switch on one and watch the other follow. No server in between."
      )
      .font(.caption)
      .foregroundColor(.secondary)
      .multilineTextAlignment(.center)
      .fixedSize(horizontal: false, vertical: true)
    }
    .padding(24)
  }
}
