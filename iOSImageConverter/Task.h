//
//  Task.h
//  TinyPng
//
//  Created by Jiang Jacob on 8/5/14.
//  Copyright (c) 2014 Jacob Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, TaskStatus){
    TaskStatusWait = 0,
    TaskStatusDoing = 1,
    TaskStatusError = 2,
    TaskStatusComplete = 3
};

typedef NS_ENUM(NSUInteger, TaskNeed){
    TaskNeed1x = 1 << 1,
    TaskNeed2x = 1 << 2,
    TaskNeed3x = 1 << 3
};

@interface Task : NSObject

@property (nonatomic,strong)        NSString *fileName;
@property (nonatomic,strong)        NSString *originalURL;
@property (nonatomic,strong)        NSString *remoteURL;

@property (nonatomic,strong)        NSString *output;
@property (nonatomic,strong)        NSString *type;

@property (nonatomic,assign)        CGFloat  height;
@property (nonatomic,assign)        CGFloat  width;
@property (nonatomic,assign)        CGFloat  compressRatio;

@property (nonatomic,assign)        TaskStatus Status;
@property (nonatomic,assign)        TaskStatus statuesUpload;
@property (nonatomic,assign)        TaskStatus statuesDown1x;
@property (nonatomic,assign)        TaskStatus statuesDown2x;
@property (nonatomic,assign)        TaskStatus statuesDown3x;

@property (nonatomic,assign)        TaskNeed taskNeed;
@end
