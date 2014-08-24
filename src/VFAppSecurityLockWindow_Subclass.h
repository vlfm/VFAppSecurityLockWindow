/*
 
 Copyright 2014 Valery Fomenko
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import "VFAppSecurityLockWindow.h"

@interface VFAppSecurityLockWindow ()

#pragma mark dismiss

/**
 * Dismisses VFAppSecurityLockWindow. Not animated.
 *
 * This method can be used by subclass if it manually dismisses lock view controller,
 * that is after any animation is completed.
 */
- (void)dismiss;

#pragma mark methods to override

/**
  * Method is called each time application is going into background.
  * If returns YES, lock view controller will be presented.
  *
  * Default: YES.
*/
- (BOOL)shouldLock;

/**
  * Lock view controller is presented when app is going into background.
  * This view controller's view will appear on app ui snapshot.
  *
  * If nil is returned, nothing will be presented on VFAppSecurityLockWindow
  * Underlying app ui will be on app snapshot.
  *
  * By default returns nil.
*/
- (UIViewController *)lockViewController;

/**
  * By default this method dismisses lock view controller and VFAppSecurityLockWindow itself.
  *
  * This method can be used to customize what happened after app becomes active.
  * For example, lock view controller can be switched to 'unlock state' requesting
  * a password.
  *
  * If overriden, you should dismiss VFAppSecurityLockWindow manually eventually.
*/
- (void)applicationDidBecomeActiveWithLockViewController:(UIViewController *)lockViewController;

/**
  * This method is called when application will resign active while
  * VFAppSecurityLockWindow is presented.
  *
  * This is a place, for example, to reset some lock view controller state:
  * incompleted password input, etc.
*/
- (void)applicationWillResignActiveWithLockViewController:(UIViewController *)lockViewController;

/**
  * Override this method for any cleanup: release properties, etc
  * It is more explicit to do it here than override 'dismiss' method.
*/
- (void)didDismiss;

@end
