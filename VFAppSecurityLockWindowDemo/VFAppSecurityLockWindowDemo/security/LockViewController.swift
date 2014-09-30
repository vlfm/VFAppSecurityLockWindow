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
    
    @IBAction func alertViewButtonTap(sender: AnyObject) {
        var alertView = UIAlertView(title: "UIAlertView", message: nil, delegate: nil, cancelButtonTitle: "Close")
        alertView.show()
    }
    
    deinit {
        NSLog("LockViewController deinit")
    }
}