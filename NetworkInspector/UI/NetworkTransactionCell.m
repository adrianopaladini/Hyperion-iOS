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

@property (strong, nonatomic) UILabel *methodLabel;
@property (strong, nonatomic) UILabel *urlLabel;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation NetworkTransactionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setup {
    self.methodLabel = [self createLabel:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] textColor:[UIColor darkTextColor]];
    [self.methodLabel setContentHuggingPriority:255 forAxis:UILayoutConstraintAxisHorizontal];
    [self.methodLabel setContentCompressionResistancePriority:755 forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:self.methodLabel];
    
    self.urlLabel = [self createLabel:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular] textColor:[UIColor darkGrayColor]];
    [self addSubview:self.urlLabel];
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[methodLabel]-16-[urlLabel]-16-|" options:NSLayoutFormatAlignAllTop metrics:NULL views:@{@"methodLabel": self.methodLabel, @"urlLabel": self.urlLabel}]];
    
    self.statusLabel = [self createLabel:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] textColor:[UIColor darkTextColor]];
    [self.statusLabel setContentHuggingPriority:255 forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel setContentCompressionResistancePriority:755 forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:self.statusLabel];
    
    self.durationLabel = [self createLabel:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular] textColor:[UIColor darkGrayColor]];
    [self.durationLabel setTextAlignment:NSTextAlignmentRight];
    [self.durationLabel setContentHuggingPriority:255 forAxis:UILayoutConstraintAxisHorizontal];
    [self.durationLabel setContentHuggingPriority:255 forAxis:UILayoutConstraintAxisVertical];
    [self.durationLabel setContentCompressionResistancePriority:755 forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:self.durationLabel];

    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[statusLabel]-16-[durationLabel]-16-|" options:NSLayoutFormatAlignAllBaseline metrics:NULL views:@{@"statusLabel": self.statusLabel, @"durationLabel": self.durationLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[urlLabel]-16-[durationLabel]-16-|" options:0 metrics:NULL views:@{@"urlLabel": self.urlLabel, @"durationLabel": self.durationLabel}]];
}

- (void)setTransaction:(FLEXNetworkTransaction *)transaction {
    [self.methodLabel setText:transaction.request.HTTPMethod];
    [self.urlLabel setText:transaction.request.URL.absoluteString];
    
    NSString *totalDuration = [FLEXUtility stringFromRequestDuration:transaction.duration];
    NSString *latency = [FLEXUtility stringFromRequestDuration:transaction.latency];
    NSString *duration = [NSString stringWithFormat:@"%@ (%@)", totalDuration, latency];
    [self.durationLabel setText:duration];
    
    NSString *statusCodeString = [FLEXUtility statusCodeStringFromURLResponse:transaction.response];
    [self.statusLabel setText:statusCodeString];
    
    if ([FLEXUtility isErrorStatusCodeFromURLResponse:transaction.response]) {
        [self.statusLabel setTextColor:[UIColor colorWithRed:238.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0]];
    } else {
        [self.statusLabel setTextColor:[UIColor colorWithRed:0 green:163.0/255.0 blue:0 alpha:1.0]];
    }
}

- (UILabel *)createLabel:(UIFont *)font textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label setFont:font];
    [label setTextColor:color];
    
    return label;
}

@end
