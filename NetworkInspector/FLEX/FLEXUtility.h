//
//  FLEXUtility.h
//  Flipboard
//
//  Created by Ryan Olson on 4/18/14.
//  Copyright (c) 2014 Flipboard. All rights reserved.
//

#import <Availability.h>
#import <AvailabilityInternal.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define FLEXFloor(x) (floor([[UIScreen mainScreen] scale] * (x)) / [[UIScreen mainScreen] scale])

#if defined(__IPHONE_11_0)
#define FLEX_AT_LEAST_IOS11_SDK (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
#else
#define FLEX_AT_LEAST_IOS11_SDK NO
#endif

@interface FLEXUtility : NSObject
+ (UIImage *)thumbnailedImageWithMaxPixelDimension:(NSInteger)dimension fromImageData:(NSData *)data;
+ (NSString *)stringFromRequestDuration:(NSTimeInterval)duration;
+ (NSString *)statusCodeStringFromURLResponse:(NSURLResponse *)response;
+ (BOOL)isErrorStatusCodeFromURLResponse:(NSURLResponse *)response;
+ (NSDictionary<NSString *, id> *)dictionaryFromQuery:(NSString *)query;
+ (NSString *)prettyJSONStringFromData:(NSData *)data;
+ (BOOL)isValidJSONData:(NSData *)data;

// Swizzling utilities

+ (SEL)swizzledSelectorForSelector:(SEL)selector;
+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls;
+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector;
+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;

@end
