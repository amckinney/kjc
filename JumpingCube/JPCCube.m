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
        _cubeScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _cubeScoreLabel.userInteractionEnabled = NO;
        [self addChild:_cubeScoreLabel];
    }
    return self;
}

-(void)cubeActionWithPlayer:(JPCPlayer *)player {
    SKAction *scaleAction = [SKAction sequence:@[[SKAction scaleTo:1.25 duration:0.2], [SKAction scaleTo:1.0f duration:0.2]]];;
    [self runAction:scaleAction];
    self.color = player.playerColor;
    self.currentOwner = player;
    self.score++;
}

-(void)setScore:(int)score {
    _score = score;
    self.cubeScoreLabel.text = [NSString stringWithFormat:@"%d", self.score];

}
@end
