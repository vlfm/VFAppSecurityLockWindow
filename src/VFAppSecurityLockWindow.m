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

#import "VFAppSecurityLockWindow_Subclass.h"
#import "VFWindow.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation VFAppSecurityLockWindow {
    VFWindow *_window;
    BOOL _firstTimeDidBecomeActive;
}

- (instancetype)init {
    self = [super init];
    _level = UIWindowLevelStatusBar - 1;
    return self;
}

- (void)setLevel:(CGFloat)level {
    _level = level;
    _window.level = level;
}

- (void)setActive:(BOOL)active {
    if (_active == active) {
        return;
    }
    
    _active = active;
    
    if (_active) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)dismiss {
    [VFWindow dismissWindow:_window dismissBlock:nil];
    _window = nil;
    [self didDismiss];
}

- (void)dealloc {
    self.active = NO;
}

#pragma mark notification handlers

- (void)applicationWillResignActive:(NSNotification *)n {
    if (_window == nil) {
        _window = [VFWindow addWindow];
        _window.level = _level;
        _firstTimeDidBecomeActive = YES;
    }
    
    [self applicationWillResignActiveWithLockViewController:_window.rootViewController];
}

- (void)applicationDidEnterBackground:(NSNotification *)n {
    if (_window.rootViewController == nil && [self shouldLock]) {
        _window.rootViewController = [self lockViewController];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)n {
    if ([self isLockViewControllerActuallyLoaded]) {
        [self applicationDidBecomeActiveWithLockViewController:_window.rootViewController];
    } else {
        [self dismiss];
    }
    
    _firstTimeDidBecomeActive = NO;
}

#pragma mark check

/**
  * On iOs < 8 viewcontroller's view may be not loaded actually.
  * It happens if a window is presented when UIAlertView is shown.
  * Note that isViewLoaded may return YES, but viewDidLoad was not called.
*/
- (BOOL)isLockViewControllerActuallyLoaded {
    if (_window.rootViewController == nil) {
        return NO;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return YES;
    }
    
    if (_firstTimeDidBecomeActive && _window.keyWindow == NO) {
        return NO;
    }
    
    return YES;
}

#pragma mark subclass methods

- (BOOL)shouldLock {
    return YES;
}

- (UIViewController *)lockViewController {
    return nil;
}

- (void)applicationDidBecomeActiveWithLockViewController:(UIViewController *)lockViewController {
    [self dismiss];
}

- (void)applicationWillResignActiveWithLockViewController:(UIViewController *)lockViewController {
}

- (void)didDismiss {
}

@end
