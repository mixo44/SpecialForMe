//
//  FireTruckView.h
//  SpecialForMe
//
//  Created by Misha Torosyan on 5/2/15.
//  Copyright (c) 2015 Misha Torosyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FireTruckView;
@class SwimmingPool;

@protocol FireTruckDelegate <NSObject>

- (void)fireTruckFinishedAction:(FireTruckView *)fireTruck isBackWay:(BOOL)isBackWay;

@end

@interface FireTruckView : UIView

@property (readonly) CGFloat waterWeight;

@property (weak, nonatomic) id <FireTruckDelegate> delegate;

- (void) drawWaterWhitProgress:(CGFloat)progress;
- (void) pushWaterOut;
- (void) showResult;

- (void) startActionToPool:(SwimmingPool *)pool
            withConstraint:(NSLayoutConstraint *)constraint;

@end
