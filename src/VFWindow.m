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

#import "VFWindow.h"

@implementation VFWindow {
    UIWindow *_window;
}

+ (VFWindow *)addWindow {
    return [self addWindowWithRootViewController:nil];
}

+ (VFWindow *)addWindowWithRootViewController:(UIViewController *)viewController {
    VFWindow *window = [[VFWindow alloc] initWithRootViewController:viewController];
    [window makeKeyAndVisible];
    return window;
}

+ (void)dismissWindow:(VFWindow *)window dismissBlock:(VFWindowDisMissBlock)dismissBlock {
    VFWindowCompletionBlock completion = ^{
        if (window) {
            [window removeFromSuperview];
            [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
        }
    };
    
    if (dismissBlock) {
        dismissBlock(window, completion);
    } else {
        completion();
    }
}

- (void)setLevel:(CGFloat)level {
    _level = level;
    _window.windowLevel = level;
}

- (BOOL)isKeyWindow {
    return _window == [UIApplication sharedApplication].keyWindow;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    _rootViewController = rootViewController;
    
    if (_window.keyWindow) {
        _window.rootViewController = _rootViewController;
    }
}

- (instancetype)initWithRootViewController:(UIViewController *)viewController {
    self = [super init];
    
    {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _window.opaque = NO;
    }
    
    {
        self.rootViewController = viewController;
    }
    
    return self;
}

- (void)makeKeyAndVisible {
    _window.rootViewController = self.rootViewController;
    [_window makeKeyAndVisible];
}

- (void)removeFromSuperview {
    [_window removeFromSuperview];
}

@end
