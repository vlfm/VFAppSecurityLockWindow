VFAppSecurityLockWindow
=======================
Utility that helps create a lock screen for an application.

Purpose
=

* Provide a kind of splash screen to hide any sensitive information.

> Remove sensitive information from views before moving to the background. When an application transitions to the background, the system takes a snapshot of the application’s main window, which it then presents briefly when transitioning your application back to the foreground. Before returning from your applicationDidEnterBackground: method, you should hide or obscure passwords and other sensitive personal information that might be captured as part of the snapshot.

https://developer.apple.com/library/iOS/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/ManagingYourApplicationsFlow/ManagingYourApplicationsFlow.html#//apple_ref/doc/uid/TP40007072-CH4-SW47

* Provide password protection each time app becomes active

You provide an arbitrary```UIViewController```object to be automatically presented on top of the application and act as a lock screen.

Usage
=

Library is designed to use a subclassing model.
There is a base abstract class```VFAppSecurityLockWindow```you need to subclass.
In your subclass override a set of template methods to provide required functionality.

Create subclass step by step
=
* If in some cases locking should be disabled, override this method. Return YES or NO based on some context.
```objective-c
/**
* Method is called each time application is going into background.
* If returns YES, lock view controller will be presented.
*
* Default: YES.
*/
- (BOOL)shouldLock {
    return YES;
}
```

* Return your lock view controller
```objective-c
/**
* Lock view controller is presented when app is going into background.
* This view controller's view will appear on app ui snapshot.
*
* If nil is returned, nothing will be presented on VFAppSecurityLockWindow
* Underlying app ui will be on app snapshot.
*
* By default returns nil.
*/
- (UIViewController *)lockViewController {
    return [MyLockViewController new];
}
```

* Be notified when app goes into foreground with lock viewcontroller presented.
```objective-c
/**
* By default this method dismisses lock view controller and VFAppSecurityLockWindow itself.
*
* This method can be used to customize what happened after app becomes active.
* For example, lock view controller can be switched to 'unlock state' requesting
* a password.
*
* If overriden, you should dismiss VFAppSecurityLockWindow manually eventually.
*/
- (void)applicationDidBecomeActiveWithLockViewController:(UIViewController *)lockViewController {
    MyLockViewController *vc = (MyLockViewController *)lockViewController;
    [vc askPassword];
    // or present another view controller on top, etc
}
```

* Be notified when app will resign active with lock viewcontroller presented.
```objective-c
/**
* This method is called when application will resign active while
* VFAppSecurityLockWindow is presented.
*
* This is a place, for example, to reset some lock view controller state:
* incompleted password input, etc.
*/
- (void)applicationWillResignActiveWithLockViewController:(UIViewController *)lockViewController {
    MyLockViewController *vc = (MyLockViewController *)lockViewController;
    [vc hidePasswordUIAndClearUserInput];
}
```

* If you hold reference to lock view controller, for example, than you have a convenient place where to release it
```objective-c
/**
* Override this method for any cleanup: release properties, etc
* It is more explicit to do it here than override 'dismiss' method.
*/
- (void)didDismiss {
    _lockViewController = nil; // allow to be deallocated
}
```

That is all that is needed to create a lock screen for an application. Final step is just create and activate it.

Activate
=

Final step is to create and activate you subclass instance.
```swift
// AppDelegate property
var lockWindow: VFAppSecurityLockWindow = DemoAppSecurityLockWindow()

// Activate
func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
    lockWindow.active = true
    return true
}
```

! Note about UIAlertViews
=

Be careful with```UIAlertViews```. On iOs7 they prevent a```UIWindow```to be put on top of them. The```UIWindow```is not only prevented to become a key window. It turns out a view of window's rootViewController is not beign loaded at all.

So now, if```UIAlertView```is presented, ```VFAppSecurityLockWindow```will NOT show your lock viewcontroller.
It is application's responsibility to dismiss```UIAlertView```when app did enter background.

Note also, that the library is not trying to do any tricky checks or use any private api to find out if```UIAlertView```is presented. It keeps things easy and just try to make its```UIWindow```a key window and see if it succeeds. If not, and in case of```UIAlertView```it doesn't, then```UIWindow```and lock view controller are not presented.

For some problems with alert views, see, for example, this discussion https://github.com/rolandleth/LTHPasscodeViewController/issues/16

On iOs8 there seem to be no such a problem.

Demo
=

See demo app for example```VFAppSecurityLockWindow```subclass.
