//
//  PhotoManager.m
//  CoreImageDemo
//
//  Created by zhanggui on 2017/11/1.
//  Copyright © 2017年 zhanggui. All rights reserved.
//

#import "PhotoManager.h"
#import <Photos/Photos.h>
static NSString * const albumTitle = @"CoreImage";
@implementation PhotoManager


+ (instancetype)shared {
    static PhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (void)saveImage:(UIImage *)image withCompleteHandler:(finishHandle)handle {
    self.fHandle = handle;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        handle(NO,@"没有相机权限");
    }else if(status == PHAuthorizationStatusNotDetermined){  //未咨询权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status1) {
            if (status1 == PHAuthorizationStatusAuthorized) {
                
                [self saveImageWithImage:image];
            }else {
                handle(NO,@"申请权限时拒绝");
            }
        }];
    }else {
        [self saveImageWithImage:image];
    }
}
- (void)saveImageWithImage:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest *assetCreationRequest = [PHAssetCreationRequest creationRequestForAssetFromImage:image];
        
        PHAssetCollectionChangeRequest *asseteCollectionChangeRequest = nil;
        
        PHAssetCollection *assetCollection = [self fetchAssetCollection:albumTitle];
        
        if (assetCollection) {
            asseteCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        }else {
            asseteCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumTitle];
        }
        
        [asseteCollectionChangeRequest addAssets:@[assetCreationRequest.placeholderForCreatedAsset]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            self.fHandle(YES, nil);
        }else {
            self.fHandle(NO, @"保存失败，请稍后重试");
        }
    }];
}
- (PHAssetCollection *)fetchAssetCollection:(NSString *)title {
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in result) {
        if ([title isEqualToString:assetCollection.localizedTitle]) {
            return assetCollection;
        }
    }
    return nil;
}
@end
