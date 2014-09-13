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
            currentCube.neighborCount = [self neighbors:currentCube];
            [self.cubeLayer addChild:currentCube];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        JPCCube *touchedCube = (JPCCube *)[self.cubeLayer nodeAtPoint:location];
        if (self.currentPlayer == touchedCube.currentOwner || touchedCube.currentOwner == nil) {
            [touchedCube cubeActionWithPlayer:self.currentPlayer];
            [self switchPlayer];
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

-(void)makeMove:(JPCCube *)cube withPlayer:(JPCPlayer *)player
{
    if ([self cubeExists:cube]) {
        [cube cubeActionWithPlayer:player];
        if (cube.neighborCount > cube.score) {
            [self jump:cube];
        }
    }
}

-(BOOL)cubeExists:(JPCCube *)cube
{
    // TODO:
    return YES;
}

-(int)squareValueAtRow:(int)row col:(int)col
{
    return ((4 * (row - 1)) + (col - 1));
}

-(int)rowValue:(int)square
{
    return (1 + square / 4);
}

-(int)colValue:(int)square
{
    return (1 + square % 4);
}

-(int)neighbors:(JPCCube *)cube
{
    int square = (int)[self.cubes indexOfObject:cube];
    int row = [self rowValue:square];
    int col = [self colValue:square];
    
    if ((row == 1 || row == 4) && (col == 1 || col == 4)) {
        return 2;
    } else if ((row == 1 || row == 4) || (col == 1 || col == 4)) {
        return 3;
    } else {
        return 4;
    }
}

-(BOOL)winnerExists
{
    JPCPlayer *currentPlayer = (JPCPlayer *)[[self.cubes objectAtIndex:0] currentOwner];
    for(JPCCube *currentCube in self.cubes) {
        if (currentCube.currentOwner != currentPlayer) {
            return NO;
        }
    }
    return YES;
}

-(void)jump:(JPCCube *)cube
{
    if (![self winnerExists]) {
        int square = (int)[self.cubes indexOfObject:cube];
        int row = [self rowValue:square];
        int col = [self colValue:square];
        cube.score -= [self neighbors:cube];
        
        [self makeMove:[self.cubes objectAtIndex:[self squareValueAtRow:(row - 1) col:col]] withPlayer:self.currentPlayer];
        [self makeMove:[self.cubes objectAtIndex:[self squareValueAtRow:(row + 1) col:col]] withPlayer:self.currentPlayer];
        [self makeMove:[self.cubes objectAtIndex:[self squareValueAtRow:row col:(col - 1)]] withPlayer:self.currentPlayer];
        [self makeMove:[self.cubes objectAtIndex:[self squareValueAtRow:row col:(col + 1)]] withPlayer:self.currentPlayer];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
}
@end
