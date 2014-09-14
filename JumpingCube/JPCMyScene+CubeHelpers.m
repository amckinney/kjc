//
//  JPCMyScene+CubeHelpers.m
//  JumpingCube
//
//  Created by Maneesh Goel and Alex Mckinney on 9/14/14.
//
//

#import "JPCMyScene+CubeHelpers.h"
@implementation JPCMyScene (CubeHelpers)
-(BOOL)validRow:(int)row col:(int)col {
    return (row <=  4 && row >= 1 && col <= 4 && col >= 1);
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

-(int)squareValueAtRow:(int)row col:(int)col {
    return ((4 * (row - 1)) + (col - 1));
}

-(int)rowValue:(int)square {
    return (1 + square / 4);
}

-(int)colValue:(int)square {
    return (1 + square % 4);
}

-(int)neighbors:(JPCCube *)cube {
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
@end
