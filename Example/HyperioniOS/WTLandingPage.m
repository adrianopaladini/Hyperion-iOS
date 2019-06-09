//
//  WTAViewController.m
//  HyperioniOS
//
//  Created by chrsmys on 05/04/2017.
//  Copyright (c) 2017 chrsmys. All rights reserved.
//

#import "WTLandingPage.h"
#import "HyperionManager.h"
@import AVFoundation;
@import AVKit;

@interface WTLandingPage ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WTLandingPage

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.button.layer setShadowOffset: CGSizeMake(0, 1)];
    [self.button.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.button.layer setShadowOpacity:1];
    [self.button.layer setShadowRadius:1];
}

@end
