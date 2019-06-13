//
//  NetworkInspectorViewController.m
//  NetworkInspector
//
//  Created by Andy Do on 6/9/19.
//  Copyright © 2019 WillowTree. All rights reserved.
//

#import "NetworkTransactionsViewController.h"
#import "FLEXNetworkTransaction.h"
#import "NetworkTransactionCell.h"
#import "NetworkTransactionDetailViewController.h"
#import "FLEXNetworkRecorder.h"
#import "FLEXNetworkObserver.h"
#import "HYPOverlayDebuggingWindow.h"

@interface NetworkTransactionsViewController ()

@property (nonatomic, copy) NSArray<FLEXNetworkTransaction *> *networkTransactions;
@property (nonatomic, assign) long long bytesReceived;
@property (nonatomic, assign) BOOL rowInsertInProgress;

@end

@implementation NetworkTransactionsViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewTransactionRecordedNotification:) name:kFLEXNetworkRecorderNewTransactionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTransactionUpdatedNotification:) name:kFLEXNetworkRecorderTransactionUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTransactionsClearedNotification:) name:kFLEXNetworkRecorderTransactionsClearedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkObserverEnabledStateChangedNotification:) name:kFLEXNetworkObserverEnabledStateChangedNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    [self updateTransactions];
}

- (void)configureTableView {
    self.clearsSelectionOnViewWillAppear = YES;
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(NetworkTransactionCell.class) bundle:bundle];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass(NetworkTransactionCell.class)];
    
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
}

- (void)updateTransactions {
    self.networkTransactions = [[FLEXNetworkRecorder defaultRecorder] networkTransactions];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.networkTransactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NetworkTransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NetworkTransactionCell.class) forIndexPath:indexPath];
    
    FLEXNetworkTransaction *transaction = self.networkTransactions[indexPath.row];
    [cell setTransaction:transaction];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLEXNetworkTransaction *transaction = [self.networkTransactions objectAtIndex:indexPath.row];
    NetworkTransactionDetailViewController *viewController = [[NetworkTransactionDetailViewController alloc] initWithTransaction:transaction];
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - NSNotificationCenter
- (void)handleNewTransactionRecordedNotification:(NSNotification *)notification {
    [self tryUpdateTransactions];
}

- (void)tryUpdateTransactions {
    // Let the previous row insert animation finish before starting a new one to avoid stomping.
    // We'll try calling the method again when the insertion completes, and we properly no-op if there haven't been changes.
    if (self.rowInsertInProgress) {
        return;
    }
    
    NSInteger existingRowCount = [self.networkTransactions count];
    [self updateTransactions];
    NSInteger newRowCount = [self.networkTransactions count];
    NSInteger addedRowCount = newRowCount - existingRowCount;
    
    if (addedRowCount != 0) {
        // Insert animation if we're at the top.
        if (self.tableView.contentOffset.y <= 0.0 && addedRowCount > 0) {
            [CATransaction begin];
            
            self.rowInsertInProgress = YES;
            [CATransaction setCompletionBlock:^{
                self.rowInsertInProgress = NO;
                [self tryUpdateTransactions];
            }];
            
            NSMutableArray<NSIndexPath *> *indexPathsToReload = [NSMutableArray array];
            for (NSInteger row = 0; row < addedRowCount; row++) {
                [indexPathsToReload addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [CATransaction commit];
        } else {
            // Maintain the user's position if they've scrolled down.
            CGSize existingContentSize = self.tableView.contentSize;
            [self.tableView reloadData];
            CGFloat contentHeightChange = self.tableView.contentSize.height - existingContentSize.height;
            self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + contentHeightChange);
        }
    }
}

- (void)handleTransactionUpdatedNotification:(NSNotification *)notification {
    [self updateBytesReceived];
    
    FLEXNetworkTransaction *transaction = notification.userInfo[kFLEXNetworkRecorderUserInfoTransactionKey];
    
    // Update both the main table view and search table view if needed.
    for (NetworkTransactionCell *cell in [self.tableView visibleCells]) {
        if ([cell.transaction isEqual:transaction]) {
            // Using -[UITableView reloadRowsAtIndexPaths:withRowAnimation:] is overkill here and kicks off a lot of
            // work that can make the table view somewhat unresponsive when lots of updates are streaming in.
            // We just need to tell the cell that it needs to re-layout.
            [cell setNeedsLayout];
            break;
        }
    }
}

- (void)handleTransactionsClearedNotification:(NSNotification *)notification {
    [self updateTransactions];
    [self.tableView reloadData];
}

- (void)handleNetworkObserverEnabledStateChangedNotification:(NSNotification *)notification {
    // Update the header, which displays a warning when network debugging is disabled
}

- (void)updateBytesReceived {
    long long bytesReceived = 0;
    for (FLEXNetworkTransaction *transaction in self.networkTransactions) {
        bytesReceived += transaction.receivedDataLength;
    }
    self.bytesReceived = bytesReceived;
}

@end
