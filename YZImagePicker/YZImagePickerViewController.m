/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

@import AssetsLibrary;
#import "YZImagePickerViewController.h"
#import "YZImagePickerMainImageCell.h"
#import "YZAssetGroupSelectionViewController.h"
#import "YZImagePickerMainFlowLayout.h"
#import "YZImagePickerSelectedFlowLayout.h"

@interface YZImagePickerViewController ()

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIButton *groupSelectionButton;

@end

@implementation YZImagePickerViewController 

- (void)commonInit{
	_library = [ALAssetsLibrary new];
	_selectedAssets = [NSMutableArray new];
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
	
	_groupSelectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[_groupSelectionButton setTitle:@"Select Group" forState:UIControlStateNormal];
	[_groupSelectionButton addTarget:self action:@selector(selectGroupButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.titleView = _groupSelectionButton;
	
	// Load first group
	__block ALAssetsGroup *firstGroup = nil;
	[_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
		
		if (group) {
			firstGroup = group;
			*stop = true;
			
			[self updateAssestsWithGroup:firstGroup assetsFilter:[ALAssetsFilter allPhotos]];
		}
	} failureBlock:^(NSError *error) {
		
	}];
	
	YZImagePickerMainFlowLayout *mainLayout = [YZImagePickerMainFlowLayout new];
	self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
	[self.view addSubview:self.mainCollectionView];
	
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
	self.mainCollectionView.backgroundColor = [UIColor whiteColor];
	[self.mainCollectionView registerClass:[YZImagePickerMainImageCell class] forCellWithReuseIdentifier:YZImagePickerMainImageCellIdentifier];

	YZImagePickerSelectedFlowLayout *selLayout = [YZImagePickerSelectedFlowLayout new];
	self.selectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:selLayout];
	[self.view addSubview:self.selectedCollectionView];
	
    self.selectedCollectionView.delegate = self;
    self.selectedCollectionView.dataSource = self;
	self.selectedCollectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
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

#pragma mark - Update
- (void)updateAssestsWithGroup:(ALAssetsGroup *)group assetsFilter:(ALAssetsFilter *)filter {
	_assetArray = [NSMutableArray array];
	[group setAssetsFilter:filter];
	
	[_groupSelectionButton setTitle:[group valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
	
	NSInteger numberOfAssets = [group numberOfAssets];
	__block NSInteger count = 0;
	[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
		if (result) {
			[_assetArray addObject:result];
			
			count++;
			if (count == numberOfAssets) {
				[self.mainCollectionView reloadData];
			}
		}
	}];
}

#pragma mark - Actions
- (void)cancelButtonTapped:(id)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}

- (void)reloadButtonTapped:(id)sender {
	[self.mainCollectionView reloadData];
	[self.selectedCollectionView reloadData];
}

- (void)selectGroupButtonTapped:(UIButton*)sender {
	
	YZAssetGroupSelectionViewController *vc = [YZAssetGroupSelectionViewController alloc];
	[vc updateGroupsWithLibrary:_library groupTypes:ALAssetsGroupAll];
	vc.delegate = self;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		
		UIPopoverController *popoverVC = [[UIPopoverController alloc] initWithContentViewController:vc];
		[popoverVC presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
		
	} else {
		
		vc.modalPresentationStyle = UIModalPresentationPopover;
		vc.preferredContentSize = CGSizeMake(320, 300);
		
		UIPopoverPresentationController *popVC = [vc popoverPresentationController];
		popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
		popVC.sourceView = sender;
		
		CGRect senderRect = [sender convertRect:sender.frame fromView:sender.superview];
		CGRect sourceRect = CGRectMake(
									   CGRectGetMinX(senderRect),
									   CGRectGetMidY(senderRect),
									   CGRectGetWidth(senderRect),
									   CGRectGetHeight(senderRect)
									   );
		
		popVC.sourceRect = sourceRect;
		popVC.delegate = self;
		
		[self presentViewController:vc animated:YES completion:nil];
		
	}
}

#pragma mark - YZAssetGroupSelectionDelegate Delegate
- (void)assetGroupSelectionViewController:(YZAssetGroupSelectionViewController*)vc didSelectAssetsGroup:(ALAssetsGroup*)group {
	
	[self updateAssestsWithGroup:group assetsFilter:[ALAssetsFilter allPhotos]];
}

#pragma mark UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	if (collectionView == self.mainCollectionView) {
		return 1;
	} else {
		return 1;
	}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	
	if (collectionView == self.mainCollectionView) {
		return [self.assetArray count];
	} else {
		return [self.selectedAssets count];
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	YZImagePickerMainImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YZImagePickerMainImageCellIdentifier forIndexPath:indexPath];
	
	ALAsset *asset;
	
	if (collectionView == self.mainCollectionView) {
		asset = self.assetArray[indexPath.row];
		cell.selected = [_selectedAssets containsObject:asset];
	} else {
		asset = self.selectedAssets[indexPath.row];
		[cell hideSelectionView];
	}
	
	UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
	
	[cell setupCellWithData:nil];
	[cell.imageView setImage:image];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	
	if (collectionView == self.mainCollectionView) {
		
		ALAsset *asset = self.assetArray[indexPath.row];
		
		if ([_selectedAssets containsObject:asset] == false) {
			
			[_selectedAssets addObject:asset];
			
			NSIndexPath *insertedItem = [NSIndexPath indexPathForItem:(_selectedAssets.count - 1) inSection:0];
			[self.selectedCollectionView insertItemsAtIndexPaths:@[insertedItem]];
			
			[self.selectedCollectionView scrollToItemAtIndexPath:insertedItem atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
		}
		
		[self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
	} else {
		
		ALAsset *assetToBeRemoved = [_selectedAssets objectAtIndex:indexPath.row];
		
		[collectionView.collectionViewLayout invalidateLayout];
		[_selectedAssets removeObjectAtIndex:indexPath.row];
		
		NSUInteger rowInMainColView = [_assetArray indexOfObject:assetToBeRemoved];
		if (rowInMainColView != NSNotFound) {
			
			NSIndexPath *indexPathInMainColView = [NSIndexPath indexPathForItem:rowInMainColView inSection:0];
			[self.mainCollectionView reloadItemsAtIndexPaths:@[indexPathInMainColView]];
		}
		
		NSIndexPath *deletedItem = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
		[self.selectedCollectionView deleteItemsAtIndexPaths:@[deletedItem]];
	}
}

#pragma mark -

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
	return YES;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
	return UIModalPresentationNone;
}

@end
