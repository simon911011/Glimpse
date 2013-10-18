//
//  SLPhotoCell.m
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/5/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import "SLPhotoCell.h"

@implementation SLPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSInteger number = arc4random() % 12;
    NSArray *colors = @[@[@71, @201, @175],
                        @[@22, @160, @133],
                        @[@87, @214, @141],
                        @[@39, @174, @96],
                        @[@92, @172, @226],
                        @[@83, @153, @199],
                        @[@241, @196, @15],
                        @[@245, @175, @65],
                        @[@235, @151, @78],
                        @[@219, @118, @51],
                        @[@231, @76, @60],
                        @[@192, @57, @43]];

    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect cardRect = CGRectMake(self.bounds.origin.x + 100, self.bounds.origin.y, 220, 220);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, cardRect);
    
    CGRect sideRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 100, 220);
    CGContextSetRGBFillColor(context, [colors[number][0] floatValue]/255, [colors[number][1] floatValue]/255, [colors[number][2] floatValue]/255, 1.0);
    CGContextFillRect(context, sideRect);
}


@end
