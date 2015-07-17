/*
 
 Copyright (c) 2015 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePickerSelectedFlowLayout.h"

@interface YZImagePickerSelectedFlowLayout ()

@property (nonatomic) CGSize previousSize;
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;

@end

@implementation YZImagePickerSelectedFlowLayout

- (void)commonInit
{
	self.itemSize = CGSizeMake(80, 80);
	self.minimumLineSpacing = 16;
	self.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
	self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
	return attributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = nil;
	if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
		// Crashes if you call `[super layoutAttributesForItemAtIndexPath:indexPath]` here.
	} else {
		attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
	}
	return attributes;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
	UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
	
	if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
		
		attributes.alpha = 0.0;
		[_indexPathsToAnimate removeObject:itemIndexPath];
	}
	else{
		
		attributes.alpha = 1.0;
	}
	
	return attributes;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
	UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
	
	if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
		
		attributes.alpha = 0.0;
		[_indexPathsToAnimate removeObject:itemIndexPath];
	}
	else{
		attributes.alpha = 1.0;
	}
	
	return attributes;
}

- (void)prepareLayout
{
	[super prepareLayout];
	self.previousSize = self.collectionView.bounds.size;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
	[super prepareForCollectionViewUpdates:updateItems];
	NSMutableArray *indexPaths = [NSMutableArray array];
	for (UICollectionViewUpdateItem *updateItem in updateItems) {
		switch (updateItem.updateAction) {
			case UICollectionUpdateActionInsert:
				[indexPaths addObject:updateItem.indexPathAfterUpdate];
				break;
			case UICollectionUpdateActionDelete:
				[indexPaths addObject:updateItem.indexPathBeforeUpdate];
				break;
			case UICollectionUpdateActionMove:
				[indexPaths addObject:updateItem.indexPathBeforeUpdate];
				[indexPaths addObject:updateItem.indexPathAfterUpdate];
				break;
			default:
				// Unhandled case
				
				break;
		}
	}
	
	self.indexPathsToAnimate = indexPaths;
}

- (void)finalizeCollectionViewUpdates
{
	[super finalizeCollectionViewUpdates];
	self.indexPathsToAnimate = nil;
}

- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds
{
	[super prepareForAnimatedBoundsChange:oldBounds];
}

- (void)finalizeAnimatedBoundsChange {
	[super finalizeAnimatedBoundsChange];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
	CGRect oldBounds = self.collectionView.bounds;
	if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
		return YES;
	}
	return NO;
}

@end
