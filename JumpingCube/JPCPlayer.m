//
//  JPCPlayer.m
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//
//

#import "JPCPlayer.h"
@implementation JPCPlayer

- (NSMutableArray *)getPossibleMoves:(NSMutableArray *)cubes player:(JPCPlayer *)player
{
    NSMutableArray *moves = [NSMutableArray new];
    for (JPCCube *cube in cubes) {
        if (cube.currentOwner == player) {
            [moves addObject:cube];
        }
    }
    return moves;
}

- (BOOL)winnerExists:(NSMutableArray *)cubes
{
    JPCPlayer *currentPlayer = (JPCPlayer *)[[cubes objectAtIndex:0] currentOwner];
    for(JPCCube *currentCube in cubes) {
        if (currentCube.currentOwner != currentPlayer) {
            return NO;
        }
    }
    return YES;
}

- (JPCPlayer *)getWinner:(NSMutableArray *)cubes
{
    if ([self winnerExists:cubes]) {
        JPCCube *cube = [cubes objectAtIndex:0];
        return cube.currentOwner;
    }
    return nil;
}

- (int)minmax:(NSMutableArray *)cubes player:(JPCPlayer *)player depth:(int)depth
{
    NSMutableArray *cubesCopy = [[NSMutableArray alloc] initWithArray:cubes copyItems:YES];
    NSMutableArray *moves = [self getPossibleMoves:cubesCopy player:player];
    
    int best = 0;
    int value = NSIntegerMin;
    int alpha = NSIntegerMin;
    int beta = NSIntegerMax;
    for (NSNumber *move in moves) {
        JPCCube *thisMove = [cubesCopy objectAtIndex:move.intValue];
        [thisMove cubeActionWithPlayer:player];
        int result = [self minimizer:cubesCopy
                              player:player
                               depth:depth - 1
                               alpha:alpha
                                beta:beta];
        cubesCopy = [[NSMutableArray alloc] initWithArray:cubes copyItems:YES];
        if (result > value) {
            value = result;
            best = move.intValue;
        }
        alpha = MAX(alpha, value);
    }
    return best;
}

- (int)minimizer:(NSMutableArray *)cubes player:(JPCPlayer *)player depth:(int)depth alpha:(int)alpha beta:(int)beta
{
    if (depth == 0) {
        return [self heuristicValue:cubes player:player];
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] != player) {
        return NSIntegerMax;
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] == player) {
        return NSIntegerMin;
    }
    
    NSMutableArray *cubesCopy = [[NSMutableArray alloc] initWithArray:cubes copyItems:YES];
    NSMutableArray *moves = [self getPossibleMoves:cubesCopy player:player];
    int value = NSIntegerMax;
    
    for (NSNumber *move in moves) {
        JPCCube *thisMove = [cubesCopy objectAtIndex:move.intValue];
        [thisMove cubeActionWithPlayer:player];
        
        int result = [self maximizer:cubesCopy player:player depth:depth - 1 alpha:alpha beta:beta];
        value = MIN(result, value);
        cubesCopy = [[NSMutableArray alloc] initWithArray:cubes copyItems:YES];
        if (value <= alpha) {
            return value;
        }
        beta = MIN(value, beta);
    }
    return value;
}

- (int)maximizer:(NSMutableArray *)cubes player:(JPCPlayer *)player depth:(int)depth alpha:(int)alpha beta:(int)beta
{
    if (depth == 0) {
        return [self heuristicValue:cubes player:player];
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] != player) {
        return NSIntegerMin;
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] == player) {
        return NSIntegerMax;
    }
    
    NSMutableArray *cubesCopy = [[NSMutableArray alloc] initWithArray:cubes copyItems:YES];
    NSMutableArray *moves = [self getPossibleMoves:cubesCopy player:player];
    int value = NSIntegerMin;
    
    for (NSNumber *move in moves) {
        JPCCube *thisMove = [cubesCopy objectAtIndex:move.intValue];
        [thisMove cubeActionWithPlayer:player];
        
        int result = [self minimizer:cubesCopy player:player depth:depth - 1 alpha:alpha beta:beta];
        value = MAX(result, value);
        cubesCopy = [[NSMutableArray alloc] initWithArray:cubes copyItems:YES];
        if (value >= beta) {
            return value;
        }
        alpha = MAX(value, alpha);
    }
    return value;
}

- (int)heuristicValue:(NSMutableArray *)cubes player:(JPCPlayer *)player
{
    int total = 0;
    for (JPCCube *cube in cubes) {
        if (cube.currentOwner == player) {
            if (cube.score == cube.neighborCount) {
                total += 6;
            } else {
                total += 2;
            }
        } else if (cube.currentOwner == nil) {
            total += 1;
        } else {
            if (cube.score == cube.neighborCount) {
                total -= 5;
            } else {
                total -= 4;
            }
        }
    }
    return total;
}

@end
