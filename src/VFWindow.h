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

@import UIKit;

@interface VFWindow : NSObject

typedef void(^VFWindowCompletionBlock)();
typedef void(^VFWindowDisMissBlock)(VFWindow*, VFWindowCompletionBlock);

@property (nonatomic, strong) UIViewController *rootViewController;

@property(nonatomic) CGFloat level;
@property(nonatomic, readonly, getter=isKeyWindow) BOOL keyWindow;

/**
  * Adds window without root view controller.
*/
+ (VFWindow *)addWindow;

/**
  * Specify root view controller for a window.
*/
+ (VFWindow *)addWindowWithRootViewController:(UIViewController *)viewController;

/**
  * Dismiss block allows for some custom code before actual dismiss.
  * If dismiss block is provided, it must call completion block at the end.
*/
+ (void)dismissWindow:(VFWindow *)window dismissBlock:(VFWindowDisMissBlock)dismissBlock;

@end