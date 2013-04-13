//
//  FilterCollectionController.m
//  GeekOut
//
//  Created by Richard Knop on 07/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "FilterCollectionController.h"
#import "FilterCell.h"
#import "Filter.h"

@interface FilterCollectionController ()

@end

@implementation FilterCollectionController

@synthesize changeVideoFilterDelegate;
@synthesize selectedFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [UIBarButtonItem new];
    [backButton setTitle:@"Back"];
    [backButton setTintColor:[UIColor colorWithRed:109.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:1.0]];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    [self.navigationController.navigationItem setBackBarButtonItem:backButton];
    
    filterImages = [[NSArray alloc] initWithObjects:@"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", nil];
    filterLabels = [[NSArray alloc] initWithObjects:@"Vignette", @"Sepia", @"Steel Blue", @"Terra Cotta", @"Olive", @"Byzantium", @"Amatorka", @"Miss Etikate", @"Soft Elegance", @"Sketch", @"Sketch 2", @"Toon", @"Smooth Toon", @"Emboss", @"Posterize", @"Tilt Shift", @"Sobel Edge", @"Canny Edge", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [filterLabels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCell *filterCell = (FilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    
    filterCell.filterImage.image = [UIImage imageNamed:[filterImages objectAtIndex:indexPath.item]];
    filterCell.filterImage.layer.cornerRadius = 10.0;
    filterCell.filterImage.layer.masksToBounds = YES;
    filterCell.filterLabel.text = [filterLabels objectAtIndex:indexPath.item];
    if ([selectedFilter isEqualToString:filterCell.filterLabel.text]) {
        filterCell.filterImage.layer.borderColor = [UIColor colorWithRed:109.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:1.0].CGColor;
        filterCell.filterImage.layer.borderWidth = 2.0;
    }
    
    // apply filter
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:filterCell.filterImage.image];
    GPUImageOutput<GPUImageInput> *stillImageFilter = [[[Filter alloc] init] getFilter:filterCell.filterLabel.text];
    [stillImageSource addTarget:stillImageFilter];
    [stillImageSource processImage];
    filterCell.filterImage.image = [stillImageFilter imageFromCurrentlyProcessedOutput];
    
    return filterCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSIndexPath * visibleItemIndexPath in self.collectionView.indexPathsForVisibleItems) {
        FilterCell *visibleFilterCell = (FilterCell *)[collectionView cellForItemAtIndexPath:visibleItemIndexPath];
        visibleFilterCell.filterImage.layer.borderWidth = 0.0;
        [visibleFilterCell.filterLabel setTextColor:[UIColor whiteColor]];
    }
    
    FilterCell *filterCell = (FilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    filterCell.filterImage.layer.borderColor = [UIColor colorWithRed:109.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:1.0].CGColor;
    filterCell.filterImage.layer.borderWidth = 2.0;
    
    if ([changeVideoFilterDelegate respondsToSelector:@selector(changeVideoFilter:)])
    {
        self.selectedFilter = filterCell.filterLabel.text;
        
        // send the delegate function with the index of filter
        [changeVideoFilterDelegate changeVideoFilter:self.selectedFilter];
    }
}

@end
