//
//  FilterCollectionController.m
//  GeekOut
//
//  Created by Richard Knop on 07/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "FilterCollectionController.h"
#import "FilterCell.h"

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
    
    filterImages = [[NSArray alloc] initWithObjects:@"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", @"flower.png", nil];
    filterLabels = [[NSArray alloc] initWithObjects:@"Filter 1", @"Filter 2", @"Filter 3", @"Filter 4", @"Filter 5", @"Filter 6", @"Filter 7", @"Filter 8", @"Filter 9", nil];
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
    filterCell.filterLabel.text = [filterLabels objectAtIndex:indexPath.item];
    if (selectedFilter == indexPath.item) {
        filterCell.backgroundColor = [UIColor darkGrayColor];
    }
    
    return filterCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSIndexPath * visibleItemIndexPath in self.collectionView.indexPathsForVisibleItems) {
        FilterCell *visibleFilterCell = (FilterCell *)[collectionView cellForItemAtIndexPath:visibleItemIndexPath];
        visibleFilterCell.backgroundColor = [UIColor blackColor];
    }
    
    FilterCell *filterCell = (FilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    filterCell.backgroundColor = [UIColor darkGrayColor];
    
    if ([changeVideoFilterDelegate respondsToSelector:@selector(changeVideoFilter:)])
    {
        self.selectedFilter = indexPath.item;
        
        // send the delegate function with the index of filter
        [changeVideoFilterDelegate changeVideoFilter:self.selectedFilter];
    }
}

@end
