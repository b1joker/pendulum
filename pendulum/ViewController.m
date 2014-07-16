//
//  ViewController.m
//  pendulum
//
//  Created by Gin on 7/16/14.
//  Copyright (c) 2014 Nguyễn Huỳnh Lâm. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define MAX_ANGLE M_PI_4 * 0.5

@interface ViewController ()<UITextFieldDelegate>
{
    long point,s;
    NSTimer *_timer;
    double _angle,angle,number;
    double _angleDelta,angleDelta;
    SystemSoundID sound;
    __weak IBOutlet UITextField *textFieldHour;
    __weak IBOutlet UITextField *textFieldMinute;
    __weak IBOutlet UITextField *textFieldSecond;
}
@property (weak, nonatomic) IBOutlet UIImageView *pendulum;
@property (weak, nonatomic) IBOutlet UIImageView *bird;
@property (weak, nonatomic) IBOutlet UIImageView *minute;
@property (weak, nonatomic) IBOutlet UIImageView *hour;
@property (weak, nonatomic) IBOutlet UIImageView *second;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.pendulum.layer.anchorPoint = CGPointMake(0.5, 0);
    self.minute.layer.anchorPoint = CGPointMake(0,1);
    self.second.layer.anchorPoint = CGPointMake(0, 1);
    self.hour.layer.anchorPoint = CGPointMake(0, 1);

    _angle = 0.0;
    _angleDelta = 0.05;
    
    angle = 0.0;
    angleDelta = 6*3.1416/180;
    point = 0;
    s = 0;
    NSURL *soundX = [NSURL fileURLWithPath:[[NSBundle mainBundle]	pathForResource:@"alarmSound" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef) soundX, 	&sound);
    
    self->textFieldHour.delegate = self;
    self->textFieldMinute.delegate = self;
    self->textFieldSecond.delegate = self;

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if([textField becomeFirstResponder ])
       [textField resignFirstResponder];
    
    return YES;
}

- (void) startAnimation
{
    _timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                              target: self
                                            selector: @selector(animatePendulum)
                                            userInfo: nil
                                             repeats: YES];
    [_timer fire];
    
}
- (IBAction)setTime:(id)sender {
    [_timer invalidate];
    _timer = nil;
    
    number = [textFieldSecond.text intValue] *angleDelta +  [textFieldMinute.text intValue] *angleDelta*60 + [textFieldHour.text intValue] *angleDelta*3600;
    self.second.transform = CGAffineTransformMakeRotation(number);
    
    self.minute.transform = CGAffineTransformMakeRotation(number/60);
    
    self.hour.transform = CGAffineTransformMakeRotation(number/720);
    
    angle = number;
    s = [textFieldSecond.text intValue]  +  [textFieldMinute.text intValue] *60 + [textFieldHour.text intValue] *3600;
    
    [self startAnimation];
}

- (IBAction)startStopAnimation:(UISwitch *)sender {
    if ([sender isOn]) {
        [self startAnimation];
    } else if (_timer.isValid) {
        
        [_timer invalidate];
        
        _timer = nil;
    }
    
}

- (void) animatePendulum
{
    point++;
    _angle += _angleDelta;
    
    
    if ((_angle > MAX_ANGLE) | (_angle < - MAX_ANGLE)) {
        _angleDelta = - _angleDelta;
    }
    self.pendulum.transform = CGAffineTransformMakeRotation(_angle);
    

    if(point%10 == 0) // 1 giay
    {
        s++; // gia^y hien tai
        
        angle +=  angleDelta;

        if(s % 3600 == 0)
        {
            s = 0; // rs
            point = 0;
            
            AudioServicesPlaySystemSound(sound);
        
            [UIView animateWithDuration:3 animations:^{
                
                self.bird.center = CGPointMake(50, 50);
                
                } completion:^(BOOL finished) {
                
                    [UIView animateWithDuration:3 animations:^{

                        self.bird.center = CGPointMake(160, 50);
                    }];
                }];
        }
        NSLog(@"%ld",s);
        self.second.transform = CGAffineTransformMakeRotation(angle);
        
        self.minute.transform = CGAffineTransformMakeRotation(angle/60);
        
        self.hour.transform = CGAffineTransformMakeRotation(angle/720);
    }
    
    
    
    
}

@end
