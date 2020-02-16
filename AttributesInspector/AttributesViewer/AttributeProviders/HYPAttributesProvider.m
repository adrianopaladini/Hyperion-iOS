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

#import "HYPAttributesProvider.h"
#import "HYPViewPreview.h"
#import "HYPKeyValueInspectorAttribute.h"
#import "HYPUIHelpers.h"

@interface HYPAttributesProvider()
@property (nonatomic) Class providingClass;
@end
@implementation HYPAttributesProvider

-(NSString *)attributesSectionName
{
    return @"UIView";
}

-(UIView *)previewForView:(UIView *)view
{
    return [[HYPViewPreview alloc] initWithPreviewTargetView:view];
}

-(Class)providerClass
{
    return [UIView class];
}

-(NSArray<id<HYPInspectorAttribute>> *)fullAttributesForView:(UIView *)view
{
    NSMutableArray<id<HYPInspectorAttribute>> *viewAttributes = [[NSMutableArray alloc] init];

    NSString *rgbbackgroundColor = [HYPUIHelpers rgbTextForColor:view.backgroundColor];
    HYPKeyValueInspectorAttribute *rgbbackgroundColorAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"RGBA Background Color" value:rgbbackgroundColor ? rgbbackgroundColor : @"--"];
    [viewAttributes addObject:rgbbackgroundColorAttribute];

    NSString *hexBackgroundColor = [HYPUIHelpers hexTextForColor:view.backgroundColor];
    HYPKeyValueInspectorAttribute *hexBackgroundColorAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Hex Background Color" value:hexBackgroundColor ? hexBackgroundColor : @"--"];
    [viewAttributes addObject:hexBackgroundColorAttribute];

    HYPKeyValueInspectorAttribute *relativeFrame = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Relative Frame" value:[NSString stringWithFormat:@"X:%.1f Y:%.1f W:%.1f H:%.1f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height]];
    [viewAttributes addObject:relativeFrame];

    HYPKeyValueInspectorAttribute *contentModeAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Content Mode" value:[self contentModeDescription:view]];
    [viewAttributes addObject:contentModeAttribute];

    if (view.alpha < 1.0) {
        HYPKeyValueInspectorAttribute *alphaAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Alpha" value:[NSString stringWithFormat:@"%.2f", view.alpha]];
        [viewAttributes addObject:alphaAttribute];
    }

    [viewAttributes addObjectsFromArray:[self colorAttributesForView:view]];

    [viewAttributes addObjectsFromArray:[self accessibilityAttributesForView:view]];

    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(HYPKeyValueInspectorAttribute * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject.value isEqualToString:@"--"])
        {
            return NO;
        }
        return YES;
    }];

    return [viewAttributes filteredArrayUsingPredicate:filter];
}

// MARK: - Accessibility Inspector

-(NSArray<id<HYPInspectorAttribute>> *)accessibilityAttributesForView:(UIView *)view {
    NSMutableArray<id<HYPInspectorAttribute>> *viewAttributes = [[NSMutableArray alloc] init];

    HYPKeyValueInspectorAttribute *accessibilityLabelAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility Label" value:view.accessibilityLabel ? view.accessibilityLabel : @"--"];
    [viewAttributes addObject:accessibilityLabelAttribute];

    HYPKeyValueInspectorAttribute *accessbilityValueAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility Value" value:view.accessibilityValue ? view.accessibilityValue : @"--"];
    [viewAttributes addObject:accessbilityValueAttribute];

    HYPKeyValueInspectorAttribute *accessibilityHintAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility Hint" value:view.accessibilityHint ? view.accessibilityHint : @"--" ];
    [viewAttributes addObject:accessibilityHintAttribute];

    HYPKeyValueInspectorAttribute *accessibilityIDAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Accessibility ID" value:view.accessibilityIdentifier ? view.accessibilityIdentifier : @"--" ];
    [viewAttributes addObject:accessibilityIDAttribute];

    return viewAttributes;
}

// MARK: - Color Inspector

-(NSArray<id<HYPInspectorAttribute>> *)colorAttributesForView:(UIView *)view {
    NSMutableArray<id<HYPInspectorAttribute>> *viewAttributes = [[NSMutableArray alloc] init];

    NSString *tintColorValue = [HYPUIHelpers rgbTextForColor:view.tintColor];
    HYPKeyValueInspectorAttribute *tintColorAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Tint Color" value:tintColorValue];
    [viewAttributes addObject:tintColorAttribute];

    if (view.backgroundColor != NULL) {
        NSString *backgroundColorValue = [HYPUIHelpers rgbTextForColor:view.backgroundColor];
        HYPKeyValueInspectorAttribute *backgroundColorAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Background Color" value:backgroundColorValue];
        [viewAttributes addObject:backgroundColorAttribute];
    }

    return viewAttributes;
}

// MARK: - Attribute Description

- (NSString *)contentModeDescription:(UIView *)view {
    if (view == NULL) {
        return @"--";
    }

    switch (view.contentMode) {

        case UIViewContentModeScaleToFill:
            return @"ScaleToFill";
            break;
        case UIViewContentModeScaleAspectFit:
            return @"ScaleAspectFit";
            break;
        case UIViewContentModeScaleAspectFill:
            return @"ScaleAspectFill";
            break;
        case UIViewContentModeRedraw:
            return @"Redraw";
            break;
        case UIViewContentModeCenter:
            return @"Center";
            break;
        case UIViewContentModeTop:
            return @"Top";
            break;
        case UIViewContentModeBottom:
            return @"Bottom";
            break;
        case UIViewContentModeLeft:
            return @"Left";
            break;
        case UIViewContentModeRight:
            return @"Right";
            break;
        case UIViewContentModeTopLeft:
            return @"TopLeft";
            break;
        case UIViewContentModeTopRight:
            return @"TopRight";
            break;
        case UIViewContentModeBottomLeft:
            return @"BottomLeft";
            break;
        case UIViewContentModeBottomRight:
            return @"BottomRight";
            break;
    }
}

@end
