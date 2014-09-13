//
//  JPCCube.h
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//
//

#import "JPCPlayer.h"
@interface JPCCube : SKSpriteNode
@property (nonatomic, weak) JPCPlayer *currentOwner;
@property (nonatomic, assign) int neighborCount;
@property (nonatomic, assign) int score;
-(void)cubeActionWithPlayer:(JPCPlayer *)player;
@end
