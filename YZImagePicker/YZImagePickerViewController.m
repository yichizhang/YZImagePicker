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
#import "YZImagePickerMainAssetCell.h"
#import "YZImagePickerSelectedAssetCell.h"
#import "YZAssetGroupSelectionViewController.h"
#import "YZImagePickerMainFlowLayout.h"
#import "YZImagePickerSelectedFlowLayout.h"

@interface YZImagePickerViewController ()

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIButton *groupSelectionButton;
@property (nonatomic, strong) UILabel *noSelectionLabel;

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
	_mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
	_mainCollectionView.backgroundColor = [UIColor whiteColor];
	[_mainCollectionView registerClass:[YZImagePickerMainAssetCell class] forCellWithReuseIdentifier:YZImagePickerMainAssetCellIdentifier];

	YZImagePickerSelectedFlowLayout *selLayout = [YZImagePickerSelectedFlowLayout new];
	_selectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:selLayout];
    _selectedCollectionView.delegate = self;
    _selectedCollectionView.dataSource = self;
	_selectedCollectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
	[_selectedCollectionView registerClass:[YZImagePickerSelectedAssetCell class] forCellWithReuseIdentifier:YZImagePickerSelectedAssetCellIdentifier];
	
	_noSelectionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_noSelectionLabel.text = @"Please select an asset";
	_noSelectionLabel.textColor = [UIColor darkGrayColor];
	_noSelectionLabel.font = [UIFont boldSystemFontOfSize:20];
	
	_mainCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_selectedCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_noSelectionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_mainCollectionView];
	[self.view addSubview:_selectedCollectionView];
	[self.view addSubview:_noSelectionLabel];
	
	[self.view addConstraints:@[
								
	[NSLayoutConstraint constraintWithItem:_mainCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_mainCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_selectedCollectionView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_mainCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_mainCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
	
	[NSLayoutConstraint constraintWithItem:_selectedCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
	[NSLayoutConstraint constraintWithItem:_selectedCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_selectedCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_selectedCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
	
	[NSLayoutConstraint constraintWithItem:_noSelectionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_selectedCollectionView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_noSelectionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_selectedCollectionView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
	
	]];
	
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	// FIXME: There are extra views added when the orientation changes.
	NSLog(@"------------------------------");
	for (UIView *v in self.view.subviews) {
		NSLog(@"---%@---", v);
		
		if (v != self.mainCollectionView && v != self.selectedCollectionView && v != self.noSelectionLabel) {
			[v removeFromSuperview];
		}
	}
	NSLog(@"------------------------------");
}

#pragma mark - Update
- (void)updateAssestsWithGroup:(ALAssetsGroup *)group assetsFilter:(ALAssetsFilter *)filter {
	_assetArray = [NSMutableArray array];
	[group setAssetsFilter:filter];
	
	[_groupSelectionButton setTitle:[NSString stringWithFormat:@"%@ ▾", [group valueForProperty:ALAssetsGroupPropertyName]] forState:UIControlStateNormal];
	[_groupSelectionButton sizeToFit];
	
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
	
	YZImagePickerAssetCell *cell;
	ALAsset *asset;
	
	if (collectionView == self.mainCollectionView) {
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:YZImagePickerMainAssetCellIdentifier forIndexPath:indexPath];
		asset = self.assetArray[indexPath.row];
		cell.selected = [_selectedAssets containsObject:asset];
	} else {
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:YZImagePickerSelectedAssetCellIdentifier forIndexPath:indexPath];
		asset = self.selectedAssets[indexPath.row];
	}
	
	UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
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
			
			if (_selectedAssets.count == 1) {
				[UIView animateWithDuration:0.2 animations:^{
					
					_noSelectionLabel.alpha = 0.0;
				}];
			}
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
		
		if (_selectedAssets.count == 0) {
			[UIView animateWithDuration:0.2 animations:^{
				
				_noSelectionLabel.alpha = 1.0;
			}];
		}
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
