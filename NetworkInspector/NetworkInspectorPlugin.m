//
//  NetworkInspectorPlugin.m
//  NetworkInspector
//
//  Created by Andy Do on 6/9/19.
//  Copyright © 2019 WillowTree. All rights reserved.
//

#import "NetworkInspectorPlugin.h"
#import "NetworkInspectorPluginModule.h"

@implementation NetworkInspectorPlugin

+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    return [[NetworkInspectorPluginModule alloc] initWithExtension:pluginExtension];
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end
