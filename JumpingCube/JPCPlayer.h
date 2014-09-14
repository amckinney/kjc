//
//  JPCPlayer.h
//  JumpingCube
//
//  Created by Maneesh Goel and Alex McKinney on 9/13/14.
//
//
@interface JPCPlayer : NSObject
@property (nonatomic, strong) UIColor *playerColor;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) BOOL AI;
@property (nonatomic, weak) JPCPlayer *opponentForAI;
- (int)minmax:(NSMutableArray *)cubes player:(JPCPlayer *)player depth:(int)depth;
@end
