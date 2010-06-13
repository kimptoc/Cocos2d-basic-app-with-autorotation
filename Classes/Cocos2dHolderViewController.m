    //
//  Cocos2dHolderViewController.m
//  cocos2d-basic-with-uivc
//
//  Created by Chris Kimpton on 13/06/2010.
//  Copyright 2010 Kimptoc Ltd. All rights reserved.
//

#import "Cocos2dHolderViewController.h"

#import "CCDirector.h"

@implementation Cocos2dHolderViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
										 duration:(NSTimeInterval)duration
{
	NSLog(@"willAnimateRotationToInterfaceOrientation h:%f, w:%f",self.view.frame.size.height,self.view.frame.size.width);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
								duration:(NSTimeInterval)duration
{
	NSLog(@"willRotateToInterfaceOrientation h:%f, w:%f",self.view.frame.size.height,self.view.frame.size.width);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@"didRotateFromInterfaceOrientation h:%f, w:%f",self.view.frame.size.height,self.view.frame.size.width);
	UIInterfaceOrientation newOrientation = self.interfaceOrientation;
	[[CCDirector sharedDirector] setDeviceOrientation:newOrientation];
	[[CCDirector sharedDirector] applyLandscape];
	if (_helloWorld)
	{
		[_helloWorld didAutoRotate];
	}
}

-(void) registerHelloWorldLayer: (HelloWorld*) hw;
{
	_helloWorld = hw;
	[_helloWorld retain];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_helloWorld release];

    [super dealloc];
}


@end
