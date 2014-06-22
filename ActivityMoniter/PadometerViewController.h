//
//  ViewController.h
//  ActivityMoniter
//
//  Created by Jeswanth Reddy on 10/17/13.
//  Copyright (c) 2013 Jeswanth Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import  <CoreMotion/CMMotionActivityManager.h>

@interface PadometerViewController : UIViewController<CLLocationManagerDelegate>  {
    float px;
    float py;
    float pz;
    float pxyzAdd;
    
    
    int localValue;
    int localValueForRunning;
    
    int numStepsWalking;
    int numStepsRunning;
    
    
    BOOL isWalkingSleeping;
    BOOL isStaSleeping;
    BOOL isRunnSleeping;
    BOOL isTraSleeping;

   
    
    BOOL isDriving;
    BOOL isDrivingOrRunning;

    
    BOOL startcountingForWalking;
    BOOL startcountingForRunning;

    NSTimer *timer;
    
}

@property (retain, nonatomic) IBOutlet UILabel *stepCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *stepRunningLabel;

@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UILabel *speedLabel;
@property (retain, nonatomic) IBOutlet UILabel *activityStatusLabel;



@property(retain,nonatomic) CMMotionManager *motionManager;
@property(retain,nonatomic) CLLocationManager *locationManager;
@property(retain,nonatomic)CMMotionActivityManager *motionActivityManager;




-(IBAction)reset:(id)sender;
-(IBAction)startAccelerometerData;
-(IBAction)StopAccelerometerData;
-(IBAction)printData;
@end

