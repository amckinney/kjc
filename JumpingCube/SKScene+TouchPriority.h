//
//  SKScene+TouchPriority.h
//  ButtonLab
//
//  Created by Fille Åström on 10/20/13.
//  Copyright (c) 2013 IMGNRY. All rights reserved.
//

@interface SKScene (TouchPriority)
-(SKNode *)nodeWithHighestPriority:(NSSet *)touches;
@end