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

@implementation VFAppSecurityLockWindow {
    VFWindow *_window;
}

- (instancetype)init {
    self = [super init];
    _level = UIWindowLevelAlert + 1;
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
        
    } else if ([self isLockViewControllerPresentedInKeyWindow]) {
        [self applicationWillResignActiveWithLockViewController:_window.rootViewController];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)n {
    if (_window.rootViewController == nil && [self shouldLock]) {
        _window.rootViewController = [self lockViewController];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)n {
    if ([self isLockViewControllerPresentedInKeyWindow]) {
        [self applicationDidBecomeActiveWithLockViewController:_window.rootViewController];
    } else {
        [self dismiss];
    }
}

#pragma mark check

- (BOOL)isLockViewControllerPresentedInKeyWindow {
    return _window && _window.keyWindow && _window.rootViewController;
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
