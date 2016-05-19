//
//  CollectionViewController.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"

@interface CollectionViewController ()
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"seletedImageTitle", @"seletedImage");
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    DNAsset *dnasset = self.imageArray[indexPath.row];
    
    __block CollectionViewCell *blockCell = cell;
    __weak typeof(self) weakSelf = self;
    
    [DNAsset getALAsset:dnasset callback:^(ALAsset *alAsset)  {
        [weakSelf setCell:blockCell asset:alAsset];
    }];
    
    
    
    return cell;
}

- (void)setCell:(CollectionViewCell *)cell asset:(ALAsset *)asset
{
    
    if (!asset) {
        cell.imageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
        cell.textLabel.hidden = YES;
        return;
    }else{
        cell.textLabel.hidden = NO;
    }
    
    __block UIImage *image;
    __block NSString *string;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.isFullImage) {
            NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
            UIImageOrientation orientation = UIImageOrientationUp;
            if (orientationValue != nil) {
                orientation = [orientationValue intValue];
            }
            
            image = [UIImage imageWithCGImage:asset.thumbnail];
            string = [NSString stringWithFormat:@"fileSize:%lld k\nwidth:%.0f\nheiht:%.0f",asset.defaultRepresentation.size/1000,[[asset defaultRepresentation] dimensions].width, [[asset defaultRepresentation] dimensions].height];
            
        } else {
            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            string = [NSString stringWithFormat:@"fileSize:%lld k\nwidth:%.0f\nheiht:%.0f",asset.defaultRepresentation.size/1000,image.size.width,image.size.height];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //在主线程中更新UI代码
            cell.textLabel.text = string;
            cell.imageView.image = image;
        });
    });
    
    
    
    
}

#define kSizeThumbnailCollectionView  self.view.frame.size.width/2

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView-4, kSizeThumbnailCollectionView*1.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}



@end
