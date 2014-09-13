//
//  JPCCube.m
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//
//

#import "JPCCube.h"
@interface JPCCube ()
@property (nonatomic, strong) SKLabelNode *cubeScoreLabel;
@end

@implementation JPCCube
-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size {
    self = [super initWithColor:color size:size];
    if (self) {
        self.color = color;
        self.size = size;
        _score = 0;
        _cubeScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"DIN Alternate"];
        _cubeScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _cubeScoreLabel.fontColor = [UIColor whiteColor];
        [self addChild:_cubeScoreLabel];
    }
    return self;
}

-(void)cubeActionWithPlayer:(JPCPlayer *)player {
    self.color = player.playerColor;
    self.currentOwner = player;
    self.score++;
}
@end
