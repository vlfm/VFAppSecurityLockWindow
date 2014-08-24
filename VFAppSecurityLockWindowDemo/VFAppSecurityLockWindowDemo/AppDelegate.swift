import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    var lockWindow: VFAppSecurityLockWindow = DemoAppSecurityLockWindow()
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        lockWindow.active = true
        return true
    }
}
