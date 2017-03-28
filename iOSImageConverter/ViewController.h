//
//  ViewController.h
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragDropView.h"

@interface ViewController : NSViewController<DragDropViewDelegate>
@property (strong) IBOutlet DragDropView *contentView;

@property (weak) IBOutlet NSProgressIndicator *progress;

@property (weak) IBOutlet NSTextField *tipLabel;


@property (weak) IBOutlet NSTextField *x2textField;
@property (weak) IBOutlet NSButton *x2boxBtn;

@property (weak) IBOutlet NSTextField *x3textField;
@property (weak) IBOutlet NSButton *x3boxBtn;

@end

