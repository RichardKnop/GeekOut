//
//  LibraryController.h
//  GeekOut
//
//  Created by Richard Knop on 13/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LibraryController : UITableViewController
{
    NSMutableArray *libraryFiles;
    NSMutableArray *thumbnails;
    NSMutableArray *durations;
    NSMutableArray *filesizes;
    NSMutableArray *beingMovedToCameraRoll;
    int selectedCell;
    MPMoviePlayerViewController *movieController;
}

@property (nonatomic, retain) NSMutableArray *libraryFiles;
@property (nonatomic, retain) NSMutableArray *thumbnails;
@property (nonatomic, retain) NSMutableArray *durations;
@property (nonatomic, retain) NSMutableArray *filesizes;
@property (nonatomic, retain) NSMutableArray *beingMovedToCameraRoll;
@property (nonatomic, assign) int selectedCell;
@property (nonatomic, retain) MPMoviePlayerViewController *movieController;

- (UIImage*) thumbnailImageForVideo:(NSURL *)sourceURL;

@end
