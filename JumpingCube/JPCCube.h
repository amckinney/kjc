//
//  JPCCube.h
//  JumpingCube
//
//  Created by Maneesh Goel and Alex McKinney on 9/13/14.
//
//

#import "JPCPlayer.h"
@interface JPCCube : SKSpriteNode
@property (nonatomic, weak) JPCPlayer *currentOwner;
@property (nonatomic, assign) int neighborCount;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int indexInArray;
-(void)cubeActionWithPlayer:(JPCPlayer *)player;
@end
