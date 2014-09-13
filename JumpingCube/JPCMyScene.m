//
//  JPCMyScene.m
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JPCMyScene.h"
#import "JPCCube.h"
#import "JPCPlayer.h"
@interface JPCMyScene ()
@property (nonatomic, strong) SKNode *cubeLayer;
@property (nonatomic, strong) NSMutableArray *cubes;
@property (nonatomic, weak) JPCPlayer *currentPlayer;
@property (nonatomic, strong) JPCPlayer *player1;
@property (nonatomic, strong) JPCPlayer *player2;
@end

@implementation JPCMyScene
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        _cubeLayer = [[SKNode alloc] init];
        [self addChild:_cubeLayer];
        
        [self newGame];
    }
    return self;
}

-(void)newGame {
    self.cubes = [[NSMutableArray alloc] initWithCapacity:16];
    for (int i = 0; i< 16; i++) {
        [self.cubes addObject:[[JPCCube alloc] initWithColor:[UIColor whiteColor] size:CGSizeMake(60, 60)]];
    }
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            JPCCube *currentCube = self.cubes[4*i+j];
            currentCube.position = CGPointMake(60+ j*65, 120+i*65);
            [self.cubeLayer addChild:currentCube];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        JPCCube *touchedCube = [self.cubeLayer nodeAtPoint:location];
        if (self.currentPlayer == touchedCube.currentOwner || touchedCube.currentOwner == nil) {
            [touchedCube cubeAction];
            [self switchPlayer];
        }
    }
}

-(void)switchPlayer {
    
}

-(void)update:(CFTimeInterval)currentTime {
}
@end
