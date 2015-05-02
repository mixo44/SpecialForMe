//
//  SwimmingPool.m
//  SpecialForMe
//
//  Created by Misha Torosyan on 5/2/15.
//  Copyright (c) 2015 Misha Torosyan. All rights reserved.
//

#import "SwimmingPool.h"
#import "Defines.h"

@interface SwimmingPool()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poolImageViewWidthLayout;

@end

@implementation SwimmingPool

- (void)awakeFromNib {
    _poolImageViewWidthLayout.constant = 6;
    [self setNeedsUpdateConstraints];
}

- (void) pushWater:(CGFloat)liter {

    dispatch_async(dispatch_queue_create("pushWater", NULL), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _poolImageViewWidthLayout.constant += 2 * liter;
            [self setNeedsUpdateConstraints];
            [UIView animateWithDuration:1.5f animations:^{
                [self layoutIfNeeded];
            }];
        });
    });
}

@end
