import SwiftUI

@main
struct App: SwiftUI.App {
  @StateObject private var worklet = Worklet()
  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          worklet.start()
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

class Worklet: ObservableObject {
  private var worklet: BareWorklet?

  func start() {
    guard let url = Bundle.main.url(forResource: "app", withExtension: "bundle") else {
      return
    }

    worklet = BareWorklet(configuration: nil)

    worklet?.start(url.path, source: nil, arguments: nil)
  }

  func suspend() {
    worklet?.suspend()
  }

  func resume() {
    worklet?.resume()
  }

  func terminate() {
    worklet?.terminate()
  }
}
