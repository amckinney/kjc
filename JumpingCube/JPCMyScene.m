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
#import "SKScene+TouchPriority.h"
@interface JPCMyScene ()
@property (nonatomic, strong) SKNode *cubeLayer;
@property (nonatomic, strong) NSMutableArray *cubes;
@property (nonatomic, weak) JPCPlayer *currentPlayer;
@property (nonatomic, strong) JPCPlayer *player1;
@property (nonatomic, strong) JPCPlayer *player2;
@property (nonatomic, strong) SKLabelNode *currentPlayerLabel;
@property (nonatomic, strong) SKLabelNode *playButton;
@end

@implementation JPCMyScene
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:250/256.0f green:248/256.0f blue:239/256.0f alpha:1.0f];
        _cubeLayer = [[SKNode alloc] init];
        _cubeLayer.name = @"cube layer";
        [self addChild:_cubeLayer];
        _player1 = [[JPCPlayer alloc] init];
        _player1.playerColor = [UIColor colorWithRed:45/256.0f green:99/256.0f blue:127/256.0f alpha:1.0f];
        _player2 = [[JPCPlayer alloc] init];
        _player2.playerColor = [UIColor colorWithRed:224/256.0f green:158/256.0f blue:025/256.0f alpha:1.0f];
        _currentPlayer = _player1;
        _currentPlayerLabel = [[SKLabelNode alloc] initWithFontNamed:@"DIN Alternate"];
        _currentPlayerLabel.fontColor = [UIColor darkGrayColor];
        _currentPlayerLabel.position = CGPointMake(160, 420);
        [self addChild:_currentPlayerLabel];
        
        _playButton = [SKLabelNode labelNodeWithFontNamed:@"DIN Alternate"];
        _playButton.position = CGPointMake(160, 380);
        _playButton.fontColor = [UIColor darkGrayColor];
        _playButton.text = @"Play Game";
        [self addChild:_playButton];
    }
    return self;
}

-(void)newGame {
    _currentPlayerLabel.fontColor = [UIColor colorWithRed:45/256.0f green:99/256.0f blue:127/256.0f alpha:1.0f];
    _currentPlayerLabel.text = @"Blue's Move";
    self.cubes = [[NSMutableArray alloc] initWithCapacity:16];
    for (int i = 0; i< 16; i++) {
        [self.cubes addObject:[[JPCCube alloc] initWithColor:[UIColor darkGrayColor] size:CGSizeMake(70, 70)]];
    }
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            JPCCube *currentCube = self.cubes[4*i+j];
            currentCube.position = CGPointMake(47.5+j*75, 100+i*75);
            currentCube.neighborCount = [self neighbors:currentCube];
            [self.cubeLayer addChild:currentCube];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([self nodeAtPoint:location] == self.playButton) {
            [self newGame];
            self.playButton.hidden = YES;
        }
        JPCCube  *touchedCube = (JPCCube *)[self nodeWithHighestPriority:(NSSet *)touches];
        if ([touchedCube respondsToSelector:@selector(currentOwner)]) {
            if (self.currentPlayer == touchedCube.currentOwner || touchedCube.currentOwner == nil) {
                [self makeMove:touchedCube withPlayer:self.currentPlayer];
                [self switchPlayer];
            }
        }
    }
}

-(void)switchPlayer {
    if (self.currentPlayer == self.player1) {
        self.currentPlayer = self.player2;
        self.currentPlayerLabel.text = @"Gold's Move";
        self.currentPlayerLabel.fontColor = [UIColor colorWithRed:224/256.0f green:158/256.0f blue:025/256.0f alpha:1.0f];
    } else {
        self.currentPlayer = self.player1;
        self.currentPlayerLabel.text = @"Blue's Move";
        self.currentPlayerLabel.fontColor = [UIColor colorWithRed:45/256.0f green:99/256.0f blue:127/256.0f alpha:1.0f];

    }
}

-(void)makeMove:(JPCCube *)cube withPlayer:(JPCPlayer *)player
{
    if ([self.cubes indexOfObject:cube] != NSNotFound) {
        [cube cubeActionWithPlayer:player];
        if (cube.neighborCount < cube.score) {
            [self jump:cube withPlayer:player];
        }
    }
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

-(void)jump:(JPCCube *)cube withPlayer:(JPCPlayer *)player
{
    if (![self winnerExists]) {
        int square = (int)[self.cubes indexOfObject:cube];
        int row = [self rowValue:square];
        int col = [self colValue:square];
        cube.score -= [self neighbors:cube];
        
        NSMutableSet *indexInclusion = [[NSMutableSet alloc] initWithCapacity:16];
        for (int i = 0; i < 16; i++) {
            [indexInclusion addObject:@(i)];
        }
        SKAction *jumpAction = [SKAction sequence:@[[SKAction waitForDuration:0.1], [SKAction runBlock:^(void) {
            int index = [self squareValueAtRow:(row - 1) col:col];
            if ([indexInclusion containsObject:@(index)] && [self validRow:(row-1) col:col]) {
                [self makeMove:[self.cubes objectAtIndex:index] withPlayer:player];
            }
            index = [self squareValueAtRow:(row + 1) col:col];
            if ([indexInclusion containsObject:@(index)] && [self validRow:(row+1) col:col]) {
                [self makeMove:[self.cubes objectAtIndex:index] withPlayer:player];
            }
            index = [self squareValueAtRow:row col:(col - 1)];
            if ([indexInclusion containsObject:@(index)] && [self validRow:row col:(col-1)]) {
                [self makeMove:[self.cubes objectAtIndex:index] withPlayer:player];
                
            }
            index = [self squareValueAtRow:row col:col+1];
            if ([indexInclusion containsObject:@(index)] && [self validRow:row col:(col+1)]) {
                [self makeMove:[self.cubes objectAtIndex:index] withPlayer:player];
            }
        }], [SKAction runBlock:^(void) {
            if ([self winnerExists]) {
                if (self.currentPlayer != self.player1) {
                    self.currentPlayerLabel.text = @"Blue wins!";
                    self.currentPlayerLabel.fontColor = [UIColor colorWithRed:45/256.0f green:99/256.0f blue:127/256.0f alpha:1.0f];
                } else {
                    self.currentPlayerLabel.text = @"Gold wins!";
                    self.currentPlayerLabel.fontColor = [UIColor colorWithRed:224/256.0f green:158/256.0f blue:025/256.0f alpha:1.0f];
                }
                self.playButton.hidden = NO;
            }
        }]]];
        [self runAction:jumpAction];
    }
}

-(BOOL)validRow:(int)row col:(int)col {
    return (row <=  4 && row >= 1 && col <= 4 && col >= 1);
}

-(void)update:(CFTimeInterval)currentTime {
}
@end
