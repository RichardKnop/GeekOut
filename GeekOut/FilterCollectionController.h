//
//  FilterCollectionController.h
//  GeekOut
//
//  Created by Richard Knop on 07/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCollectionController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *filterImages;
    NSArray *filterLabels;
}

@end
