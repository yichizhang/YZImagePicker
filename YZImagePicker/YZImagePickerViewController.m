/*
 
 Copyright (c) 2014 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YZImagePickerViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <YZLibrary/UICollectionViewCell+YZLibrary.h>

#import "YZImagePickerMainImageCell.h"

@interface YZMainCollectionDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong) ALAssetsGroup *assetsGroup;
@property (strong) NSMutableArray *assetArray;

@end

@implementation YZMainCollectionDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.assetArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZImagePickerMainImageCell *cell =
    [YZImagePickerMainImageCell
     yz_dequeueFromCollectionView:collectionView
     forIndexPath:indexPath
     ];
    
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

@end

@implementation YZSelectedCollectionDelegate



@end

@interface YZImagePickerViewController ()

@property (strong) YZMainCollectionDelegate *mainDelegate;
@property (strong) YZSelectedCollectionDelegate *selectedDelegate;

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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mainDelegate = [YZMainCollectionDelegate new];
    self.selectedDelegate = [YZSelectedCollectionDelegate new];
    
    self.mainCollectionView.delegate = self.mainDelegate;
    self.mainCollectionView.dataSource = self.mainDelegate;
    
    [YZImagePickerMainImageCell
     yz_registerForCollectionView:self.mainCollectionView
     ];
    
    self.selectedCollectionView.delegate = self.selectedDelegate;
    self.selectedCollectionView.dataSource = self.selectedDelegate;
    
}



- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
