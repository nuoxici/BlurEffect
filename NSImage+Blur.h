//
//  NSImage+Blur.h
//  Test
//
//  Created by Nuoxici on 2019/4/3.
//  Copyright © 2019 Nuoxici. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (Blur)
- (NSImage *)blurEffectWithSize:(CGSize)aSize OfRadius:(CGFloat)aRadius;
@end

NS_ASSUME_NONNULL_END
