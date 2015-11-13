//
//  Utilities.h
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import <Cocoa/Cocoa.h>


void releaseMyContextData(CGContextRef content);
CGContextRef MyCreateBitmapContext (int pixelsWide, int pixelsHigh);



//NSImage to CGImage
CGImageRef createCGImageRefFromNSImage(NSImage* image);

//这个是苹果官方的标准写法
NSImage* createNSImageFromCGImageRef2(CGImageRef image);
//CGImage to NSImage
NSImage* createNSImageFromCGImageRef(CGImageRef image);

//缩放图片 按宽高 (既新的返回图片的宽变成width 高变成height)
CGImageRef createScaleImageByXY(CGImageRef image, float width, float height);

//缩放图片 按比例
CGImageRef createScaleImageByRatio(NSImage *image, float fratio);

BOOL saveImagepng(CGImageRef imageRef, NSString *strpath);
BOOL saveImagejpg(CGImageRef imageRef, NSString *strpath);
