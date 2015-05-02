//
//  ViewController.m
//  SpecialForMe
//
//  Created by Misha Torosyan on 5/2/15.
//  Copyright (c) 2015 Misha Torosyan. All rights reserved.
//

#import "ViewController.h"
#import "FireTruckView.h"
#import "SwimmingPool.h"

#import "Defines.h"

@interface ViewController () <FireTruckDelegate>

@property (weak, nonatomic) IBOutlet SwimmingPool *poolImageView;
@property (strong, nonatomic) NSMutableArray *fireTrucks;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self applicationStarted];
}

- (void)viewDidAppear:(BOOL)animated {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons actions

- (IBAction)startButtonAction:(UIButton *)sender {
    
    sender.hidden = YES;
    
    for (FireTruckView *obj in _fireTrucks) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random_uniform(_FIRE_TRUCKS_COUNT + 3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSMutableArray *constraints = [ViewController findConstraintFromView:self.view
                                                                        withView:obj
                                                                      withString:@"trailing"];
            
            [obj startActionToPool:_poolImageView
                    withConstraint:[constraints lastObject]];
        });
    }
    
}


#pragma mark - Main functions

- (void)applicationStarted {
    _startButton.layer.cornerRadius = 10;
    [self drawFireTrucksAndRoad:_FIRE_TRUCKS_COUNT];
}

- (void) drawFireTrucksAndRoad:(NSUInteger)count {
    
    _fireTrucks = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; ++i) {
        
        FireTruckView *fireTruck = [[FireTruckView alloc] init];
        fireTruck.delegate = self;
        fireTruck.translatesAutoresizingMaskIntoConstraints = NO;
        
        static UIImageView *lastRoad;
        UIImageView *road = [[UIImageView alloc] init];
        road.translatesAutoresizingMaskIntoConstraints = NO;
        
        road.image = [UIImage imageNamed:@"road"];
        
        [self.view addSubview:road];
        [self.view addSubview:fireTruck];
        
        [self.view sendSubviewToBack:road];
        
        
        
        if (i == 0) {
            
            [self.view addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|-[fireTruck]"
                                       options:0
                                       metrics:nil
                                       views:NSDictionaryOfVariableBindings(fireTruck)]];
            
            [self.view addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|-[road]"
                                       options:0
                                       metrics:nil
                                       views:NSDictionaryOfVariableBindings(road)]];
            
            
        } else if (i == count - 1) {
            
            FireTruckView *lastFireTrcuk = [_fireTrucks lastObject];
            [self.view addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:
                                       @"V:[lastFireTrcuk(==fireTruck)]-"
                                       "[fireTruck(==lastFireTrcuk)]-(10)-|"
                                       options:0
                                       metrics:nil
                                       views:NSDictionaryOfVariableBindings(fireTruck,
                                                                            lastFireTrcuk)]];
            
            [self.view addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:
                                       @"V:[lastRoad(==road)]-(2)-"
                                       "[road(==lastRoad)]-|"
                                       options:0
                                       metrics:nil
                                       views:NSDictionaryOfVariableBindings(road,
                                                                            lastRoad)]];
        } else {
            
            FireTruckView *lastFireTrcuk = [_fireTrucks lastObject];
            [self.view addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:
                                       @"V:[lastFireTrcuk(==fireTruck)]-"
                                       "[fireTruck(==lastFireTrcuk)]"
                                       options:0
                                       metrics:nil
                                       views:NSDictionaryOfVariableBindings(fireTruck,
                                                                            lastFireTrcuk)]];
            
            [self.view addConstraints:[NSLayoutConstraint
                                       constraintsWithVisualFormat:
                                       @"V:[lastRoad(==road)]-(2)-"
                                       "[road(==lastRoad)]"
                                       options:0
                                       metrics:nil
                                       views:NSDictionaryOfVariableBindings(road,
                                                                            lastRoad)]];
            
        }
        
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:[fireTruck]-|"
                                   options:0
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(fireTruck)]];
        
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|[road]|"
                                   options:0
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(road)]];
        
        [_fireTrucks addObject:fireTruck];
        lastRoad = road;
    }
    
}


#pragma mark - Constraints Settings

+ (NSMutableArray *) findConstraintFromView:(UIView *)mainView
                                   withView:(UIView *)otherView
                                 withString:(NSString *)string {
    
    
    __block NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    
    [mainView.constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
        
        if ([constraint.firstItem isEqual:otherView] ||
            [constraint.secondItem isEqual:otherView]) {
            NSString *stringFromConstraint = [NSString stringWithFormat:@"%@", constraint];
            
            if (string) {
                if ([stringFromConstraint containsString:string]) {
                    [constraintsArray addObject:constraint];
                }
            } else {
                [constraintsArray addObject:constraint];
            }
        }
        
    }];
    
    return constraintsArray;
    
}

#pragma mark - FireTruckDelegate

- (void)fireTruckFinishedAction:(FireTruckView *)fireTruck isBackWay:(BOOL)isBackWay {
    
    if (_poolImageView.frame.size.width <= _MAX_POOL_WEIGHT || isBackWay) {
        
        NSMutableArray *constraints = [ViewController findConstraintFromView:self.view
                                                                    withView:fireTruck
                                                                  withString:@"trailing"];
        
        [fireTruck startActionToPool:_poolImageView
                      withConstraint:[constraints objectAtIndex:0]];
        if (isBackWay) {
            [_poolImageView pushWater:_FIRE_TRUCK_WATER_WEIGHT];
        }
    } else {
        NSLog(@"%@ = %f, wieght = %f", fireTruck, fireTruck.waterWeight, _poolImageView.frame.size.width);
        [fireTruck showResult];
    }
    
}
@end
