//
//  NSDictionary+Json.h
//  iOSImageConverter
//
//  Created by gaodun on 15/12/21.
//  Copyright © 2015年 idea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Json)
- (NSString *)jsonString;
- (NSData *)jsonData;
@end
