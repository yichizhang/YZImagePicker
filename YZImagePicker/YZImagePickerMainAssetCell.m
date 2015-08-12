/*
 
 Copyright (c) 2015 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePickerAssetCell.h"
#import "YZImagePickerMainAssetCell.h"

NSString *const YZImagePickerMainAssetCellIdentifier = @"YZImagePickerMainAssetCell";

@interface YZImagePickerCellSelectionView : UIView

@property (nonatomic, assign) BOOL selected;

@end

@implementation YZImagePickerCellSelectionView

- (instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	
	CGFloat lineWidth = 1;
	
	CGRect ovalRect = CGRectInset(rect, lineWidth, lineWidth);
	
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	
	if (_selected) {
		CGContextFillEllipseInRect(context, ovalRect);
	}
	
	CGContextStrokeEllipseInRect(context, ovalRect);
	
	if (_selected) {
		
		CGPoint p1 = CGPointMake(0.25, 0.5);
		CGPoint p2 = CGPointMake(0.45, 0.7);
		CGPoint p3 = CGPointMake(0.8, 0.35);
		
		CGContextMoveToPoint(context, CGRectGetWidth(rect) * p1.x, CGRectGetHeight(rect) * p1.y);
		CGContextAddLineToPoint(context, CGRectGetWidth(rect) * p2.x, CGRectGetHeight(rect) * p2.y);
		CGContextAddLineToPoint(context, CGRectGetWidth(rect) * p3.x, CGRectGetHeight(rect) * p3.y);
		
		CGContextStrokePath(context);
	}
	
}

@end

@interface YZImagePickerMainAssetCell ()

@property (nonatomic, strong) YZImagePickerCellSelectionView *selectionView;

@end

@implementation YZImagePickerMainAssetCell

- (BOOL)isSelected {
	return [super isSelected];
	
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	
	[_selectionView setSelected:selected];
	[_selectionView setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	if (self) {
		_selectionView = [[YZImagePickerCellSelectionView alloc] initWithFrame:CGRectZero];
		_selectionView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:_selectionView];
		
		CGFloat selectionViewSize = 20;
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.selectionView
									  attribute:NSLayoutAttributeWidth
									  relatedBy:NSLayoutRelationEqual
										 toItem:nil
									  attribute:NSLayoutAttributeNotAnAttribute
									 multiplier:1.0f
									   constant:selectionViewSize]
		 ];
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.selectionView
									  attribute:NSLayoutAttributeHeight
									  relatedBy:NSLayoutRelationEqual
										 toItem:nil
									  attribute:NSLayoutAttributeNotAnAttribute
									 multiplier:1.0f
									   constant:selectionViewSize]
		 ];
		
		CGFloat padding = 5;
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.contentView
									  attribute:NSLayoutAttributeBottom
									  relatedBy:NSLayoutRelationEqual
										 toItem:self.selectionView
									  attribute:NSLayoutAttributeBottom
									 multiplier:1.0f
									   constant:padding]
		 ];
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.contentView
									  attribute:NSLayoutAttributeTrailing
									  relatedBy:NSLayoutRelationEqual
										 toItem:self.selectionView
									  attribute:NSLayoutAttributeTrailing
									 multiplier:1.0f
									   constant:padding]
		 ];
	}
	return self;
}

@end
