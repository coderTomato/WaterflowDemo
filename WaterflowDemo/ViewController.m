//
//  ViewController.m
//  WaterflowDemo
//
//  Created by Robin on 17/11/22.
//  Copyright © 2017年 Robin. All rights reserved.
//

#import "ViewController.h"
#import "WaterflowLayout.h"

@interface ViewController ()<UICollectionViewDataSource>

@end

static NSString *const LJShopId = @"shop";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 创建布局
    WaterflowLayout *layout = [[WaterflowLayout alloc] init];
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LJShopId];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LJShopId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}


@end
