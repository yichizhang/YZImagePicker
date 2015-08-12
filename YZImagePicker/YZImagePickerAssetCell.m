/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePickerAssetCell.h"

@interface YZImagePickerAssetCell ()

@end

@implementation YZImagePickerAssetCell

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
