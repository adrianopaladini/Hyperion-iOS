//
//  NetworkInspectorPluginModule.m
//  NetworkInspector
//
//  Created by Andy Do on 6/9/19.
//  Copyright © 2019 WillowTree. All rights reserved.
//

#import "NetworkInspectorPluginModule.h"
#import "NetworkTransactionsViewController.h"
#import "HYPPluginMenuItem.h"
#import "HyperionManager.h"
#import "FLEXNetworkObserver.h"

@interface NetworkInspectorPluginModule() <HYPPluginMenuItemDelegate>

@end

@implementation NetworkInspectorPluginModule {
    UINavigationController *navigationController;
}

@synthesize pluginMenuItem = _pluginMenuItem;

- (nonnull instancetype)initWithExtension:(nonnull id<HYPPluginExtension>)extension {
    self = [super initWithExtension:extension];
    if (self) {
        NetworkTransactionsViewController *viewController = [[NetworkTransactionsViewController alloc] init];
        
        navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        viewController.navigationItem.leftBarButtonItem = doneBarButton;
        
        UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
        viewController.navigationItem.rightBarButtonItem = settingsBarButton;
        
        viewController.navigationItem.title = [self pluginMenuItemTitle];
        
        [FLEXNetworkObserver setEnabled:YES];
    }
    
    return self;
}

-(UIView<HYPPluginMenuItem> *)pluginMenuItem {
    if (_pluginMenuItem) {
        return _pluginMenuItem;
    }
    
    HYPPluginMenuItem *pluginItem = [[HYPPluginMenuItem alloc] init];
    pluginItem.delegate = self;
    [pluginItem bindWithTitle:[self pluginMenuItemTitle] image:[self pluginMenuItemImage]];
    
    _pluginMenuItem = pluginItem;
    
    return _pluginMenuItem;
}

- (nonnull UIImage *)pluginMenuItemImage {
    return [UIImage imageNamed:@"internet" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:NULL];
}

- (nonnull NSString *)pluginMenuItemTitle {
    return @"Network Inspector";
}

- (BOOL)shouldHideDrawerOnSelection {
    return YES;
}

- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    bool shouldActivate = ![self active];
    
    if (shouldActivate) {
        self.extension.overlayContainer.overlayModule = self;
    } else {
        self.extension.overlayContainer.overlayModule = nil;
    }
    
    if ([self shouldHideDrawerOnSelection]) {
        [[HyperionManager sharedInstance] togglePluginDrawer];
    }
}

- (BOOL)active {
    return self.extension.overlayContainer.overlayModule == self;
}

- (void)activateOverlayPluginViewWithContext:(nonnull UIView *)context {
    [super activateOverlayPluginViewWithContext:context];
    UIViewController *root = self.extension.attachedWindow.rootViewController;
    [[self topViewController:root] presentViewController:navigationController animated:YES completion:NULL];
}

- (void)deactivateOverlayPluginView {
    [_pluginMenuItem setSelected:NO animated:YES];
    [navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
- (UIViewController *)topViewController:(UIViewController *)baseViewController {
    UIViewController *presentedViewController = [baseViewController presentedViewController];
    if (presentedViewController) {
        return [self topViewController:presentedViewController];
    }
    return baseViewController;
}

- (void)done {
    self.extension.overlayContainer.overlayModule = nil;
}

- (void)showSettings {
    
}

@end
