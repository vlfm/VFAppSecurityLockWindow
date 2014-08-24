import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var textFieldLeading: NSLayoutConstraint!
    @IBOutlet var textFieldTrailing: NSLayoutConstraint!
    @IBOutlet var textFieldWidth: NSLayoutConstraint!
    
    @IBOutlet var button1Leading: NSLayoutConstraint!
    @IBOutlet var button1Trailing: NSLayoutConstraint!
    @IBOutlet var button1Width: NSLayoutConstraint!
    
    @IBOutlet var button2Leading: NSLayoutConstraint!
    @IBOutlet var button2Trailing: NSLayoutConstraint!
    @IBOutlet var button2Width: NSLayoutConstraint!
    
    @IBOutlet var bottomVerticalSpace: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        textFieldWidth.constant = view.bounds.width - (textFieldLeading.constant + textFieldTrailing.constant)
        button1Width.constant = view.bounds.width - (button1Leading.constant + button1Trailing.constant)
        button2Width.constant = view.bounds.width - (button2Leading.constant + button2Trailing.constant)
        
        bottomVerticalSpace.constant = 0
    }
    
    @IBAction func alertViewButtonTap(sender: AnyObject) {
        var alertView = UIAlertView(title: "UIAlertView", message: nil, delegate: nil, cancelButtonTitle: "Close")
        alertView.show()
    }
    
    @IBAction func actionSheetButtonTap(sender: AnyObject) {
        var actionSheet = UIActionSheet(title: "UIActionSheet", delegate: nil, cancelButtonTitle: "Close", destructiveButtonTitle: nil)
        actionSheet.showInView(self.view)
    }
}
