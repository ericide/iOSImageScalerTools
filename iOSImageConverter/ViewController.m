//
//  ViewController.m
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import "ViewController.h"
#import "ImageTools.h"

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
        NSArray<NSString *> * arr = [filePath componentsSeparatedByString:@"/"];
        NSMutableString * address = [[NSMutableString alloc]init];
        for (int i = 0 ; i < arr.count - 1; i++) {
            [address appendFormat:@"%@/",arr[i]];
        }
        NSString *fileName = [[[arr lastObject] componentsSeparatedByString:@"."]firstObject];
        NSString * type = [[filePath componentsSeparatedByString:@"."] lastObject];
        type = [type lowercaseString];
        
        if ((![type isEqualToString:@"png"]) && (![type isEqualToString:@"jpg"])) {
            NSLog(@"该文件不是图片类型");
            continue;
        }
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData * imageData = [fileManager contentsAtPath:filePath];
        NSImage * image = [[NSImage alloc]initWithData:imageData];
        
        NSLog(@"%@ %f,%f",address,image.size.height,image.size.width);
        
//        NSImage * image2x = [self creat2x:image];
        CGImageRef imageRef3x = createCGImageRefFromNSImage(image);
        CGImageRef imageRef2x = createScaleImageByXY(imageRef3x,image.size.width*2/3, image.size.height*2/3);
        CGImageRef imageRef = createScaleImageByXY(imageRef3x,image.size.width/3, image.size.height/3);
        
        [address appendString:@"iOSImageConverter"];
        [fileManager createDirectoryAtPath:address attributes:nil];
        
        NSString *pathOf2x = [NSString stringWithFormat:@"%@/%@@2x.%@",address,fileName,type];
        saveImagepng(imageRef2x, pathOf2x);
        
        NSString *pathOf3x = [NSString stringWithFormat:@"%@/%@@3x.%@",address,fileName,type];
        saveImagepng(imageRef3x, pathOf3x);
        
        NSString *pathOf1x = [NSString stringWithFormat:@"%@/%@.%@",address,fileName,type];
        saveImagepng(imageRef, pathOf1x);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress.doubleValue = (i + 1.0) * 100 /(float)fileList.count;
        });
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.stringValue = @"完成！";
    });
}

@end
