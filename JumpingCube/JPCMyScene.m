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
@property (nonatomic, strong) SKLabelNode *currentPlayerLabel;
@end

@implementation JPCMyScene
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        _cubeLayer = [[SKNode alloc] init];
        [self addChild:_cubeLayer];
        _player1 = [[JPCPlayer alloc] init];
        _player1.playerColor = [UIColor blueColor];
        _player2 = [[JPCPlayer alloc] init];
        _player2.playerColor = [UIColor yellowColor];
        _currentPlayer = _player1;
        _currentPlayerLabel = [[SKLabelNode alloc] initWithFontNamed:@"DIN Alternate"];
        _currentPlayerLabel.position = CGPointMake(160, 400);
        [self addChild:_currentPlayerLabel];
        [self newGame];
    }
    return self;
}

-(void)newGame {
    _currentPlayerLabel.text = @"Player1";
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
        JPCCube *touchedCube = (JPCCube *)[self.cubeLayer nodeAtPoint:location];
        if ([touchedCube respondsToSelector:@selector(currentOwner)]) {
            if (self.currentPlayer == touchedCube.currentOwner || touchedCube.currentOwner == nil) {
                [touchedCube cubeActionWithPlayer:self.currentPlayer];
                [self switchPlayer];
            } else {
            }
        }
    }
}

-(void)switchPlayer {
    if (self.currentPlayer == self.player1) {
        self.currentPlayer = self.player2;
        self.currentPlayerLabel.text = @"Player 2";
    } else {
        self.currentPlayer = self.player1;
        self.currentPlayerLabel.text = @"Player  1";
    }
}
@end
