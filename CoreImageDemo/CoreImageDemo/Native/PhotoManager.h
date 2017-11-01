//
//  PhotoManager.h
//  CoreImageDemo
//
//  Created by zhanggui on 2017/11/1.
//  Copyright © 2017年 zhanggui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^finishHandle) (BOOL boo,NSString *errorStr);
@interface PhotoManager : NSObject

+ (instancetype)shared;

- (instancetype)init NS_UNAVAILABLE;


- (void)saveImage:(UIImage *)image withCompleteHandler:(finishHandle)handle;

@property (nonatomic,copy)finishHandle fHandle;
@end
