//
//  Cocos2dHolderViewController.h
//  cocos2d-basic-with-uivc
//
//  Created by Chris Kimpton on 13/06/2010.
//  Copyright 2010 Kimptoc Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloWorldScene.h"

@interface Cocos2dHolderViewController : UIViewController {
	HelloWorld* _helloWorld;
}

-(void) registerHelloWorldLayer: (HelloWorld*) hw;
@end
