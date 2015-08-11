/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZMainViewController.h"
#import "YZImagePickerViewController.h"
#import "YZImagePickerAssetCell.h"

NSString *const YZDefaultTableCellIdentifier = @"YZDefaultTableCellIdentifier";

@interface YZMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YZMainViewController

- (void)commonInit{
	
	self.title = @"Default";
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	if(self = [super initWithCoder:aDecoder])
	{
		[self commonInit];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	self.navigationItem.rightBarButtonItem =
	[[UIBarButtonItem alloc]
	 initWithTitle:@"Pick"
	 style:UIBarButtonItemStylePlain
	 target:self
	 action:@selector(pickButtonTapped:)
	 ];
	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.translatesAutoresizingMaskIntoConstraints = false;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[self.view addSubview:_tableView];
	[self.view addConstraints:
  @[
	[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
	]];
	
	[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:YZDefaultTableCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)pickButtonTapped:(id)sender{
	
	YZImagePickerViewController *vc = [YZImagePickerViewController new];
	
	__weak YZMainViewController* weakSelf = self;
	vc.didFinishPickingClosure = ^(NSArray *mediaArray) {
		
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:mediaArray.count];
		for (ALAsset *asset in mediaArray) {
			
			[array addObject:
			 [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]
			 ];
		}
		weakSelf.dataArray = [array copy];
		[weakSelf.tableView reloadData];
	};
	
	vc.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentViewController:vc
					   animated:YES
					 completion:nil
	 ];
	
}

#pragma mark UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:YZDefaultTableCellIdentifier forIndexPath:indexPath];
	
	[cell.imageView setImage:_dataArray[indexPath.row]];
	cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	return cell;
}


@end
