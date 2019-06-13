//
//  URLRequestCell.m
//  NetworkInspector
//
//  Created by Andy Do on 6/9/19.
//  Copyright © 2019 WillowTree. All rights reserved.
//

#import "NetworkTransactionCell.h"
#import "FLEXUtility.h"

@interface NetworkTransactionCell()

@property (weak, nonatomic) IBOutlet UILabel *methodLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation NetworkTransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTransaction:(FLEXNetworkTransaction *)transaction {
    [self.methodLabel setText:transaction.request.HTTPMethod];
    [self.urlLabel setText:transaction.request.URL.absoluteString];
    
    NSString *totalDuration = [FLEXUtility stringFromRequestDuration:transaction.duration];
    NSString *latency = [FLEXUtility stringFromRequestDuration:transaction.latency];
    NSString *duration = [NSString stringWithFormat:@"%@ (%@)", totalDuration, latency];
    [self.durationLabel setText:duration];
    
    //NSString *statusCodeString = [FLEXUtility statusCodeStringFromURLResponse:transaction.response];
}

@end
