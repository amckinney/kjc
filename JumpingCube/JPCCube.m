//
//  JPCCube.m
//  JumpingCube
//
//  Created by Maneesh Goel on 9/13/14.
//
//

#import "JPCCube.h"
@implementation JPCCube
-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size {
    self = [super initWithColor:color size:size];
    if (self) {
        self.color = color;
        self.size = size;
    }
    return self;
}

-(void)cubeAction {
    //change color if necessary
    //increment value
}
@end
