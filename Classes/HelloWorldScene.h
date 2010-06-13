//
//  HelloWorldLayer.h
//  cocos2d-basic-with-uivc
//
//  Created by Chris Kimpton on 13/06/2010.
//  Copyright Kimptoc Ltd 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#define HELLO_WORLD_TAG 999

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	CCLabel* _label;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

- (void) didAutoRotate;


@end
