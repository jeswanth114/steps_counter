//
//  SpeedViewController.m
//  ActivityMoniter
//
//  Created by Jeswanth Reddy on 10/29/13.
//  Copyright (c) 2013 Jeswanth Reddy. All rights reserved.
//

#import "SpeedViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "FileLogger.h"

@interface SpeedViewController ()
{
    UIAccelerationValue gravX;
    UIAccelerationValue gravY;
    UIAccelerationValue gravZ;
    UIAccelerationValue prevVelocity;
    UIAccelerationValue prevAcce;
    UIAccelerationValue prevDisatance;

}
@property(retain,nonatomic) CMMotionManager *motionManager;
@end


@implementation SpeedViewController


#define kAccelerometerFrequency        50.0 //Hz
#define kFilteringFactor 0.1


-(IBAction)startAccelerometerData{
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = 1;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        gravX = (accelerometerData.acceleration.x * kFilteringFactor) + (gravX * (1.0 - kFilteringFactor));
        gravY = (accelerometerData.acceleration.y * kFilteringFactor) + (gravY * (1.0 - kFilteringFactor));
        gravZ = (accelerometerData.acceleration.z * kFilteringFactor) + (gravZ * (1.0 - kFilteringFactor));
        
        UIAccelerationValue accelX = accelerometerData.acceleration.x - ( (accelerometerData.acceleration.x * kFilteringFactor) + (gravX * (1.0 - kFilteringFactor)) );
        
        UIAccelerationValue accelY = accelerometerData.acceleration.y - ( (accelerometerData.acceleration.y * kFilteringFactor) + (gravY * (1.0 - kFilteringFactor)) );
        UIAccelerationValue accelZ = accelerometerData.acceleration.z - ( (accelerometerData.acceleration.z * kFilteringFactor) + (gravZ * (1.0 - kFilteringFactor)) );
        accelX *= 9.81f;
        accelY *= 9.81f;
        accelZ *= 9.81f;
        accelX = [self tendToZero:accelX];
        accelY = [self tendToZero:accelY];
        accelZ = [self tendToZero:accelZ];
        
        UIAccelerationValue vector = sqrt(pow(accelX,2)+pow(accelY,2)+pow(accelZ, 2));
        UIAccelerationValue acce = vector - prevVelocity;
        UIAccelerationValue velocity = (((acce - prevAcce)/2) * (1/kAccelerometerFrequency)) + prevVelocity;
        
        
        UIAccelerationValue distance = ((velocity + prevVelocity)/2 * (1/kAccelerometerFrequency) + prevDisatance);
        
        NSString *sss=[NSString stringWithFormat:@"X %g Y %g Z %g, Vector %g, Velocity %g, distance %g",accelX,accelY,accelZ,vector,velocity,distance];
        NSLog(@"%@",sss);
        
        [[FileLogger sharedInstance]log:sss];
        
        self.acclX.text=[NSString stringWithFormat:@"x is%f",accelX];
        self.acclY.text=[NSString stringWithFormat:@"y is %f",accelY];
        
        self.acclZ.text=[NSString stringWithFormat:@"z is %f",accelZ];
        
        self.vector.text=[NSString stringWithFormat:@"vector is %f",vector];
        
        self.velocity.text=[NSString stringWithFormat:@"velocity is %f",velocity];
        
        
        
        if (!self.isVelocitySleeping) {
            
            self.isVelocitySleeping = YES;
            
            [self performSelector:@selector(wakeUpVel) withObject:nil afterDelay:0.3];
            self.speed.text=[NSString stringWithFormat:@"distance  is %f",distance];

            
            
        }
        
        
        prevAcce = acce;
        prevVelocity = velocity;
        prevDisatance=distance;
        
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    gravX = gravY = gravZ = prevVelocity = prevAcce = prevDisatance=0.f;
}

      
-(void)wakeUpVel
{
    self.isVelocitySleeping=NO;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UIAccelerationValue)tendToZero:(UIAccelerationValue)value {
    if (value < 0) {
        return ceil(value);
    } else {
        return floor(value);
    }
}

-(IBAction)StopAccelerometerData
{
    [self.motionManager stopAccelerometerUpdates];
    self.motionManager = nil;
}


@end
