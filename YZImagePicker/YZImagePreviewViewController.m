/*
 
 Copyright (c) 2015 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePreviewViewController.h"

@interface YZImagePreviewViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGR;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGR;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGR;

@end

@implementation YZImagePreviewViewController

- (id)initWithImage:(UIImage*)image {
	if (self = [super init]) {
		_image = image;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];
	
	_imageView = [[UIImageView alloc] initWithImage:_image];
	_imageView.translatesAutoresizingMaskIntoConstraints = NO;
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	_imageView.userInteractionEnabled = YES;
	
	[self.view addSubview:_imageView];
	[self.view addConstraints:
  @[
	[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
	
	]];
	
	_panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
	_panGR.delegate = self;
	_pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
	_pinchGR.delegate = self;
	_rotationGR = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureHandler:)];
	_rotationGR.delegate = self;
	
	[_imageView addGestureRecognizer:_panGR];
	[_imageView addGestureRecognizer:_pinchGR];
	[_imageView addGestureRecognizer:_rotationGR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void)pinchGestureHandler:(UIPinchGestureRecognizer*)gr {
	
	_imageView.transform = CGAffineTransformScale(_imageView.transform, gr.scale, gr.scale);
	
	gr.scale = 1;
}

- (void)panGestureHandler:(UIPanGestureRecognizer*)gr {
	
	CGPoint translation = [gr translationInView:self.view];
	
	_imageView.center = CGPointMake(_imageView.center.x + translation.x, _imageView.center.y + translation.y);
	
	[gr setTranslation:CGPointZero inView:self.view];
}

- (void)rotationGestureHandler:(UIRotationGestureRecognizer*)gr {
	
	_imageView.transform = CGAffineTransformRotate(_imageView.transform, gr.rotation);
	
	gr.rotation = 0;
}

@end
