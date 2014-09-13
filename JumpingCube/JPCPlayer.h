//
//  JPCPlayer.h
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//
//
#import "JPCCube.h"
@interface JPCPlayer : NSObject
@property (nonatomic, strong) UIColor *playerColor;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) BOOL AI;
@end
