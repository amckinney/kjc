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
-(void)cubeActionWithPlayer:(JPCPlayer *)player;
@end
