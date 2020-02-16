//
//  HYPImageViewAttributesProvider.m
//  AttributesInspector
//
//  Created by Do Xuan Quyen on 2/16/20.
//  Copyright © 2020 WillowTree. All rights reserved.
//

#import "HYPImageViewAttributesProvider.h"
#import "HYPTextPreview.h"
#import "HYPUIHelpers.h"
#import "HYPKeyValueInspectorAttribute.h"
#import "HYPAttributedStringAttributeProvider.h"

@implementation HYPImageViewAttributesProvider

- (NSString *)attributesSectionName
{
    return @"UIImageView";
}

- (NSArray<id<HYPInspectorAttribute>> *)fullAttributesForView:(UIView *)view
{
    UIImageView *imageView = (UIImageView *)view;

    NSAssert([imageView isKindOfClass:[self providerClass]], @"Provider view mismatch");

    NSMutableArray<id<HYPInspectorAttribute>> *viewAttributes = [[NSMutableArray alloc] init];

    if (imageView.image != NULL) {
        CGSize imageSize = imageView.image.size;
        NSString *imageSizeValue = [NSString stringWithFormat:@"W:%.1f H:%.1f", imageSize.width, imageSize.height];
        HYPKeyValueInspectorAttribute *imageSizeAttribute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Image Size" value:imageSizeValue];
        [viewAttributes addObject:imageSizeAttribute];

        HYPKeyValueInspectorAttribute *imageScaleAttrubute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Scale" value:[NSString stringWithFormat:@"%.1f", imageView.image.scale]];
        [viewAttributes addObject:imageScaleAttrubute];

        HYPKeyValueInspectorAttribute *renderingModeAttrubute = [[HYPKeyValueInspectorAttribute alloc] initWithKey:@"Rendering mode" value:[self renderingModeDescription:imageView.image]];
        [viewAttributes addObject:renderingModeAttrubute];
    }

    return viewAttributes;
}

- (UIView *)previewForView:(UIView *)view
{
    return nil;
}

- (Class)providerClass
{
    return [UIImageView class];
}

- (NSString *)renderingModeDescription:(UIImage *)image {
    switch (image.renderingMode) {
        case UIImageRenderingModeAutomatic:
            return @"Automatic";
            break;

        case UIImageRenderingModeAlwaysTemplate:
            return @"AlwaysTemplate";
            break;

        case UIImageRenderingModeAlwaysOriginal:
            return @"AlwaysOriginal";
            break;
    }
}

@end
