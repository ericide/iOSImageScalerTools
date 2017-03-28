//
//  ViewController.h
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragDropView.h"

typedef NS_ENUM(NSUInteger, ImageType){
    Download1x = 1,
    Download2x = 2,
    Download3x = 3,
};

@interface ViewController : NSViewController<DragDropViewDelegate,NSTableViewDataSource,NSTableViewDelegate>
@property (strong) IBOutlet DragDropView *contentView;

@end

