//
//  JPCMyScene.m
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JPCMyScene.h"
#import "JPCCube.h"
@interface JPCMyScene ()
@property (nonatomic, strong) SKNode *cubeLayer;
@property (nonatomic, strong) NSMutableArray *cubes;
@end

@implementation JPCMyScene
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        _cubeLayer = [[SKNode alloc] init];
        [self addChild:_cubeLayer];
    }
    return self;
}

-(void)newGame {
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        JPCCube *cube = [[JPCCube alloc] initWithColor:[UIColor whiteColor] size:CGSizeMake(50, 50)];
        cube.position = location;
        [self.cubeLayer addChild:cube];
    }
}

-(void)update:(CFTimeInterval)currentTime {
}
@end
