//
//  JPCMyScene+CubeHelpers.h
//  JumpingCube
//
//  Created by Maneesh Goel on 9/14/14.
//
//

#import "JPCMyScene.h"
#import "JPCCube.h"
#import "JPCPlayer.h"
@interface JPCMyScene (CubeHelpers)
-(int)squareValueAtRow:(int)row col:(int)col;
-(int)rowValue:(int)square;
-(int)colValue:(int)square;
-(int)neighbors:(JPCCube *)cube;
-(BOOL)winnerExists;
-(BOOL)validRow:(int)row col:(int)col;
@end
