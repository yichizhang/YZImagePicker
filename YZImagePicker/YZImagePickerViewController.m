/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

@import AssetsLibrary;
@import MediaPlayer;
#import "YZImagePickerViewController.h"
#import "YZImagePickerMainAssetCell.h"
#import "YZImagePickerSelectedAssetCell.h"
#import "YZAssetGroupSelectionViewController.h"
#import "YZImagePickerMainFlowLayout.h"
#import "YZImagePickerSelectedFlowLayout.h"
#import "YZImagePreviewViewController.h"

#pragma mark - YZImagePickerViewController

@class YZImagePickerMainViewController;

@interface YZImagePickerViewController () <YZImagePickerDelegate>

@property (nonatomic, weak) YZImagePickerMainViewController *mainViewController;

@end

@interface YZImagePickerMainViewController : UIViewController

@property(nonatomic, assign) NSInteger maxNumberOfImages;
@property(nonatomic, assign) NSInteger maxNumberOfVideos;
@property (nonatomic, assign) id<YZImagePickerDelegate> delegate;

@end

@implementation YZImagePickerViewController

- (NSInteger)maxNumberOfImages {
	return _mainViewController.maxNumberOfImages;
}

- (void)setMaxNumberOfImages:(NSInteger)maxNumberOfImages {
	_mainViewController.maxNumberOfImages = maxNumberOfImages;
}

- (NSInteger)maxNumberOfVideos {
	return _mainViewController.maxNumberOfVideos;
}

- (void)setMaxNumberOfVideos:(NSInteger)maxNumberOfVideos {
	_mainViewController.maxNumberOfVideos = maxNumberOfVideos;
}

- (void)commonInit{
	YZImagePickerMainViewController *vc = [YZImagePickerMainViewController new];
	vc.delegate = self;
	
	[self pushViewController:vc animated:NO];
}

- (instancetype)init {
	if(self = [super init])
	{
		[self commonInit];
	}
	return self;
}

- (void)imagePickerController:(UIViewController *)picker didFinishPicking:(NSArray *)mediaArray {

	if ([self.imagePickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPicking:)]) {
		[self.imagePickerDelegate imagePickerController:self didFinishPicking:mediaArray];
	}
	
	if (self.didFinishPickingClosure) {
		self.didFinishPickingClosure(mediaArray);
	}
}

@end

@interface YZImagePickerMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, YZAssetGroupSelectionDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIButton *groupSelectionButton;
@property (nonatomic, strong) UILabel *noAssetsInAlbumLabel;
@property (nonatomic, strong) UILabel *noSelectionLabel;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionView *selectedCollectionView;

@end

@implementation YZImagePickerMainViewController

- (void)commonInit{
	_library = [ALAssetsLibrary new];
	_selectedAssets = [NSMutableArray new];
	
	_maxNumberOfImages = 5;
	_maxNumberOfVideos = 2;
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
	
	if (_maxNumberOfImages > 0 && _maxNumberOfVideos > 0) {
		
		_assetsFilter = [ALAssetsFilter allAssets];
	} else if (_maxNumberOfImages <= 0 && _maxNumberOfVideos > 0) {
		
		_assetsFilter = [ALAssetsFilter allVideos];
	} else {
		
		if (_maxNumberOfImages <= 0) {
			// The user set both 'maxNumberOfImages' and 'maxNumberOfVideos' to under zero.
			_maxNumberOfImages = 1;
		}
		_assetsFilter = [ALAssetsFilter allPhotos];
	}
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector(finishButtonTapped:)];
	
	_groupSelectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[_groupSelectionButton setTitle:@"Select Group" forState:UIControlStateNormal];
	[_groupSelectionButton addTarget:self action:@selector(selectGroupButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.titleView = _groupSelectionButton;
	
	// Load the first group in the Camera Roll.
	__block ALAssetsGroup *firstGroup = nil;
	[_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
		
		if (group) {
			firstGroup = group;
			*stop = true;
			
			[self updateAssestsWithGroup:firstGroup assetsFilter:_assetsFilter];
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
	
	[_mainCollectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainCollectionViewTapped:)]];
	[_selectedCollectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedCollectionViewTapped:)]];
	
	_noSelectionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_noSelectionLabel.text = @"Please select an asset";
	_noSelectionLabel.textColor = [UIColor darkGrayColor];
	_noSelectionLabel.font = [UIFont boldSystemFontOfSize:20];
	
	_noAssetsInAlbumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_noAssetsInAlbumLabel.textColor = [UIColor lightGrayColor];
	_noAssetsInAlbumLabel.font = [UIFont boldSystemFontOfSize:20];
	_noAssetsInAlbumLabel.alpha = 0.f;
	_noAssetsInAlbumLabel.numberOfLines = 0;
	
	_mainCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_selectedCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_noSelectionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_noAssetsInAlbumLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_mainCollectionView];
	[self.view addSubview:_selectedCollectionView];
	[self.view addSubview:_noSelectionLabel];
	[self.view addSubview:_noAssetsInAlbumLabel];
	
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
	
	[NSLayoutConstraint constraintWithItem:_noAssetsInAlbumLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_mainCollectionView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_noAssetsInAlbumLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_mainCollectionView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
	[NSLayoutConstraint constraintWithItem:_noAssetsInAlbumLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:_mainCollectionView attribute:NSLayoutAttributeWidth multiplier:0.62 constant:0],
	
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
	for (UIView *v in self.view.subviews) {
		
		if (v != self.mainCollectionView &&
			v != self.selectedCollectionView &&
			v != self.noSelectionLabel &&
			v != self.noAssetsInAlbumLabel) {
			
			[v removeFromSuperview];
		}
	}
}

#pragma mark - Update
- (void)selectAssetAtIndexInAssetArray:(NSUInteger)index {
	
	ALAsset *asset = _assetArray[index];
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

- (void)removeAssetAtIndexInSelectedAssets:(NSUInteger)index {
	// Tapped at the top left corner of the cell.
	// Remove asset from the selected asset array.
	ALAsset *assetToBeRemoved = [_selectedAssets objectAtIndex:index];
	[_selectedCollectionView.collectionViewLayout invalidateLayout];
	[_selectedAssets removeObjectAtIndex:index];
	
	NSUInteger rowInMainColView = [_assetArray indexOfObject:assetToBeRemoved];
	if (rowInMainColView != NSNotFound) {
		
		NSIndexPath *indexPathInMainColView = [NSIndexPath indexPathForItem:rowInMainColView inSection:0];
		[self.mainCollectionView reloadItemsAtIndexPaths:@[indexPathInMainColView]];
	}
	
	NSIndexPath *deletedItem = [NSIndexPath indexPathForItem:index inSection:0];
	[self.selectedCollectionView deleteItemsAtIndexPaths:@[deletedItem]];
	
	if (_selectedAssets.count == 0) {
		[UIView animateWithDuration:0.2 animations:^{
			
			_noSelectionLabel.alpha = 1.0;
		}];
	}
	
}

- (void)showPreviewForAsset:(ALAsset*)asset {
	
	if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
		
		NSURL *URL = [asset valueForProperty:ALAssetPropertyAssetURL];
		
		MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
		
		[playerVC.moviePlayer play];
		[self presentMoviePlayerViewControllerAnimated:playerVC];
	} else {
		
		UIImage *image = [UIImage imageWithCGImage:
						  [[asset defaultRepresentation] fullResolutionImage]
						  ];
		
		YZImagePreviewViewController *previewVC = [[YZImagePreviewViewController alloc] initWithImage:image];
		
		[self.navigationController pushViewController:previewVC animated:true];
	}
}

- (void)updateAssestsWithGroup:(ALAssetsGroup *)group assetsFilter:(ALAssetsFilter *)filter {
	
	NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
	NSInteger numberOfAssets = [group numberOfAssets];
	
	[group setAssetsFilter:filter];
	_assetArray = [NSMutableArray array];
	
	[_groupSelectionButton setTitle:[NSString stringWithFormat:@"%@ ▾", groupName] forState:UIControlStateNormal];
	[_groupSelectionButton sizeToFit];
	
	__block NSInteger count = 0;
	[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
		if (result) {
			[_assetArray addObject:result];
			count++;
		}
		
		if (count >= numberOfAssets) {
			[self.mainCollectionView reloadData];
		}
	}];
	
	if (numberOfAssets == 0) {
		_noAssetsInAlbumLabel.text = [NSString stringWithFormat:@"There are no assets in album '%@'.", groupName];
		_noAssetsInAlbumLabel.alpha = 1.f;
	} else {
		_noAssetsInAlbumLabel.text = nil;
		_noAssetsInAlbumLabel.alpha = 0.f;
	}
}

#pragma mark - Actions
- (void)cancelButtonTapped:(id)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}

- (void)finishButtonTapped:(id)sender {
	
	if ([_selectedAssets count] > 0) {
		
		if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPicking:)]) {
			
			[self.delegate imagePickerController:self didFinishPicking:_selectedAssets];
		}
		
		[self dismissViewControllerAnimated:true completion:nil];
	}
}

- (void)selectGroupButtonTapped:(UIButton*)sender {
	
	YZAssetGroupSelectionViewController *vc = [[YZAssetGroupSelectionViewController alloc] init];
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

#pragma mark - Gesture Recogonizer Handler
- (void)mainCollectionViewTapped:(UIPanGestureRecognizer*)gr {
	
	CGPoint point = [gr locationInView:gr.view];
	NSIndexPath *indexPath = [_mainCollectionView indexPathForItemAtPoint:point];
	
	if (indexPath) {
		
		ALAsset *asset = _assetArray[indexPath.row];
		
		UICollectionViewCell *cell = [_mainCollectionView cellForItemAtIndexPath:indexPath];
		CGPoint pointInCell = [gr locationInView:cell];
		
		if (cell) {
			if (pointInCell.x < CGRectGetMidX(cell.bounds) &&
				pointInCell.y < CGRectGetMidY(cell.bounds) ) {
				
				// Tapped at the left part and the top part of the cell.
				// Show user preview.
				[self showPreviewForAsset:asset];
				
			} else {
				
				// Tapped at the bottom right corner of the cell.
				NSUInteger indexInSelectedAssets = [_selectedAssets indexOfObject:asset];
				
				if (indexInSelectedAssets == NSNotFound) {
					
					// Asset not in selectedAssets.
					// Add the asset to selectedAssets.
					[self selectAssetAtIndexInAssetArray:indexPath.row];
					
				} else {
					
					// Asset is in selectedAssets.
					// Remove the asset from selectedAssets.
					[self removeAssetAtIndexInSelectedAssets:indexInSelectedAssets];
					
				}
				
				[self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
			}
		}
		
	}
}

- (void)selectedCollectionViewTapped:(UIPanGestureRecognizer*)gr {
	
	CGPoint point = [gr locationInView:gr.view];
	NSIndexPath *indexPath = [_mainCollectionView indexPathForItemAtPoint:point];
	
	if (indexPath) {
		UICollectionViewCell *cell = [_selectedCollectionView cellForItemAtIndexPath:indexPath];
		CGPoint pointInCell = [gr locationInView:cell];
		
		if (cell) {
			if (pointInCell.x < CGRectGetMidX(cell.bounds) &&
				pointInCell.y < CGRectGetMidY(cell.bounds) ) {
				
				[self removeAssetAtIndexInSelectedAssets:indexPath.row];
				
			} else {
				
				// Tapped bottom or right part of the cell.
				// Show preview.
				ALAsset *assetToBeRemoved = [_selectedAssets objectAtIndex:indexPath.row];
				[self showPreviewForAsset:assetToBeRemoved];
				
			}
		}
		
	}
}

#pragma mark - YZAssetGroupSelectionDelegate Delegate
- (void)assetGroupSelectionViewController:(YZAssetGroupSelectionViewController*)vc didSelectAssetsGroup:(ALAssetsGroup*)group {
	
	[self updateAssestsWithGroup:group assetsFilter:_assetsFilter];
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
	
	cell.isVideo = [[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo];
	
	UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
	[cell.imageView setImage:image];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	
	return;
}

#pragma mark -

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
	return YES;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
	return UIModalPresentationNone;
}

@end
