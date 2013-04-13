//
//  LibraryController.h
//  GeekOut
//
//  Created by Richard Knop on 13/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LibraryController : UITableViewController
{
    NSMutableArray *libraryFiles;
}

@property (nonatomic, retain) NSMutableArray *libraryFiles;

- (UIImage*) thumbnailImageForVideo:(NSURL *)sourceURL;

@end
