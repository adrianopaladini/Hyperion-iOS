//
//  NetworkInspectorPluginModule.h
//  NetworkInspector
//
//  Created by Andy Do on 6/9/19.
//  Copyright © 2019 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPPluginModule.h"
#import "HYPOverlayPluginModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkInspectorPluginModule : HYPOverlayPluginModule<HYPOverlayPluginViewProvider>

@end

NS_ASSUME_NONNULL_END
