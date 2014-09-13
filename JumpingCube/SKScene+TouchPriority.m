//
//  SKScene+TouchPriority.m
//  ButtonLab
//
//  Created by Fille Åström on 10/20/13, modified by Maneesh Goel on 9/13/13.
//  Copyright (c) 2013 IMGNRY. All rights reserved.
//

#import "SKScene+TouchPriority.h"
@implementation SKScene (TouchPriority)
-(SKNode *)nodeWithHighestPriority:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    NSArray *touchedNodes = [self nodesAtPoint:touchLocation];
    SKNode *nodeToTouch = nil;
    for (SKNode *node in touchedNodes) {
        if ([node.name isEqualToString:@"Cube"] && node.hidden == NO && node.alpha > 0) {
            if (nodeToTouch == nil) {
                nodeToTouch = node;
            }
        }
    }
    return nodeToTouch;
}
@end