//  Copyright (c) 2017 WillowTree, Inc.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HYPLayerAttributesProvider.h"
#import "HYPUIHelpers.h"
#import "HYPKeyValueInspectorAttribute.h"

@implementation HYPLayerAttributesProvider

- (NSString *)attributesSectionName {
    return @"CALayer";
}

- (NSArray<id<HYPInspectorAttribute>> *)fullAttributesForView:(UIView *)view {
    NSMutableArray<id<HYPInspectorAttribute>> *layerAttributes = [[NSMutableArray alloc] init];
    CALayer *layer = view.layer;
    if (layer == NULL) {
        return layerAttributes;
    }
    
    // Shadow
    if (layer.shadowOpacity > 0) {
        NSString *shadowColorString = [HYPUIHelpers hexTextForCGColor:layer.shadowColor];
        HYPKeyValueInspectorAttribute *shadowColorAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Shadow Color" value:shadowColorString];
        [layerAttributes addObject:shadowColorAttribute];

        HYPKeyValueInspectorAttribute *shadowOpacityAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Shadow Opacity" value:[NSString stringWithFormat:@"%.1f", layer.shadowOpacity]];
        [layerAttributes addObject:shadowOpacityAttribute];

        HYPKeyValueInspectorAttribute *shadowOffsetAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Shadow Offset" value:[NSString stringWithFormat:@"W:%.1f H:%.1f", layer.shadowOffset.width, layer.shadowOffset.height]];
        [layerAttributes addObject:shadowOffsetAttribute];

        HYPKeyValueInspectorAttribute *shadowRadiusAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Shadow Radius" value:[NSString stringWithFormat:@"%.1f", layer.shadowRadius]];
        [layerAttributes addObject:shadowRadiusAttribute];
    }

    // Cornor radius
    if (layer.cornerRadius > 0) {
        HYPKeyValueInspectorAttribute *cornerRadius = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Cornor Radius" value:[NSString stringWithFormat:@"%.1f", layer.cornerRadius]];
        [layerAttributes addObject:cornerRadius];
    }

    return layerAttributes;
}

- (UIView *)previewForView:(UIView *)view {
    return nil;
}

- (Class)providerClass {
    return [CALayer class];
}

@end
