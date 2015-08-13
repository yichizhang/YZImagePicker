/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePickerAssetCell.h"

@interface YZImagePickerCellVideoView : UIView

@end

@implementation YZImagePickerCellVideoView

- (instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor blackColor];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	CGContextSaveGState(context);
	
	// The icon occupies 'idealSize' fully.
	CGSize idealSize = CGSizeMake(40, 30);
	
	// Calulate the scale needed for the icon to fit in the size of the rect.
	CGFloat s = MIN( CGRectGetWidth(rect) / idealSize.width, CGRectGetHeight(rect) / idealSize.height );
	
	// Make the scale lower to make the icon look smaller.
	s *= 0.618;
	
	// Apply translation and scaling so that the icon is drawn at the center of the rect.
	CGContextTranslateCTM(
						  context,
						  (CGRectGetWidth(rect) - idealSize.width * s ) / 2,
						  (CGRectGetHeight(rect) - idealSize.height * s ) / 2
						  );
	CGContextScaleCTM(context, s, s);

	
	//// Rectangle 2 Drawing
	UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(2, 13, 3, 6)];
	[UIColor.whiteColor setFill];
	[rectangle2Path fill];
	
	
	//// Oval 3 Drawing
	UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(8, 2, 9, 9)];
	[UIColor.whiteColor setFill];
	[oval3Path fill];
	
	
	//// Oval 4 Drawing
	UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(18, 2, 9, 9)];
	[UIColor.whiteColor setFill];
	[oval4Path fill];
	
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(6, 12)];
	[bezier2Path addLineToPoint: CGPointMake(30, 12)];
	[bezier2Path addLineToPoint: CGPointMake(30, 16)];
	[bezier2Path addLineToPoint: CGPointMake(37, 10)];
	[bezier2Path addLineToPoint: CGPointMake(37, 28)];
	[bezier2Path addLineToPoint: CGPointMake(30, 22)];
	[bezier2Path addLineToPoint: CGPointMake(30, 27)];
	[bezier2Path addLineToPoint: CGPointMake(6, 27)];
	[bezier2Path addLineToPoint: CGPointMake(6, 12)];
	[bezier2Path closePath];
	[UIColor.whiteColor setFill];
	[bezier2Path fill];
	
	CGContextRestoreGState(context);
}

@end

@interface YZImagePickerAssetCell ()

@property (nonatomic, strong) YZImagePickerCellVideoView *isVideoView;

@end

@implementation YZImagePickerAssetCell

- (void)setIsVideo:(BOOL)isVideo {
	_isVideo = isVideo;
	
	if (isVideo) {
		if (self.isVideoView) {
			return;
		}
		
		_isVideoView = [[YZImagePickerCellVideoView alloc] initWithFrame:CGRectZero];
		_isVideoView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:_isVideoView];
		
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.isVideoView
									  attribute:NSLayoutAttributeWidth
									  relatedBy:NSLayoutRelationEqual
										 toItem:nil
									  attribute:NSLayoutAttributeNotAnAttribute
									 multiplier:1.0f
									   constant:30]
		 ];
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.isVideoView
									  attribute:NSLayoutAttributeHeight
									  relatedBy:NSLayoutRelationEqual
										 toItem:nil
									  attribute:NSLayoutAttributeNotAnAttribute
									 multiplier:1.0f
									   constant:30]
		 ];
		
		CGFloat padding = 0;
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.contentView
									  attribute:NSLayoutAttributeBottom
									  relatedBy:NSLayoutRelationEqual
										 toItem:self.isVideoView
									  attribute:NSLayoutAttributeBottom
									 multiplier:1.0f
									   constant:padding]
		 ];
		[self addConstraint:
		 [NSLayoutConstraint constraintWithItem:self.isVideoView
									  attribute:NSLayoutAttributeLeading
									  relatedBy:NSLayoutRelationEqual
										 toItem:self.contentView
									  attribute:NSLayoutAttributeLeading
									 multiplier:1.0f
									   constant:padding]
		 ];
		
	} else {
		
		[_isVideoView removeFromSuperview];
		_isVideoView = nil;
		
	}
}

- (instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	if (self) {
		
		_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_imageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:_imageView];
		
		self.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSLayoutConstraint *topConstraint =
		[NSLayoutConstraint constraintWithItem:self.imageView
									 attribute:NSLayoutAttributeTop
									 relatedBy:NSLayoutRelationEqual
										toItem:self.contentView
									 attribute:NSLayoutAttributeTop
									multiplier:1.0f
									  constant:0];
		
		NSLayoutConstraint *leadingConstraint =
		[NSLayoutConstraint constraintWithItem:self.imageView
									 attribute:NSLayoutAttributeLeading
									 relatedBy:NSLayoutRelationEqual
										toItem:self.contentView
									 attribute:NSLayoutAttributeLeading
									multiplier:1.0f
									  constant:0];
		
		NSLayoutConstraint *bottomConstraint =
		[NSLayoutConstraint constraintWithItem:self.contentView
									 attribute:NSLayoutAttributeBottom
									 relatedBy:NSLayoutRelationEqual
										toItem:self.imageView
									 attribute:NSLayoutAttributeBottom
									multiplier:1.0f
									  constant:0];
		
		NSLayoutConstraint *trailingConstraint =
		[NSLayoutConstraint constraintWithItem:self.contentView
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
		
	}
	return self;
}

@end
