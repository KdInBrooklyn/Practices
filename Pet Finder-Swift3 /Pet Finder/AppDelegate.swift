
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private let solar = Solar(latitude: 40.758899, longitude: -73.9873197)!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
//    Theme.current.apply()
    initializeTheme()
    
    return true
  }
  
  fileprivate func initializeTheme() {
    if solar.isDaytime {
      Theme.current.apply()
      scheduleThemeTimer()
    } else {
      Theme.dark.apply()
    }
    
  }
  
  fileprivate func scheduleThemeTimer() {
    let timer = Timer(fire: solar.sunset!, interval: 0.0, repeats: false) { [weak self] _ in
      Theme.dark.apply()
      
      self?.window?.subviews.forEach({ (view: UIView) in
        view.removeFromSuperview()
        self?.window?.addSubview(view)
      })
    }
    
    RunLoop.main.add(timer, forMode: .commonModes)
  }
}
