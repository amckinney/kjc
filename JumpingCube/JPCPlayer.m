//
//  JPCPlayer.m
//  JumpingCube
//
//  Created by Maneesh Goel and Alex McKinney on 9/13/14.
//
//

#import "JPCPlayer.h"
#import "JPCCube.h"
@implementation JPCPlayer

-(NSMutableArray *)getPossibleMoves:(NSMutableArray *)cubes player:(JPCPlayer *)player {
    NSMutableArray *moves = [NSMutableArray new];
    for (JPCCube *cube in cubes) {
        if (cube.currentOwner == player || cube.currentOwner == nil) {
            [moves addObject:cube];
        }
    }
    return moves;
}

-(BOOL)winnerExists:(NSMutableArray *)cubes {
    JPCPlayer *currentPlayer = (JPCPlayer *)[[cubes objectAtIndex:0] currentOwner];
    for(JPCCube *currentCube in cubes) {
        if (currentCube.currentOwner != currentPlayer) {
            return NO;
        }
    }
    return YES;
}

-(JPCPlayer *)getWinner:(NSMutableArray *)cubes {
    if ([self winnerExists:cubes]) {
        JPCCube *cube = [cubes objectAtIndex:0];
        return cube.currentOwner;
    }
    return nil;
}

-(NSMutableArray *)copyCubes:(NSMutableArray *)cubes {
    NSMutableArray *currentCubes = [[NSMutableArray alloc] init];
    for (JPCCube *cube in cubes) {
        JPCCube *newCube = [[JPCCube alloc] initWithColor:cube.color size:cube.size];
        newCube.currentOwner = cube.currentOwner;
        newCube.score = cube.score;
        newCube.neighborCount = cube.neighborCount;
        newCube.indexInArray = cube.indexInArray;
        [currentCubes addObject:newCube];
    }
    return currentCubes;
}

-(int)minmax:(NSMutableArray *)cubes player:(JPCPlayer *)player depth:(int)depth {
    NSMutableArray *cubesCopy = [self copyCubes:cubes];
    NSMutableArray *moves = [self getPossibleMoves:cubesCopy player:player];
    
    int best = [(JPCCube *)moves[0] indexInArray];
    int value = (int)NSIntegerMin;
    int alpha = (int)NSIntegerMin;
    int beta = (int)NSIntegerMax;
    int index = 0;
    for (JPCCube *cube in moves) {
        index = cube.indexInArray;
        JPCCube *copiedCube = cubesCopy[index];
        [copiedCube cubeActionWithPlayer:player];
        int result = [self minimizer:cubesCopy
                              player:player
                               depth:depth-1
                               alpha:alpha
                                beta:beta];
        cubesCopy = [self copyCubes:cubes];
        if (result > value) {
            value = result;
            best = index;
        }
        alpha = MAX(alpha, value);
    }
    return best;
}

-(int)minimizer:(NSMutableArray *)cubes player:(JPCPlayer *)player depth:(int)depth alpha:(int)alpha beta:(int)beta {
    if (depth == 0) {
        return [self heuristicValue:cubes player:self.opponentForAI];
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] != player) {
        return (int)NSIntegerMax;
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] == player) {
        return (int)NSIntegerMin;
    }
    
    NSMutableArray *cubesCopy = [self copyCubes:cubes];
    NSMutableArray *moves = [self getPossibleMoves:cubesCopy player:self.opponentForAI];
    int value = (int)NSIntegerMax;
    
    for (JPCCube *cube in moves) {
        int index = cube.indexInArray;
        JPCCube *copiedCube = cubesCopy[index];
        [copiedCube cubeActionWithPlayer:self.opponentForAI];
        int result = [self maximizer:cubesCopy player:player depth:depth-1 alpha:alpha beta:beta];
        value = MIN(result, value);
        cubesCopy = [self copyCubes:cubes];
        if (value <= alpha) {
            return value;
        }
        beta = MIN(value, beta);
    }
    return value;
}

-(int)maximizer:(NSMutableArray *)cubes player:(JPCPlayer *)player depth:(int)depth alpha:(int)alpha beta:(int)beta {
    if (depth == 0) {
        return [self heuristicValue:cubes player:player];
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] != player) {
        return (int)NSIntegerMin;
    } else if ([self winnerExists:cubes] && [self getWinner:cubes] == player) {
        return (int)NSIntegerMax;
    }
    
    NSMutableArray *cubesCopy = [self copyCubes:cubes];
    NSMutableArray *moves = [self getPossibleMoves:cubesCopy player:player];
    int value = (int)NSIntegerMin;
    
    for (JPCCube *cube in moves) {
        int index = cube.indexInArray;
        JPCCube *copiedCube = cubesCopy[index];
        [copiedCube cubeActionWithPlayer:player];
        int result = [self minimizer:cubesCopy player:player depth:depth-1 alpha:alpha beta:beta];
        value = MAX(result, value);
        cubesCopy = [self copyCubes:cubes];
        if (value >= beta) {
            return value;
        }
        alpha = MAX(value, alpha);
    }
    return value;
}

-(int)heuristicValue:(NSMutableArray *)cubes player:(JPCPlayer *)player {
    int total = 0;
    for (JPCCube *cube in cubes) {
        if (cube.currentOwner == player) {
            if (cube.score == cube.neighborCount) {
                total += 2;
            } else {
                total += 3;
            }
        } else if (cube.currentOwner == nil) {
            total += 1;
        } else {
            if (cube.score == cube.neighborCount) {
                total -= 2;
            } else {
                total -= 3;
            }
        }
    }
    return total;
}

@end
