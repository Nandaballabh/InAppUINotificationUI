//
//  InAppNotificationUI.h
//  Toggr
//
//  Created by Nanda Ballabh on 7/15/15.
//  Copyright (c) 2015 Nanda Ballabh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchBlock)(void);

@interface InAppNotificationUI : UIView <UIAppearance>

@property (strong , nonatomic) UIColor * backColor UI_APPEARANCE_SELECTOR ;
@property (strong , nonatomic) UIColor * titleColor UI_APPEARANCE_SELECTOR ;
@property (strong , nonatomic) UIColor * subTitleColor UI_APPEARANCE_SELECTOR ;
@property (strong , nonatomic) UIFont * titleFont UI_APPEARANCE_SELECTOR ;
@property (strong , nonatomic) UIFont * subTitleFont UI_APPEARANCE_SELECTOR ;

+ (void) notificationWithTitle:(NSString *)title
                     iconImage:(UIImage *)image
                  hideDuration:(NSTimeInterval)duration
                 andTouchBlock:(void(^)(void))touchBlock;
@end
