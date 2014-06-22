//
//  SpeedViewController.h
//  ActivityMoniter
//
//  Created by Jeswanth Reddy on 10/29/13.
//  Copyright (c) 2013 Jeswanth Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeedViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *acclX;
@property (retain, nonatomic) IBOutlet UILabel *acclY;

@property (retain, nonatomic) IBOutlet UILabel *acclZ;
@property (retain, nonatomic) IBOutlet UILabel *vector;
@property (retain, nonatomic) IBOutlet UILabel *velocity;
@property (retain, nonatomic) IBOutlet UILabel *speed;

@property(assign)BOOL isVelocitySleeping;

-(IBAction)startAccelerometerData;
-(IBAction)StopAccelerometerData;

@end
