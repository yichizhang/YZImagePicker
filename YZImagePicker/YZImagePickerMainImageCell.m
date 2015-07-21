/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePickerMainImageCell.h"

NSString *const YZImagePickerMainImageCellIdentifier = @"YZImagePickerMainImageCell";

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

@interface YZImagePickerMainImageCell ()

@property (nonatomic, strong) YZImagePickerCellSelectionView *selectionView;

@end

@implementation YZImagePickerMainImageCell

- (void)hideSelectionView {
	[_selectionView setAlpha:0];
}

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
		
		_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_imageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_imageView];
		
		_selectionView = [[YZImagePickerCellSelectionView alloc] initWithFrame:CGRectZero];
		_selectionView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_selectionView];
		
		self.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSLayoutConstraint *topConstraint =
		[NSLayoutConstraint constraintWithItem:self.imageView
									 attribute:NSLayoutAttributeTop
									 relatedBy:NSLayoutRelationEqual
										toItem:self
									 attribute:NSLayoutAttributeTop
									multiplier:1.0f
									  constant:0];
		
		NSLayoutConstraint *leadingConstraint =
		[NSLayoutConstraint constraintWithItem:self.imageView
									 attribute:NSLayoutAttributeLeading
									 relatedBy:NSLayoutRelationEqual
										toItem:self
									 attribute:NSLayoutAttributeLeading
									multiplier:1.0f
									  constant:0];
		
		NSLayoutConstraint *bottomConstraint =
		[NSLayoutConstraint constraintWithItem:self
									 attribute:NSLayoutAttributeBottom
									 relatedBy:NSLayoutRelationEqual
										toItem:self.imageView
									 attribute:NSLayoutAttributeBottom
									multiplier:1.0f
									  constant:0];
		
		NSLayoutConstraint *trailingConstraint =
		[NSLayoutConstraint constraintWithItem:self
									 attribute:NSLayoutAttributeTrailing
									 relatedBy:NSLayoutRelationEqual
										toItem:self.imageView
									 attribute:NSLayoutAttributeTrailing
									multiplier:1.0f
									  constant:0];
		
		[self addConstraint:topConstraint];
		[self addConstraint:leadingConstraint];
		[self addConstraint:bottomConstraint];
		[self addConstraint:trailingConstraint];
		
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
		 [NSLayoutConstraint constraintWithItem:self
									  attribute:NSLayoutAttributeBottom
									  relatedBy:NSLayoutRelationEqual
										 toItem:self.selectionView
									  attribute:NSLayoutAttributeBottom
									 multiplier:1.0f
									   constant:padding]
		 ];
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self
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

- (void)setupCellWithData:(id)data{
    
    
}

@end
