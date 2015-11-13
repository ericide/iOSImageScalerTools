//
//  Utilities.m
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import "ImageTools.h"

void releaseMyContextData(CGContextRef content){
    void *imgdata =CGBitmapContextGetData(content);
    CGContextRelease(content);
    if (imgdata) {
        free(imgdata);
    }
}

CGContextRef MyCreateBitmapContext (int pixelsWide,
                                    int pixelsHigh)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    GLubyte*bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);//CGColorSpaceCreateDeviceRGB();//
    
    //z这里初始化用malloc和calloc都可以 (注意:malloc只能分配内存 初始化所分配的内存空间 calloc则可以)
    //在此需要特别注意的是  第二个参数传0进去  如果传比较大的数值进去的话  则会内存泄漏 比如传8之类的就会出现大的泄漏问题
    /*如果调用成功,函数malloc()和函数calloc()都
     将返回所分配的内存空间的首地址。
     函数malloc()和函数calloc()的主要区别是前
     者不能初始化所分配的内存空间,而后者能。如
     果由malloc()函数分配的内存空间原来没有被
     使用过，则其中的每一位可能都是0;反之,如果
     这部分内存曾经被分配过,则其中可能遗留有各
     种各样的数据。也就是说，使用malloc()函数
     的程序开始时(内存空间还没有被重新分配)能
     正常进行,但经过一段时间(内存空间还已经被
     重新分配)可能会出现问题
     函数calloc()会将所分配的内存空间中的每一
     位都初始化为零,也就是说,如果你是为字符类
     型或整数类型的元素分配内存,那麽这些元素将
     保证会被初始化为0;如果你是为指针类型的元
     素分配内存,那麽这些元素通常会被初始化为空
     指针;如果你为实型数据分配内存,则这些元素
     会被初始化为浮点型的零*/
    //NSLog(@"%lu", sizeof(GLubyte));
    bitmapData = (GLubyte*)calloc(bitmapByteCount,sizeof(GLubyte));//or malloc(bitmapByteCount);//
    
    if (bitmapData == NULL) {
        fprintf(stderr, "Memory not allocated!");
        return NULL;
    }
    
    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast);
    if (context == NULL) {
        free(bitmapData);
        fprintf(stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease(colorSpace);
    return context;
}




BOOL saveImagepng(CGImageRef imageRef, NSString *strpath)
{
    NSString *finalPath = [NSString stringWithString:strpath];
    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                  kCFAllocatorDefault,
                                                  (CFStringRef)finalPath,
                                                  kCFURLPOSIXPathStyle,
                                                  false);
    CGImageDestinationRef dest = CGImageDestinationCreateWithURL(url, CFSTR("public.png"), 1,NULL);
    assert(dest);
    CGImageDestinationAddImage(dest, imageRef, NULL);
    assert(dest);
    if (dest == NULL) {
        NSLog(@"CGImageDestinationCreateWithURL failed");
    }
    //NSLog(@"%@", dest);
    assert(CGImageDestinationFinalize(dest));
    
    //这三句话用来释放对象
    CFRelease(dest);
    //CGImageRelease(imageRef);
    CFRelease(url);
    return YES;
}

BOOL saveImagejpg(CGImageRef imageRef, NSString *strpath)
{
    NSString *finalPath = [NSString stringWithString:strpath];
    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                  kCFAllocatorDefault,
                                                  (CFStringRef)finalPath,
                                                  kCFURLPOSIXPathStyle,
                                                  false);
    CGImageDestinationRef dest = NULL;
    dest = CGImageDestinationCreateWithURL(url, CFSTR("public.jpeg"), 1, NULL);
    
    assert(dest);
    
    CFMutableDictionaryRef  mSaveMetaAndOpts = CFDictionaryCreateMutable(nil, 0,
                                                                         &kCFTypeDictionaryKeyCallBacks,  &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(mSaveMetaAndOpts, kCGImageDestinationLossyCompressionQuality,
                         (__bridge const void *)([NSNumber numberWithFloat:0.8]));
    
    CGImageDestinationAddImage(dest, imageRef, (CFDictionaryRef)mSaveMetaAndOpts);
    
    
    CFRelease(mSaveMetaAndOpts);
    
    //CGImageDestinationAddImage(dest, imageRef, NULL);
    assert(dest);
    if (dest == NULL) {
        NSLog(@"CGImageDestinationCreateWithURL failed");
    }
    //NSLog(@"%@", dest);
    assert(CGImageDestinationFinalize(dest));
    
    //这三句话用来释放对象
    CFRelease(dest);
    //CGImageRelease(imageRef);
    //CFRetain(url);
    CFRelease(url);
    return YES;
}


CGImageRef createCGImageRefFromNSImage(NSImage* image)
{
    NSData *imageData;
    CGImageRef imageRef;
    @try {
        imageData = [image TIFFRepresentation];
        if (imageData) {
            CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
            NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     (id)kCFBooleanFalse, (id)kCGImageSourceShouldCache,
                                     (id)kCFBooleanTrue, (id)kCGImageSourceShouldAllowFloat,
                                     nil];
            
            //要用这个带option的 kCGImageSourceShouldCache指出不需要系统做cache操作 默认是会做的
            imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, (CFDictionaryRef)options);
            CFRelease(imageSource);
            return imageRef;
        }else{
            return NULL;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return NULL;
}

//这个是苹果官方的标准写法
NSImage* createNSImageFromCGImageRef2(CGImageRef image)
{
    NSImage* newImage = nil;
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
    NSBitmapImageRep*newRep = [[NSBitmapImageRep alloc] initWithCGImage:image];
    NSSize imageSize;
    // Get the image dimensions.
    imageSize.height = CGImageGetHeight(image);
    imageSize.width = CGImageGetWidth(image);
    newImage = [[NSImage alloc] initWithSize:imageSize];
    [newImage addRepresentation:newRep];
#else
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    CGContextRef imageContext = nil;
    // Get the image dimensions.
    imageRect.size.height = CGImageGetHeight(image);
    imageRect.size.width = CGImageGetWidth(image);
    // Create a new image to receive the Quartz image data.
    newImage = [[NSImage alloc] initWithSize:imageRect.size];
    [newImage lockFocus];
    // Get the Quartz context and draw.
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
    [newImage unlockFocus];
#endif
    return newImage;//[newImage autorelease];
}
NSImage* createNSImageFromCGImageRef(CGImageRef image){
    NSRect  imageRect = NSMakeRect(0, 0, 0, 0);
    CGContextRef imageContext = nil;
    NSImage *newImage = nil;
    //Get the image dimensions
    @try {
        imageRect.size.height = CGImageGetHeight(image);
        imageRect.size.width = CGImageGetWidth(image);
        
        //要转换成整数，否则在大图片时可能出现异常
        //Create a new image to receive the Quartz image data
        newImage = [[NSImage alloc] initWithSize:imageRect.size];
        [newImage lockFocus];
        
        //Get the Quartz context and draw
        imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
        //CGContextSaveGState(imageContext);
        CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
        //CGContextRestoreGState(imageContext);
        [newImage unlockFocus];
        //CFRelease(imageContext);
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return newImage;
}



CGImageRef createScaleImageByXY(CGImageRef image, float width, float height) {
    CGContextRef content = MyCreateBitmapContext(width, height);
    CGContextDrawImage(content, CGRectMake(0, 0, width, height), image);
    CGImageRef img = CGBitmapContextCreateImage(content);
    
    releaseMyContextData(content);
    
    return img;
}

CGImageRef createScaleImageByRatio(NSImage *image, float fratio){
    NSData *imageData;
    imageData = [image TIFFRepresentation];
    if (imageData) {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        
        NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 // Ask ImageIO to create a thumbnail from the file's image data, if it can't find a suitable existing thumbnail image in the file.  We could comment out the following line if only existing thumbnails were desired for some reason (maybe to favor performance over being guaranteed a complete set of thumbnails).
                                 [NSNumber numberWithBool:YES], (NSString*)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                 [NSNumber numberWithInt:[image size].width*fratio], (NSString*)kCGImageSourceThumbnailMaxPixelSize,
                                 nil];
        CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (CFDictionaryRef)options);
        CFRelease(imageSource);
        return thumbnail;
    }
    
    return nil;
}

