import SwiftUI
import BareKit

@main
struct App: SwiftUI.App {
  private var worklet = Worklet()!

  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          worklet.start(name: "app", ofType: "bundle")
        }
        .onDisappear {
          worklet.terminate()
        }
    }
    .onChange(of: scenePhase) { phase in
      switch phase {
      case .background:
        worklet.suspend()
      case .active:
        worklet.resume()
      default:
        break
      }
    }
  }
}

struct ContentView: View {
  var body: some View {
    Text("Hello SwiftUI!")
  }
}
