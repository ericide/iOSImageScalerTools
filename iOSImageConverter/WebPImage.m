//
//  WebPImage.m
//  WebP
//
//  Created by Dmitry Chestnykh on 5/3/11.
//  Copyright 2011 Coding Robots. All rights reserved.
//

#import "WebPImage.h"
#import "webp/decode.h"

CGImageRef CreateImageForData(NSData * fileData)
{

     WebPDecoderConfig config;
    if (!WebPInitDecoderConfig(&config)) {
         NSLog(@"(WebPInitDecoderConfig) cannot get WebP image data for %@");
        return NULL;
    }

    if (WebPGetFeatures([fileData bytes], [fileData length], &config.input) != VP8_STATUS_OK) {
        NSLog(@"(WebPGetFeatures) cannot get WebP image data for %@");
        return NULL;
    }

    config.output.colorspace = MODE_rgbA; // premultiplied alpha

    if (WebPDecode([fileData bytes], [fileData length], &config) != VP8_STATUS_OK) {
        NSLog(@"(WebPDecode) cannot get WebP image data for %@");
        return NULL;
    }
  
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                     config.output.u.RGBA.rgba,
                                                     config.input.width,
                                                     config.input.height,
                                                     8, // bitsPerComponent
                                                     4*config.input.width, // bytesPerRow
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedLast);
    WebPFreeDecBuffer(&config.output);
    CGColorSpaceRelease(colorSpace);
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    return cgImage;
}
