//
//  ViewController.m
//  ActivityMoniter
//
//  Created by Jeswanth Reddy on 10/17/13.
//  Copyright (c) 2013 Jeswanth Reddy. All rights reserved.
//

#import "PadometerViewController.h"
#import "FileLogger.h"

#define kUpdateFrequency    60.0

@implementation PadometerViewController
@synthesize stepCountLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(IBAction)printData
{
    NSString *str=[[FileLogger sharedInstance]displayContent];
    NSLog(@"output is %@",str);
}
-(IBAction)clearData
{
    [[FileLogger sharedInstance]removeFile];
    [[FileLogger sharedInstance]create];
}

-(IBAction)startAccelerometerData{
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    [self.locationManager startUpdatingLocation];
    
    self.motionManager.accelerometerUpdateInterval = 5;
    
    [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMotionActivity *activity) {
        
        if (activity.stationary) {
            self.activityStatusLabel.text=@"Stationary";
        }
        else if (activity.running)
        {
        
           self.activityStatusLabel.text=@"Running";
            
        }
        else if (activity.walking)
        {
        
           self.activityStatusLabel.text=@"Walking";
         }
        
        else if(activity.automotive)
        {
            self.activityStatusLabel.text=@"Transport";
        
        }
    }];
    
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        float xx = accelerometerData.acceleration.x;
        float yy = accelerometerData.acceleration.y;
        float zz = accelerometerData.acceleration.z;
        
        
        float xFilter=ABS(xx*px);
        float yFilter=ABS(yy*py);
        float zFilter=ABS(zz*pz);
        
        float xyzAdd=xFilter+yFilter+zFilter;
        
        float xyzFilter=ABS(sqrt(xyzAdd*pxyzAdd));
        
        NSString * sss=[NSString stringWithFormat:@"x=%f--y=%f--z=%f--xyzAdd=%f--xyzfil=%f",xFilter,yFilter,zFilter,xyzAdd,xyzFilter];
        
        NSLog(@"%@",sss);
        
        
        
       //  [[FileLogger sharedInstance]log:sss];
        
        
        if (isDriving) {
            self.statusLabel.text=@"Driving";
        }
        else if(isDrivingOrRunning)
        {
            
            if(xyzFilter>2.0)
            {
                
                {
                    if (!startcountingForRunning) {
                        if (localValueForRunning>=20) {
                            numStepsRunning+=5;
                            startcountingForRunning=YES;
                            self.statusLabel.text=@"Running";
                        }
                        else{
                            localValueForRunning++;
                        }
                        
                    }
                    else{
                        
                        isTraSleeping=NO;
                        [timer invalidate];
                        timer=nil;
                        if (!isRunnSleeping) {
                            isRunnSleeping = YES;
                            
                            [self performSelector:@selector(wakeUprunning) withObject:nil afterDelay:0.3];
                            numStepsRunning += 1;
                            //self.stepCountLabel.text = [NSString stringWithFormat:@"%d", numStepsWalking];
                            
                        }
                        localValueForRunning=0;
                    }
                    
                    
                }
                
                
            }
            
            else
            {
                
                if (!isTraSleeping) {
                    isTraSleeping = YES;
                    
                    
                    timer = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                             target: self
                                                           selector: @selector(wakeUpStationaryWithSpeed)
                                                           userInfo: nil
                                                            repeats: NO];
                    // self.statusLabel.text=@"Stationary";
                    
                }
                
            }

        }
        else
        {
            if (xyzFilter < 0.6 &&  xyzFilter >0.4) {
                
                
                if (!startcountingForWalking) {
                    if (localValue>=16) {
                        numStepsWalking+=5;
                        startcountingForWalking=YES;
                        localValue=0;
                        self.statusLabel.text=@"Walking";
                    }
                    else{
                        localValue++;
                    }
                    
                }
                else{
                    
                    isStaSleeping=NO;
                    [timer invalidate];
                    timer=nil;
                    if (!isWalkingSleeping) {
                        isWalkingSleeping = YES;
                        
                        [self performSelector:@selector(wakeUpWalking) withObject:nil afterDelay:0.3];
                        numStepsWalking += 1;
                        self.stepCountLabel.text = [NSString stringWithFormat:@"%d", numStepsWalking];
                        localValue=0;
                    }
                }
                
                
            }
            else if(xyzFilter >0.9 && xyzFilter<2.0)
            {
                
                if (!isStaSleeping) {
                    isStaSleeping = YES;
                    
                    
                    timer = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                             target: self
                                                           selector: @selector(wakeUpStationary)
                                                           userInfo: nil
                                                            repeats: NO];
                    // self.statusLabel.text=@"Stationary";
                    
                }
                
            }
            
        }
       
        
        px = xx; py = yy; pz = zz;
        pxyzAdd=xyzAdd;
        
    } ];
    
    
    
}

-(IBAction)StopAccelerometerData
{
    [self.motionManager stopAccelerometerUpdates];
    self.motionManager = nil;
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    px = py = pz =pxyzAdd = 0;
    numStepsWalking = 0;
    localValue=0;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.motionActivityManager=[[CMMotionActivityManager alloc]init];
    self.locationManager.delegate = self;
    
    self.stepCountLabel.text = [NSString stringWithFormat:@"%d", numStepsWalking];
    self.statusLabel.text=@"Stationary";
    startcountingForWalking=NO;
}

- (void)viewDidUnload
{
    [self setStepCountLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)wakeUpWalking {
    isWalkingSleeping = NO;
    
}
- (void)wakeUpStationary {
    
    //[self.stack addObject:@"1"];
    isStaSleeping = NO;
    self.statusLabel.text=@"Stationary";
    localValue=0;
    startcountingForWalking=NO;
    
    
    
}
- (void)wakeUprunning {
    isRunnSleeping = NO;
}
-(void)wakeUpStationaryWithSpeed
{
    //[self.stack addObject:@"1"];
    isTraSleeping = NO;
    self.statusLabel.text=@"Transport";
    localValueForRunning=0;
    startcountingForRunning=NO;
}


- (IBAction)reset:(id)sender {
    numStepsWalking = 0;
    self.stepCountLabel.text = [NSString stringWithFormat:@"%d", numStepsWalking];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    float speed=self.locationManager.location.speed*2.23693629;
    self.speedLabel.text=[NSString stringWithFormat:@"speed %f",speed];
    if ( speed<4.0) {
        isDriving=NO;
        isDrivingOrRunning=NO;
    }
    else if (speed>4.0 && speed < 12.0)
    {
        isDrivingOrRunning=YES;
        isDriving=NO;
    }
    if (speed>12.0) {
        
        isDriving=YES;
        isDrivingOrRunning=NO;
    }
    
}
@end
