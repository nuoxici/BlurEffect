//
//  NSImage+Blur.m
//  Test
//
//  Created by Nuoxici  on 2019/4/3.
//  Copyright © 2019 Nuoxici. All rights reserved.
//

#import "NSImage+Blur.h"
#import <CoreImage/CIFilter.h>

@implementation NSImage (Blur)

- (NSImage *)blurEffectWithSize:(CGSize)aSize OfRadius:(CGFloat)aRadius
{
    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenFrame = mainScreen.frame;
    
    NSImage *image = self;
    
    //调整图片大小,
    //[self resizedImage:self toPixelDimensions:aSize]; 若不需要直接屏蔽
    
    [image lockFocus];
    CIImage *beginImage = [[CIImage alloc] initWithData:[image TIFFRepresentation]];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, beginImage, @"inputRadius", @(aRadius), nil];
    CIImage *output = [filter valueForKey:@"outputImage"];
    NSRect rect = NSMakeRect(0, 0, NSWidth(screenFrame), NSHeight(screenFrame));
    NSRect sourceRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    [output drawInRect:rect fromRect:sourceRect operation:NSCompositingOperationSourceOver fraction:10];
    [image unlockFocus];
    return image;
}

- (NSImage *)resizedImage:(NSImage *)sourceImage toPixelDimensions:(NSSize)newSize
{
    if (! sourceImage.isValid) return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:newSize.width
                             pixelsHigh:newSize.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    rep.size = newSize;
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    [sourceImage drawInRect:NSMakeRect(0, 0, newSize.width, newSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
    
    NSImage *newImage = [[NSImage alloc] initWithSize:newSize];
    [newImage addRepresentation:rep];
    return newImage;
}

@end
