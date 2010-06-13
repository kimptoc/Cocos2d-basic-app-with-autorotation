//
//  main.m
//  cocos2d-basic-with-uivc
//
//  Created by Chris Kimpton on 13/06/2010.
//  Copyright Kimptoc Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	int retVal = UIApplicationMain(argc, argv, nil, @"cocos2d_basic_with_uivcAppDelegate");
	[pool release];
	return retVal;
}
