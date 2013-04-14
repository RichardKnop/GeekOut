//
//  LibraryCell.h
//  GeekOut
//
//  Created by Richard Knop on 13/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel1;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel2;

@end
