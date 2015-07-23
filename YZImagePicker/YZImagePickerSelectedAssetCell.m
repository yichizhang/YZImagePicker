/*
 
 Copyright (c) 2015 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePickerAssetCell.h"
#import "YZImagePickerSelectedAssetCell.h"

NSString *const YZImagePickerSelectedAssetCellIdentifier = @"YZImagePickerSelectedAssetCell";

@interface YZImagePickerCloseView : UIView

@end

@implementation YZImagePickerCloseView

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
	CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	
	CGContextFillEllipseInRect(context, ovalRect);
	CGContextStrokeEllipseInRect(context, ovalRect);
	
	CGFloat low = 0.25;
	CGFloat high = 1 - low;
	CGContextMoveToPoint(context, CGRectGetWidth(rect) * low, CGRectGetHeight(rect) * low);
	CGContextAddLineToPoint(context, CGRectGetWidth(rect) * high, CGRectGetHeight(rect) * high);
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, CGRectGetWidth(rect) * low, CGRectGetHeight(rect) * high);
	CGContextAddLineToPoint(context, CGRectGetWidth(rect) * high, CGRectGetHeight(rect) * low);
	CGContextStrokePath(context);
	
}

@end

@interface YZImagePickerSelectedAssetCell ()

@property (nonatomic, strong) YZImagePickerCloseView *closeView;

@end

@implementation YZImagePickerSelectedAssetCell

- (instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	if (self) {
		_closeView = [[YZImagePickerCloseView alloc] initWithFrame:CGRectZero];
		_closeView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_closeView];
		
		CGFloat closeViewSize = 20;
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.closeView
									  attribute:NSLayoutAttributeWidth
									  relatedBy:NSLayoutRelationEqual
										 toItem:nil
									  attribute:NSLayoutAttributeNotAnAttribute
									 multiplier:1.0f
									   constant:closeViewSize]
		 ];
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.closeView
									  attribute:NSLayoutAttributeHeight
									  relatedBy:NSLayoutRelationEqual
										 toItem:nil
									  attribute:NSLayoutAttributeNotAnAttribute
									 multiplier:1.0f
									   constant:closeViewSize]
		 ];
		
		CGFloat padding = 5;
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self
									  attribute:NSLayoutAttributeTop
									  relatedBy:NSLayoutRelationEqual
										 toItem:self.closeView
									  attribute:NSLayoutAttributeTop
									 multiplier:1.0f
									   constant:padding]
		 ];
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self
									  attribute:NSLayoutAttributeLeading
									  relatedBy:NSLayoutRelationEqual
										 toItem:self.closeView
									  attribute:NSLayoutAttributeLeading
									 multiplier:1.0f
									   constant:padding]
		 ];
	}
	return self;
}

@end
