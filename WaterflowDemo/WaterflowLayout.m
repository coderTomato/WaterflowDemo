//
//  WaterflowLayout.m
//  Test
//
//  Created by Robin on 17/11/22.
//  Copyright © 2017年 Robin. All rights reserved.
//

#import "WaterflowLayout.h"

static const NSInteger LJDefaultColumnCount = 3;

static const CGFloat LJDefaultColumnMargin = 10;
static const CGFloat LJDefaultRowMargin = 10;
static const UIEdgeInsets LJDefaultEdgeInsets = {5,5,5,5};

@interface WaterflowLayout()

/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation WaterflowLayout

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights)
    {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray)
    {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)prepareLayout
{
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    
    for (NSInteger i = 0; i < LJDefaultColumnCount; i++)
    {
        [self.columnHeights addObject:@(LJDefaultEdgeInsets.top)];
    }
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    //计算cell的总数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++)
    {
        // 获取indexPath位置cell对应的布局属性
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        //添加cell布局属性到attrsArray
        [self.attrsArray addObject:attrs];
    }
}

//该数组决定cell的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
//返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    // 设置布局属性的frame
    CGFloat w = (collectionViewW - LJDefaultEdgeInsets.left - LJDefaultEdgeInsets.right - LJDefaultColumnMargin * (LJDefaultColumnCount - 1)) /  LJDefaultColumnCount;
    CGFloat h = 50 + arc4random_uniform(100);
    
    //定义一个高度最小值minColumn将数组第一个元素赋值给它
    CGFloat minColumn = [self.columnHeights[0] doubleValue];
    
    //最短高度的列号
    NSInteger destColumn = 0;
    for (NSInteger i = 1; i < LJDefaultColumnCount; i++)
    {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        //如果minColumn比它大，就将它赋值给minColumn同时记录最小高度的列号
        if(minColumn > columnHeight)
        {
            minColumn = columnHeight;
            destColumn = i;
        }
    }
    //在同一列x是一样的，求出列号就能算出x
    CGFloat x = LJDefaultEdgeInsets.left + destColumn * (w+LJDefaultColumnMargin);
    CGFloat y = minColumn;
    if (y != LJDefaultEdgeInsets.top)
    {
        y += LJDefaultRowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    //更新最短那列的高度（不然永远是0）
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < LJDefaultColumnCount; i++)
    {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if(maxColumnHeight < columnHeight)
        {
            maxColumnHeight = columnHeight;
        }
    }
    return CGSizeMake(0, maxColumnHeight + LJDefaultEdgeInsets.bottom);
}

@end
