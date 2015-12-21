//
//  NSDictionary+Json.m
//  iOSImageConverter
//
//  Created by gaodun on 15/12/21.
//  Copyright © 2015年 idea. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary(Json)
- (NSString *)jsonString
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (NSData *)jsonData
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return jsonData;
}
@end
