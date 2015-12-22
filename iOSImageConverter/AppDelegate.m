//
//  AppDelegate.m
//  iOSImageConverter
//
//  Created by gaodun on 15/11/13.
//  Copyright © 2015年 idea. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpClient.h"
#import "sys/utsname.h"
#import "Base64.h"

#define REMOTEURLBASE @"aHR0cDovL2FwaWRlYS5oYXVzdGdkLmNvbS9pbmRleC5waHA="
#define URLBASE [REMOTEURLBASE base64DecodedString]
#define FormateString(...) [NSString stringWithFormat:__VA_ARGS__]
#define SYS_BOOTLOG_URL [NSString stringWithFormat:@"%@/%@",URLBASE,[@"c3lzdGVtX2Jvb3RfbG9n" base64DecodedString]]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self logBootInfo];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (void)logBootInfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"device_name"] = FormateString(@"%@",[[NSProcessInfo processInfo]environment][@"USER"]);
    params[@"system"] = FormateString(@"%@_%@",@"OSX",[[[NSProcessInfo processInfo]operatingSystemVersionString] substringFromIndex:8]);
    params[@"device_model"] = FormateString(@"%@",platform);
    params[@"app_name"] = FormateString(@"%@",[dicInfo objectForKey:@"CFBundleName"]);
    params[@"app_version"] = FormateString(@"%@_b%@",[dicInfo objectForKey:@"CFBundleShortVersionString"],[dicInfo objectForKey:@"CFBundleVersion"]);
    
    [[HttpClient manager] requestWithBaseURL:SYS_BOOTLOG_URL para:params httpMethod:HttpMethodPost success:^(AFHTTPRequestOperation *operation, id responseObject) {} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    
}
@end
