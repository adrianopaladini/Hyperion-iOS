//
//  URLRequestDetailViewController.h
//  NetworkInspector
//
//  Created by Andy Do on 6/9/19.
//  Copyright © 2019 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLEXNetworkTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTransactionDetailViewController : UIViewController

- (instancetype)initWithTransaction:(FLEXNetworkTransaction *)transaction;

@end

NS_ASSUME_NONNULL_END
