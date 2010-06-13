//
//  cocos2d_basic_with_uivcAppDelegate.h
//  cocos2d-basic-with-uivc
//
//  Created by Chris Kimpton on 13/06/2010.
//  Copyright Kimptoc Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cocos2dHolderViewController;

@interface cocos2d_basic_with_uivcAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	Cocos2dHolderViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
