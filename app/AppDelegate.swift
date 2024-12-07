import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var worklet: BareWorklet?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    guard let url = Bundle.main.url(forResource: "app", withExtension: "bundle") else {
      return false
    }

    worklet = BareWorklet(configuration: nil)

    worklet?.start(url.path, source: nil, arguments: nil)

    return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    worklet?.suspend()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    worklet?.resume()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    worklet?.terminate()
  }
}
