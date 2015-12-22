//
//  Task.m
//  TinyPng
//
//  Created by Jiang Jacob on 8/5/14.
//  Copyright (c) 2014 Jacob Jiangwei. All rights reserved.
//

#import "Task.h"

@implementation Task
- (void)setStatuesDown1x:(TaskStatus)statuesDown1x
{
    _statuesDown1x = statuesDown1x;
    [self syncStatues];
}
- (void)setStatuesDown2x:(TaskStatus)statuesDown2x
{
    _statuesDown2x = statuesDown2x;
    [self syncStatues];
}
- (void)setStatuesDown3x:(TaskStatus)statuesDown3x
{
    _statuesDown3x = statuesDown3x;
    [self syncStatues];
}
 - (void)syncStatues
{
    int err = 0,need = 0,com = 0;
    if (self.taskNeed & TaskNeed1x) {
        need++;
        if (self.statuesDown1x == TaskStatusError) {
            err++;
        }
        if (self.statuesDown1x == TaskStatusComplete) {
            com++;
        }
    }
    if (self.taskNeed & TaskNeed2x) {
        need++;
        if (self.statuesDown2x == TaskStatusError) {
            err++;
        }
        if (self.statuesDown2x == TaskStatusComplete) {
            com++;
        }
    }
    if (self.taskNeed & TaskNeed3x) {
        need++;
        if (self.statuesDown3x == TaskStatusError) {
            err++;
        }
        if (self.statuesDown3x == TaskStatusComplete) {
            com++;
        }
    }
    if (com == need) {
        self.Status = TaskStatusComplete;
    }
    if (err > 0) {
        self.Status = TaskStatusError;
    }
}
@end
