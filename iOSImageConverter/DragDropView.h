//
//  DragDropView.h
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DragDropViewDelegate;

@interface DragDropView : NSView
@property (weak) id<DragDropViewDelegate> delegate;
@end

@protocol DragDropViewDelegate <NSObject>
-(void)dragDropViewFileList:(NSArray*)fileList;
@end
