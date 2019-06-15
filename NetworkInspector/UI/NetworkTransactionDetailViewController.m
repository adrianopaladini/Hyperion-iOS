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
#import "TransactionDetailCell.h"

@interface NetworkTransactionDetailViewController ()

@property (copy) NSArray<NSDictionary<NSString *, NSString *> *> *transactionComponents;
@property (copy) NSArray<NSString *> *headerComponents;

@end

@implementation NetworkTransactionDetailViewController

FLEXNetworkTransaction *_transaction;

- (instancetype)initWithTransaction:(FLEXNetworkTransaction *)transaction {
    self = [super initWithStyle:UITableViewStylePlain];
    
    _transaction = transaction;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureView];
    [self configureTableView];
    [self setTransaction:_transaction];
}

- (void)configureView {
    self.navigationItem.title = @"Transaction";
}

- (void)configureTableView {
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView registerClass:TransactionDetailCell.class forCellReuseIdentifier:NSStringFromClass(TransactionDetailCell.class)];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
}

- (void)setTransaction:(FLEXNetworkTransaction *)transaction {
    [self buildTableViewSectionsFrom:transaction];
    [self.tableView reloadData];
}

#pragma mark - Builder
- (void)buildTableViewSectionsFrom:(FLEXNetworkTransaction *)transaction {
    NSMutableArray<NSDictionary<NSString *, NSString *> *> *components = [[NSMutableArray alloc] init];
    NSMutableArray<NSString *> *headers = [[NSMutableArray alloc] init];
    
    [components addObject:[self overviewSectionFrom:transaction]];
    [headers addObject:@"Overview"];
    
    NSDictionary *httpHeaderFields = transaction.request.allHTTPHeaderFields;
    if (httpHeaderFields) {
        [components addObject:httpHeaderFields];
        [headers addObject:@"Request header"];
    }
    
    NSString *requestJSON = [self requestJSONFrom:transaction];
    if (requestJSON) {
        [components addObject:@{@"": requestJSON}];
        [headers addObject:@"Request body"];
    }
    
    NSString *responseJSON = [self responseJSONFrom:transaction];
    if (responseJSON) {
        [components addObject:@{@"": responseJSON}];
        [headers addObject:@"Response body"];
    }
    
    self.transactionComponents = components;
    self.headerComponents = headers;
}

- (NSDictionary<NSString *, NSString *> * _Nonnull )overviewSectionFrom:(FLEXNetworkTransaction *)transaction {
    NSString *httpResponseCode = [FLEXUtility statusCodeStringFromURLResponse:transaction.response];
    if ([httpResponseCode isEqual:[NSNull null]] || httpResponseCode == nil) {
        httpResponseCode = @"";
    }
    NSString *sentDate = [NSDateFormatter localizedStringFromDate:transaction.startTime dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *totalDuration = [FLEXUtility stringFromRequestDuration:transaction.duration];
    
    return @{@"URL": transaction.request.URL.absoluteString,
             @"Method": transaction.request.HTTPMethod,
             @"Response code": httpResponseCode,
             @"Request start time": sentDate,
             @"Request ID": transaction.requestID,
             @"Duration": totalDuration
             };
}

- (NSString * _Nullable )requestJSONFrom:(FLEXNetworkTransaction *)transaction {
    if (transaction.cachedRequestBody) {
        return [FLEXUtility prettyJSONStringFromData:transaction.cachedRequestBody];
    }
    
    return NULL;
}

- (NSString * _Nullable )responseJSONFrom:(FLEXNetworkTransaction *)transaction {
    NSData *responseData = [[FLEXNetworkRecorder defaultRecorder] cachedResponseBodyForTransaction:transaction];
    if (responseData) {
        return [FLEXUtility prettyJSONStringFromData:responseData];
    }
    
    return NULL;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are Overview, Request header, Request body, Response body
    return [self.transactionComponents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionComponents = [self.transactionComponents objectAtIndex:section];
    return [sectionComponents.allKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TransactionDetailCell.class) forIndexPath:indexPath];
    
    NSDictionary<NSString *, NSString *> *sectionComponents = [self.transactionComponents objectAtIndex:indexPath.section];
    NSString *key = [sectionComponents.allKeys objectAtIndex:indexPath.row];
    NSString *value = [sectionComponents objectForKey:key];
    
    [cell setTitle:key detailTitle:value];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 36)];
    [header setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:244.0/255.0 blue:1.0 alpha:1.0]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:137.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [titleLabel setText:[self.headerComponents objectAtIndex:section]];
    [header addSubview:titleLabel];
    
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[title]-16-|" options:0 metrics:NULL views:@{@"title": titleLabel}]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[title]-8-|" options:0 metrics:NULL views:@{@"title": titleLabel}]];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        NSDictionary<NSString *, NSString *> *sectionComponents = [self.transactionComponents objectAtIndex:indexPath.section];
        NSString *key = [sectionComponents.allKeys objectAtIndex:indexPath.row];
        NSString *value = [sectionComponents objectForKey:key];
        
        [[UIPasteboard generalPasteboard] setString:value];
    }
}

@end
