//
//  WTAThisVersionViewController.m
//  HyperioniOS_Example
//
//  Created by Chris Mays on 11/26/17.
//  Copyright © 2017 chrsmys. All rights reserved.
//

#import "WTAThisVersionViewController.h"
#import "WTAPluginTableViewCell.h"

@interface WTAThisVersionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *pluginListTableView;

@property (strong, nonatomic) IBOutlet WTAPluginTableViewCell *measurementsCell;
@property (strong, nonatomic) IBOutlet WTAPluginTableViewCell *slowAnimationsCell;
@property (strong, nonatomic) IBOutlet WTAPluginTableViewCell *attributesInspectorCell;

@end

@implementation WTAThisVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.pluginListTableView registerNib:[UINib nibWithNibName:@"WTAPluginTableViewCell" bundle:[NSBundle bundleForClass:[WTAThisVersionViewController class]]] forCellReuseIdentifier:@"PluginCell"];

    self.pluginListTableView.delegate = self;
    self.pluginListTableView.dataSource = self;

    [self configureCells];
}

-(void)configureCells
{
    _measurementsCell = [[WTAPluginTableViewCell alloc] init];
    _slowAnimationsCell = [[WTAPluginTableViewCell alloc] init];
    _attributesInspectorCell = [[WTAPluginTableViewCell alloc] init];

    [_measurementsCell bindWithTitle:@"Measurements Tool" image:[UIImage imageNamed:@"Measurements Tool"]];
    [_attributesInspectorCell bindWithTitle:@"Attributes Inspector" image:[UIImage imageNamed:@"Attributes Inspector"]];
    [_slowAnimationsCell bindWithTitle:@"Slow Animation" image:[UIImage imageNamed:@"Slow Animations"]];
}

-(void)viewWillAppear:(BOOL)animated
{
    CATransform3D xTranslation = CATransform3DTranslate(CATransform3DIdentity, self.view.frame.size.width, 0, 0);

    _measurementsCell.layer.transform = xTranslation;
    _attributesInspectorCell.layer.transform = xTranslation;
    _slowAnimationsCell.layer.transform = xTranslation;

    [UIView animateKeyframesWithDuration:1.4 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{

        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.33 animations:^{
            _measurementsCell.layer.transform = CATransform3DIdentity;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.27 relativeDuration:0.33 animations:^{
            _attributesInspectorCell.layer.transform = CATransform3DIdentity;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.54 relativeDuration:0.33 animations:^{
            _slowAnimationsCell.layer.transform = CATransform3DIdentity;
        }];
    } completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     WTAPluginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PluginCell" forIndexPath:indexPath];

    if (indexPath.row == 0)
    {
        return _measurementsCell;
    }
    else if (indexPath.row == 1)
    {
        return  _attributesInspectorCell;
    }
    else if (indexPath.row == 2)
    {
        return _slowAnimationsCell;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sampleRequest:@"https://reqres.in/api/users?page=2"];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sampleRequest:(NSString *)urlString {
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"Accept" forHTTPHeaderField:@"application/json"];
    [request addValue:@"Authorization" forHTTPHeaderField:@"Basic YWxhZGRpbjpvcGVuc2VzYW1l"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Data received: %@", responseStr);
    }] resume];
}

@end
