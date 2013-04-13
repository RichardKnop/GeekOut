//
//  LibraryCell.m
//  GeekOut
//
//  Created by Richard Knop on 13/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "LibraryCell.h"

@implementation LibraryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
