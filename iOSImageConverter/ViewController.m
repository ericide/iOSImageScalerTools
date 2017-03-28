//
//  ViewController.m
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import "ViewController.h"
#import "ImageTools.h"
#import "WebPImage.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
-(void)dragDropViewFileList:(NSArray*)fileList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self handleFiles:fileList];
    });
}
-(void)handleFiles:(NSArray*)fileList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.stringValue = @"生成中...";
    });
    for (int i = 0; i < fileList.count; i++) {

        NSString * filePath = fileList[i];
        NSString * exestr = [filePath lastPathComponent];
        NSString *fileName = [exestr stringByDeletingPathExtension];
        NSString * type = [filePath pathExtension];
        
        
        

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData * imageData = [fileManager contentsAtPath:filePath];
        CGImageRef imageRef3x = nil;
        NSSize imageSize = NSMakeSize(0, 0);
        
        if (([type isEqualToString:@"png"]) || ([type isEqualToString:@"jpg"]) ) {
            NSImage * pendingImage = [[NSImage alloc]initWithData:imageData];
            imageSize = pendingImage.size;
            imageRef3x = createCGImageRefFromNSImage(pendingImage);
        }
        
        if (([type isEqualToString:@"webp"])) {
            imageRef3x = CreateImageForData(imageData);
            
            imageSize.height = CGImageGetHeight(imageRef3x);
            imageSize.width = CGImageGetWidth(imageRef3x);
        }
        
        if (imageRef3x == nil) {
            continue;
        }
        
        
        NSArray<NSString *> * arr = [filePath componentsSeparatedByString:@"/"];
        NSMutableString * address = [[NSMutableString alloc]init];
        for (int i = 0 ; i < arr.count - 1; i++) {
            [address appendFormat:@"%@/",arr[i]];
        }
        
        
//        NSImage * image2x = [self creat2x:image];
        

        
        [address appendString:@"iOSImageConverter"];
        [fileManager createDirectoryAtPath:address attributes:nil];
        
        if (self.x3boxBtn.enabled) {
            NSString * extraStr = self.x3textField.stringValue;
            NSString *pathOf3x = [NSString stringWithFormat:@"%@/%@%@.png",address,fileName,extraStr];
            saveImagepng(imageRef3x, pathOf3x);
        }
        if (self.x2boxBtn.enabled) {
            NSString * extraStr = self.x2textField.stringValue;
            CGImageRef imageRef2x = createScaleImageByXY(imageRef3x,imageSize.width*2/3, imageSize.height*2/3);
            NSString *pathOf2x = [NSString stringWithFormat:@"%@/%@%@.png",address,fileName,extraStr];
            saveImagepng(imageRef2x, pathOf2x);
        }
        
        
        
//        CGImageRef imageRef = createScaleImageByXY(imageRef3x,imageSize.width/3, imageSize.height/3);
//        NSString *pathOf1x = [NSString stringWithFormat:@"%@/%@.png",address,fileName];
//        saveImagepng(imageRef, pathOf1x);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress.doubleValue = (i + 1.0) * 100 /(float)fileList.count;
        });
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.stringValue = @"完成！";
    });
}

@end
