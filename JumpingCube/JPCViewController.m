//
//  JPCViewController.m
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JPCViewController.h"
#import "JPCMyScene.h"
@implementation JPCViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    SKView * skView = (SKView *)self.view;
    SKScene * scene = [JPCMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
@end
