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
    
    return filterCell;
}

@end
