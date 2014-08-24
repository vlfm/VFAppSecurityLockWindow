#import "DemoAppSecurityLockWindow.h"
#import "VFAppSecurityLockWindow_Subclass.h"

#import "VFAppSecurityLockWindowDemo-Swift.h"

@implementation DemoAppSecurityLockWindow {
    LockViewController *_lockViewController;
}

- (UIViewController *)lockViewController {
    // store in a variable because it is contained in navigation controller
    _lockViewController = [[LockViewController alloc] initWithNibName:@"LockViewController" bundle:nil];
    
    __weak VFAppSecurityLockWindow *wSelf = self;
    _lockViewController.unlockAction = ^ (LockViewController *sender) {
        VFAppSecurityLockWindow *sSelf = wSelf;
        [sSelf dismiss];
    };
    
    return [[UINavigationController alloc] initWithRootViewController:_lockViewController];
}

/**
  * Comment this method for default dissmisal
*/
- (void)applicationDidBecomeActiveWithLockViewController:(UIViewController *)lockViewController {
    [_lockViewController setUnlockUiVisible:YES];
}

- (void)applicationWillResignActiveWithLockViewController:(UIViewController *)lockViewController {
    [_lockViewController setUnlockUiVisible:NO];
}

/**
  * Release lock view controller var
*/
- (void)didDismiss {
    _lockViewController = nil;
}

@end