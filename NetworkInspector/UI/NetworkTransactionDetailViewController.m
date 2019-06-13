//
//  URLRequestDetailViewController.m
//  NetworkInspector
//
//  Created by Andy Do on 6/9/19.
//  Copyright © 2019 WillowTree. All rights reserved.
//

#import "NetworkTransactionDetailViewController.h"
#import "FLEXUtility.h"
#import "FLEXNetworkRecorder.h"

@interface NetworkTransactionDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *requestURLLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestResponseCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestRequestTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestDurationLabel;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *requestBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseBodyLabel;

@end

@implementation NetworkTransactionDetailViewController

FLEXNetworkTransaction *_transaction;

- (instancetype)initWithTransaction:(FLEXNetworkTransaction *)transaction {
    NSBundle *bundle = [NSBundle bundleForClass:NetworkTransactionDetailViewController.self];
    self = [super initWithNibName:NSStringFromClass(NetworkTransactionDetailViewController.self) bundle:bundle];
    
    _transaction = transaction;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTransaction:_transaction];
}

- (void)setTransaction:(FLEXNetworkTransaction *)transaction {
    [self.requestMethodLabel setText:transaction.request.HTTPMethod];
    [self.requestURLLabel setText:transaction.request.URL.absoluteString];
    
    NSString *httpResponseCode = [FLEXUtility statusCodeStringFromURLResponse:transaction.response];
    [self.requestResponseCodeLabel setText:httpResponseCode];
    
    NSString *sentDate = [NSDateFormatter localizedStringFromDate:transaction.startTime dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    [self.requestRequestTimeLabel setText:sentDate];
    
    NSString *totalDuration = [FLEXUtility stringFromRequestDuration:transaction.duration];
    [self.requestDurationLabel setText:totalDuration];
    
    // Header
    [self.headerLabel setAttributedText:[self headerLabelFromRequest:transaction.request]];
    
    // Request body
    
    // Response body
    NSData *responseData = [[FLEXNetworkRecorder defaultRecorder] cachedResponseBodyForTransaction:transaction];
    NSString *responseBody = [self jsonFromResponseData:responseData];
    [self.responseBodyLabel setText:responseBody];
}

- (NSAttributedString *)headerLabelFromRequest:(NSURLRequest *)request {
    NSMutableAttributedString *headerAttributesString = [[NSMutableAttributedString alloc] init];
    NSDictionary<NSAttributedStringKey,id> *objAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                                              NSForegroundColorAttributeName: [UIColor darkTextColor],
                                                              };
    
    NSDictionary<NSAttributedStringKey,id> *keyAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                                                };
    NSDictionary<NSString *, NSString *> *headerFields = request.allHTTPHeaderFields;
    [headerFields enumerateKeysAndObjectsUsingBlock:^(NSString* _Nonnull key, NSString* _Nonnull obj, BOOL * _Nonnull stop) {
        NSAttributedString *objAttributesString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   ", obj] attributes:objAttributes];
        [headerAttributesString appendAttributedString:objAttributesString];
        NSAttributedString *keyAttributesString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", key] attributes:keyAttributes];
        [headerAttributesString appendAttributedString:keyAttributesString];
    }];
    
    return headerAttributesString;
}

- (NSString *)jsonFromResponseData:(NSData *)data {
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSData *prettyJSONData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
    NSString *prettyPrintedString = [[NSString alloc] initWithData:prettyJSONData encoding:NSUTF8StringEncoding];
    
    if (error) {
        return [error localizedDescription];
    }
    return prettyPrintedString;
}

@end
