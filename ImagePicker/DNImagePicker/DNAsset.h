//
//  DNAsset.h
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef void(^DNAssetToALAssetBlock)(ALAsset *);
@interface DNAsset : NSObject

@property (nonatomic, strong) NSURL *url;  //ALAsset url

- (BOOL)isEqualToAsset:(DNAsset *)asset;
+ (void)getALAsset:(DNAsset *) dnasset callback:(DNAssetToALAssetBlock) block;

@end
