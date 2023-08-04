//
//  FileMD5.m
//  Runner
//
//  Created by tc on 2023/7/11.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

#import "FileMD5.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation FileMD5
//+ (instancetype)sharedInstance {
//    static FileMD5 *fileMD5;
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&onceToken, ^{
//        if (!fileMD5) {
//            fileMD5 = [[FileMD5 alloc]init];
//        }
//    });
//    return fileMD5;
//}

//移动设备的内存有限
//将文件分块读出
//progress
- (void)hashForFilePath:(NSString *)path WithCompletion:(CompletionHandler)completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        if(fileHandle == nil && completionHandler) {
            completionHandler(@"");
        }
        
        CFTimeInterval startTime = CACurrentMediaTime();
        
        CC_MD5_CTX md5;
        CC_MD5_Init(&md5);
        BOOL done = NO;
        while(!done)
        {
            @autoreleasepool {
                NSData *fileData = [fileHandle readDataOfLength: FileHashDefaultChunkSizeForReadingData];
                CC_MD5_Update(&md5, [fileData bytes], (unsigned int)[fileData length]);
                if([fileData length] == 0) done = YES;
            }
        }
        
        [fileHandle closeFile];
        
        CFTimeInterval readEndTime = CACurrentMediaTime();
        
        CFTimeInterval durationRead = readEndTime - startTime;
        
        NSLog(@"File read successfully in %.2f seconds", durationRead);
        
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &md5);
        NSString *hash = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          digest[0], digest[1],
                          digest[2], digest[3],
                          digest[4], digest[5],
                          digest[6], digest[7],
                          digest[8], digest[9],
                          digest[10], digest[11],
                          digest[12], digest[13],
                          digest[14], digest[15]];
        
        CFTimeInterval endTime = CACurrentMediaTime();
        
        CFTimeInterval duration = endTime - startTime;
        
        NSLog(@"File hash successfully in %.2f seconds", duration);
        
        if(completionHandler) {
            completionHandler(hash);
        }
    });
}

@end
