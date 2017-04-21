//
//  ViewController.m
//  InAppNotificatioUIExample
//
//  Created by Nanda Ballabh on 21/04/17.
//  Copyright © 2017 nandaballabh. All rights reserved.
//

#import "ViewController.h"
#import "InAppNotificationUI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) showButtonTapped:(id) sender {
  
    [InAppNotificationUI notificationWithTitle:@"This is example" iconImage:nil hideDuration:3 andTouchBlock:^{
    
    }];
    
}
@end
