//
//  FireTruckView.m
//  SpecialForMe
//
//  Created by Misha Torosyan on 5/2/15.
//  Copyright (c) 2015 Misha Torosyan. All rights reserved.
//

#import "FireTruckView.h"

#import "SwimmingPool.h"
#import "Defines.h"

@interface FireTruckView ()

@property (strong, nonatomic) IBOutlet UIImageView *fireTruckImage;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (assign, nonatomic) CGFloat waterWeight;

@end

@implementation FireTruckView

- (id) init
{
    self = [[[NSBundle mainBundle] loadNibNamed: @"FireTruckView"
                                          owner: self
                                        options: nil] firstObject];
    [self showResult];
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed: @"FireTruckView"
                                          owner: self
                                        options: nil] firstObject];
    self.frame = frame;
    
    return self;
}

- (void) drawWaterWhitProgress:(CGFloat)progress {
    
    _waterWeight += 2 * _FIRE_TRUCK_WATER_WEIGHT;
    
    [_progressView setProgress:progress animated:YES];
}

- (void) pushWaterOut {
    [_progressView setProgress:0 animated:YES];
}


- (void) startActionToPool:(SwimmingPool *)pool
            withConstraint:(NSLayoutConstraint *)constraint {
    
    
    BOOL boolValue;
    CGFloat constraintSize = 0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIImageOrientation imageOrintation;
    
    if (constraint.constant) {
        
        imageOrintation = UIImageOrientationUp;
        constraintSize = -constraintSize;
        boolValue = NO;
        
    } else {
        
        [self drawWaterWhitProgress:_DRAW_WATER_TIME];
        imageOrintation = UIImageOrientationUpMirrored;
        constraintSize = screenWidth - pool.frame.size.width - self.frame.size.width - 20 * _FIRE_TRUCK_WATER_WEIGHT;
        boolValue = YES;
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_DRAW_WATER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        constraint.constant = constraintSize;
        
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:1.5f animations:^{
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self pushWaterOut];
            
            _fireTruckImage.image = [UIImage imageWithCGImage:_fireTruckImage.image.CGImage
                                                        scale:_fireTruckImage.image.scale
                                                  orientation:imageOrintation];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_DRAW_WATER_TIME - 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_delegate fireTruckFinishedAction:self isBackWay:boolValue];
            });
            
        }];
    });
}


- (void) showResult {
    
#warning I CAN'T DO THIIIISSSSS. WHYYYYY???
        dispatch_async(dispatch_get_main_queue(), ^{
            _resultLabel.hidden = NO;
        });
    
    
}
@end
