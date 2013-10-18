//
//  UIImage+Resize.h
//  Glimpse
//
//  Created by Shao Ping Lee on 9/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

@end
