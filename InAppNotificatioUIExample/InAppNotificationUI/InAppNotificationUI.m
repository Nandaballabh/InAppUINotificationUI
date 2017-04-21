//
//  InAppNotificationUI.m
//  Toggr
//
//  Created by Nanda Ballabh on 7/15/15.
//  Copyright (c) 2015 Nanda Ballabh. All rights reserved.
//

#import "InAppNotificationUI.h"
#import <AVFoundation/AVFoundation.h>

@interface InAppNotificationUI()

@property (copy,nonatomic) TouchBlock touchBlock;
@property (strong , nonatomic) UILabel * titleLabel;
@property (strong , nonatomic) NSString * title;
@property (strong , nonatomic) NSString * subTitle;

@end

@implementation InAppNotificationUI


+ (void) notificationWithTitle:(NSString *)title
                     iconImage:(UIImage *)iconImage
                  hideDuration:(NSTimeInterval)duration
                 andTouchBlock:(void(^)(void))touchBlock {
    
    InAppNotificationUI * notificationUI = [[InAppNotificationUI alloc]initWithFrame:CGRectMake(0.0f, -100.0f, CGRectGetWidth([UIScreen mainScreen].bounds),64.0f)];
    notificationUI.backgroundColor = notificationUI.backColor ? notificationUI.backColor : [UIColor redColor];
    notificationUI.touchBlock = touchBlock;
    notificationUI.title = title;
    // Create the icon image View
    UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0f, 22.0f, 25.0f, 25.0f)];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.layer.cornerRadius = 5.0f;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = iconImage;
    if(iconImage == nil)
        iconImageView.backgroundColor = [UIColor whiteColor];
    [notificationUI addSubview:iconImageView];
    
    // Create the title  label with
    
    CGRect frame = notificationUI.frame;
    frame.origin.x = CGRectGetMaxX(iconImageView.frame) + 10.0f;
    frame.origin.y = CGRectGetMinY(iconImageView.frame);
    frame.size.width = CGRectGetWidth(notificationUI.frame) - frame.origin.x - 5.0f;
    frame.size.height = CGRectGetHeight(notificationUI.frame) - frame.origin.y - 5.0f;

    notificationUI.titleLabel = [[UILabel alloc]initWithFrame:frame];
    notificationUI.titleLabel.backgroundColor = [UIColor clearColor];
    notificationUI.titleLabel.numberOfLines = 0;
    notificationUI.titleLabel.textAlignment = NSTextAlignmentLeft;
    notificationUI.titleLabel.text = title;
    [notificationUI addSubview:notificationUI.titleLabel];
    [notificationUI.titleLabel sizeToFit];
    // Add tap gesture
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:notificationUI action:@selector(tappedOnNotificationUI:)];
    [notificationUI addGestureRecognizer:tapGesture];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [notificationUI showWithCompletion:NULL];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [notificationUI hideWithCompletion:^{
            [notificationUI removeFromSuperview];
        }];
    });
    
    
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.font = self.titleFont ? self.titleFont : [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    self.titleLabel.textColor = self.titleColor ? self.titleColor : [UIColor blackColor];
    self.backgroundColor = self.backColor ? self.backColor : [UIColor redColor];
}

- (void)tappedOnNotificationUI:(UIGestureRecognizer *) gestureRecognizer {

    if(self.touchBlock) {
        [self hideWithCompletion:^{
            
            self.touchBlock();
            [self removeFromSuperview];
            
        }];
    }
}

- (void) showWithCompletion:(void(^)(void))complete {
    
    // Play the song and vibrate
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory: AVAudioSessionCategoryPlayback  error:&err];
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar + 1];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [UIView animateWithDuration:0.75 animations:^{

            CGRect frame = self.frame;
            frame.origin.y = 0.0f;
            self.frame = frame;

        } completion:^(BOOL finished) {
            if(complete)
                complete();
    }];
    
}

- (void) hideWithCompletion:(void(^)(void))complete {
    [UIView animateWithDuration:0.75 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -100.0f;
        self.frame = frame;
     } completion:^(BOOL finished) {
         
         if([InAppNotificationUI inAppUICount] == 1)
             [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];

        if(complete)
            complete();
    }];

}

+ (NSInteger) inAppUICount {
    
    NSInteger inappUICount = 0;
    
    for (UIView * subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if([subView isKindOfClass:[InAppNotificationUI class]])
            inappUICount ++;
    }
    NSLog(@"InAppUICount:%ld",(long)inappUICount);
    return inappUICount;
}
@end
