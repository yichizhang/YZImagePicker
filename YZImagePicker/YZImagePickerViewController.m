/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

@import AssetsLibrary;
@import Photos;
#import "YZImagePickerViewController.h"
#import "YZImagePickerMainImageCell.h"
#import "YZAssetGroupSelectionViewController.h"

@interface YZMainCollectionDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) ALAssetsGroup *group;
@property (nonatomic, strong) NSMutableArray *assetArray;

@end

@implementation YZMainCollectionDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
		_library = [ALAssetsLibrary new];
    }
    return self;
}

- (void)setGroup:(ALAssetsGroup *)group {
	_assetArray = [NSMutableArray array];
	[group setAssetsFilter:[ALAssetsFilter allPhotos]];
	[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
		if (result) {
			[_assetArray addObject:result];
		}
	}];
}
#pragma mark UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.assetArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	YZImagePickerMainImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YZImagePickerMainImageCellIdentifier forIndexPath:indexPath];

    ALAsset *asset = self.assetArray[indexPath.row];
    
    UIImage *image =
    [UIImage imageWithCGImage:[asset thumbnail]];
    
    [cell setupCellWithData:nil];
    [cell.imageView setImage:image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark UICollectionViewDelegateFlowLayout conformance

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat w;
    CGFloat h;
    
    w = 100;
    h = 100;
    
    return CGSizeMake(w, h);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //double screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float top;
    float left;
    float bottom;
    float right;
    
    top = 0;
    left = 0;
    bottom = 0;
    right = 0;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}

@end

@interface YZSelectedCollectionDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong) NSMutableArray *dataArray;

@end

@implementation YZSelectedCollectionDelegate


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dataArray = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;//[self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
	YZImagePickerMainImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YZImagePickerMainImageCellIdentifier forIndexPath:indexPath];
	
    //ALAsset *asset = self.assetArray[indexPath.row];
    
    UIImage *image =
    //[UIImage imageWithCGImage:[asset thumbnail]];
    [UIImage imageNamed:@"sailing_hook_island"];
    
    [cell setupCellWithData:nil];
    [cell.imageView setImage:image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark UICollectionViewDelegateFlowLayout conformance

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat w;
    CGFloat h;
    
    w = 100;
    h = 100;
    
    return CGSizeMake(w, h);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //double screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float top;
    float left;
    float bottom;
    float right;
    
    top = 0;
    left = 0;
    bottom = 0;
    right = 0;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}

@end

@interface YZImagePickerViewController ()

@property (nonatomic, strong) YZMainCollectionDelegate *mainDelegate;
@property (nonatomic, strong) YZSelectedCollectionDelegate *selectedDelegate;

@end

@implementation YZImagePickerViewController

- (void)commonInit{
	
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

#pragma mark - View life cycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonTapped:)];
	
	UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[titleButton setTitle:@"Select Group" forState:UIControlStateNormal];
	[titleButton addTarget:self action:@selector(selectGroupButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.titleView = titleButton;
    
    self.mainDelegate = [YZMainCollectionDelegate new];
    self.selectedDelegate = [YZSelectedCollectionDelegate new];
	
	UICollectionViewFlowLayout *mainLayout = [UICollectionViewFlowLayout new];
	mainLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
	[self.view addSubview:self.mainCollectionView];
	
    self.mainCollectionView.delegate = self.mainDelegate;
    self.mainCollectionView.dataSource = self.mainDelegate;
	self.mainCollectionView.backgroundColor = [UIColor blueColor];
	[self.mainCollectionView registerClass:[YZImagePickerMainImageCell class] forCellWithReuseIdentifier:YZImagePickerMainImageCellIdentifier];

	UICollectionViewFlowLayout *selLayout = [UICollectionViewFlowLayout new];
	selLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	self.selectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:selLayout];
	[self.view addSubview:self.selectedCollectionView];
	
    self.selectedCollectionView.delegate = self.selectedDelegate;
    self.selectedCollectionView.dataSource = self.selectedDelegate;
	self.selectedCollectionView.backgroundColor = [UIColor redColor];
	[self.selectedCollectionView registerClass:[YZImagePickerMainImageCell class] forCellWithReuseIdentifier:YZImagePickerMainImageCellIdentifier];
    
    [self.mainCollectionView reloadData];
    [self.selectedCollectionView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	
	CGFloat selHeight = 100;
	CGFloat mainHeight = CGRectGetHeight(self.view.bounds) - selHeight;
	self.mainCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), mainHeight);
	self.selectedCollectionView.frame = CGRectMake(0, mainHeight, CGRectGetWidth(self.view.bounds), selHeight);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)cancelButtonTapped:(id)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}

- (void)reloadButtonTapped:(id)sender {
	[self.mainCollectionView reloadData];
}

- (void)selectGroupButtonTapped:(UIButton*)sender {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		
		YZAssetGroupSelectionViewController *vc = [YZAssetGroupSelectionViewController new];
		vc.library = self.mainDelegate.library;
		vc.delegate = self;
		
		UIPopoverController *popoverVC = [[UIPopoverController alloc] initWithContentViewController:vc];
		[popoverVC presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
		
	}
}

#pragma mark - YZAssetGroupSelectionDelegate Delegate
- (void)assetGroupSelectionViewController:(YZAssetGroupSelectionViewController*)vc didSelectAssetsGroup:(ALAssetsGroup*)group {
	
	self.mainDelegate.group = group;
}

@end
