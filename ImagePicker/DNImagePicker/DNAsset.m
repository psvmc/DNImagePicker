//
//  DNAsset.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
#import <AssetsLibrary/AssetsLibrary.h>
@implementation DNAsset

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return [self isEqualToAsset:other];
    }
}

- (BOOL)isEqualToAsset:(DNAsset *)asset
{
    if ([asset isKindOfClass:[DNAsset class]]) {
        return [self.url isEqualToOther:asset.url];
    } else {
        return NO;
    }
}

+ (void)getALAsset:(DNAsset *)dnasset callback:(DNAssetToALAssetBlock)block{
    ALAssetsLibrary *lib = [DNAsset defaultAssetsLibrary];
    [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
        if (asset) {
            block(asset);
        } else {
            // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
            [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                               usingBlock:^(ALAssetsGroup *group, BOOL *stop)
             {
                 [group enumerateAssetsWithOptions:NSEnumerationReverse
                                        usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                            
                                            if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url])
                                            {
                                                block(asset);
                                                *stop = YES;
                                            }
                                        }];
             }
                             failureBlock:^(NSError *error)
             {
                 block(nil);
             }];
        }
        
    } failureBlock:^(NSError *error){
        block(nil);
    }];
}


+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
