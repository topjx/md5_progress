//
//  FileMD5.h
//  Runner
//
//  Created by tc on 2023/7/11.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionHandler)(NSString *hash);

@interface FileMD5 : NSObject

//+ (instancetype)sharedInstance;
- (void)hashForFilePath:(NSString *)path WithCompletion:(CompletionHandler)completionHandler;


@end

NS_ASSUME_NONNULL_END
