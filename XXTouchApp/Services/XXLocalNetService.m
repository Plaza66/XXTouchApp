//
//  XXLocalNetService.m
//  XXTouchApp
//
//  Created by Zheng on 8/30/16.
//  Copyright © 2016 Zheng. All rights reserved.
//

#import "XXLocalNetService.h"
#import "XXLocalDataService.h"

#define SAVE_ERROR(ret) \
if (error != nil) { \
    _lastError = error; \
    return ret; \
}

static NSString * const kXXErrorDomain = @"com.xxtouch.error-domain";

@implementation XXLocalNetService
+ (id)sharedInstance {
    static XXLocalNetService *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        // Init Local Network Configure
        _serverAlive = NO;
    }
    return self;
}

+ (void)respringDevice {
    system("killall -9 SpringBoard");
}

- (NSDictionary *)sendSynchronousRequest:(NSString *)command
                          withDictionary:(NSDictionary *)requestParams {
    NSError *error = nil;
    
    NSURL *url = [NSURL URLWithString:[apiUrl stringByAppendingString:command]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (requestParams) {
        NSData *sendData = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:&error];
        SAVE_ERROR(nil);
        [request setHTTPBody:sendData];
    }
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:&error];
    SAVE_ERROR(nil);
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received options:0 error:&error];
    _serverAlive = YES;
    SAVE_ERROR(nil);
    return result;
}

- (BOOL)localSetSelectedScript:(NSString *)scriptPath {
    NSError *error = nil;
    NSDictionary *result = [self sendSynchronousRequest:@"select_script_file"
                                         withDictionary:@{ @"filename": scriptPath }];
    if (!result) return NO;
    NSNumber *code = [result objectForKey:@"code"];
    NSString *message = [result objectForKey:@"message"];
    if ([code isEqualToNumber:@0]) {
        [[XXLocalDataService sharedInstance] setSelectedScript:scriptPath];
        return YES;
    } else {
        error = [NSError errorWithDomain:kXXErrorDomain
                                    code:[code integerValue]
                                userInfo:@{ NSLocalizedDescriptionKey:message }];
    }
    SAVE_ERROR(NO);
    return NO;
}

- (BOOL)localGetSelectedScript {
    NSError *error = nil;
    NSDictionary *result = [self sendSynchronousRequest:@"get_selected_script_file"
                                         withDictionary:nil];
    if (!result) return NO;
    NSNumber *code = [result objectForKey:@"code"];
    NSString *message = [result objectForKey:@"message"];
    NSDictionary *data = [result objectForKey:@"data"];
    if ([code isEqualToNumber:@0]) {
        NSString *filename = [data objectForKey:@"filename"];
        [[XXLocalDataService sharedInstance] setSelectedScript:filename];
        return YES;
    } else {
        error = [NSError errorWithDomain:kXXErrorDomain
                                    code:[code integerValue]
                                userInfo:@{ NSLocalizedDescriptionKey:message }];
    }
    SAVE_ERROR(NO);
    return NO;
}

@end
