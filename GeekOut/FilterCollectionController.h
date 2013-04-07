//
//  FilterCollectionController.h
//  GeekOut
//
//  Created by Richard Knop on 07/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeVideoFilterDelegate <NSObject>

- (void)changeVideoFilter:(NSInteger)filter;

@end

@interface FilterCollectionController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *filterImages;
    NSArray *filterLabels;
    id <ChangeVideoFilterDelegate> changeVideoFilterDelegate;
}

@property (nonatomic, retain) id changeVideoFilterDelegate;

@end
