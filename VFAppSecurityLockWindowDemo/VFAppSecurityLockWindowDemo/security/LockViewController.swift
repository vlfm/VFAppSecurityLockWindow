import UIKit

@objc class LockViewController: UIViewController {

    typealias LockViewControllerAction = (sender: LockViewController) -> ()
    var unlockAction: LockViewControllerAction?
    
    @IBOutlet var passcodeTextField: UITextField!
    @IBOutlet var unlockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lock"
        setUnlockUiVisible(false)
    }
    
    func setUnlockUiVisible(isVisible: Bool) {
        passcodeTextField.hidden = !isVisible
        unlockButton.hidden = !isVisible
    }
    
    @IBAction func unlockButtonTap(sender: AnyObject) {
        unlockAction?(sender: self)
    }
    
    deinit {
        NSLog("LockViewController deinit")
    }
}