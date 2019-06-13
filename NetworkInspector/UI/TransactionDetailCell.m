//
//  TransactionDetailCell.m
//  HyperioniOS
//
//  Created by Andy Do on 6/13/19.
//

#import "TransactionDetailCell.h"

@interface TransactionDetailCell()

@property (strong, nonatomic) UILabel *keyLabel;
@property (strong, nonatomic) UILabel *valueLabel;

@end

@implementation TransactionDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setup {
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.keyLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    [self.keyLabel setTextColor:[UIColor darkTextColor]];
    
    [self.keyLabel setContentHuggingPriority:255 forAxis:UILayoutConstraintAxisHorizontal];
    [self.keyLabel setContentCompressionResistancePriority:755 forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:self.keyLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.numberOfLines = 0;
    self.valueLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.valueLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
    [self.valueLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:self.valueLabel];
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[keyLabel]-16-[valueLabel]-16-|" options:NSLayoutFormatAlignAllTop metrics:NULL views:@{@"keyLabel": self.keyLabel, @"valueLabel": self.valueLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[valueLabel]-8-|" options:NSLayoutFormatAlignAllLeft metrics:NULL views:@{@"valueLabel": self.valueLabel}]];
}

- (void)setTitle:(NSString *)title detailTitle:(NSString *)detailTitle {
    [self.keyLabel setText:title];
    [self.valueLabel setText:detailTitle];
}

@end
