//
//  Task.h
//  TinyPng
//
//  Created by Jiang Jacob on 8/5/14.
//  Copyright (c) 2014 Jacob Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, TaskStatus){
    TaskStatusWait = 1,
    TaskStatusDoing = 2,
    TaskStatusError = 3,
    TaskStatusComplete = 4
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

@end
