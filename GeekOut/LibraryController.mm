//
//  LibraryController.m
//  GeekOut
//
//  Created by Richard Knop on 13/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "LibraryController.h"
#import "LibraryCell.h"

@interface LibraryController ()

@end

@implementation LibraryController

@synthesize libraryFiles;
@synthesize thumbnails;
@synthesize durations;
@synthesize selectedCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    selectedCell = -1;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    libraryFiles = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    durations = [[NSMutableArray alloc] init];
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL];
    for (NSString *file in files) {
        if (NSNotFound != [file rangeOfString:@".m4v"].location) {
            [libraryFiles addObject:file];
            [thumbnails addObject:[NSNull null]];
            [durations addObject:@""];
        }
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *playButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playVideo)];
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeVideo)];
    NSArray* toolbarItems = [NSArray arrayWithObjects:flexibleSpace, playButton, flexibleSpace, removeButton, flexibleSpace, nil];
    self.toolbarItems = toolbarItems;
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    [self.tableView setSeparatorColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // TODO
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [libraryFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LibraryCell *libraryCell = [tableView dequeueReusableCellWithIdentifier:@"LibraryCell" forIndexPath:indexPath];
    
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], [libraryFiles objectAtIndex:indexPath.item]];
    
    if ([[durations objectAtIndex:indexPath.item] isEqualToString:@""]) {
        libraryCell.itemLabel1.text = @"";
        
        void (^blockLoadDuration)() =  ^{
            NSURL *sourceMovieURL = [NSURL fileURLWithPath:videoPath];
            AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
            CMTime duration = sourceAsset.duration;
            NSUInteger totalSeconds = CMTimeGetSeconds(duration);
            NSUInteger hours = floor(totalSeconds / 3600);
            NSUInteger minutes = floor(totalSeconds % 3600 / 60);
            NSUInteger seconds = floor(totalSeconds % 3600 % 60);
            NSString *durationString = [NSString stringWithFormat:@"%i:%02i:%02i", hours, minutes, seconds];
            dispatch_async(dispatch_get_main_queue(),^{
                [durations replaceObjectAtIndex:indexPath.item withObject:durationString];
                libraryCell.itemLabel1.text = durationString;
            });
        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), blockLoadDuration);
    } else {
        libraryCell.itemLabel1.text = [durations objectAtIndex:indexPath.item];
    }
    
    libraryCell.itemLabel2.text = @"world";
    
    libraryCell.itemImage.layer.cornerRadius = 10.0;
    libraryCell.itemImage.layer.masksToBounds = YES;
    libraryCell.itemImage.layer.borderWidth = 2.0;
    if (indexPath.item != selectedCell) {
        libraryCell.itemImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    } else {
        libraryCell.itemImage.layer.borderColor = [UIColor colorWithRed:109.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:1.0].CGColor;
    }
    
    if ([[thumbnails objectAtIndex:indexPath.item] isKindOfClass:[UIImage class]]) {
        libraryCell.itemImage.image = [thumbnails objectAtIndex:indexPath.item];
    } else {
        libraryCell.itemImage.image = [[UIImage alloc] init];
        
        void (^blockLoadThumbnail)() =  ^{
            UIImage *_imageTemporary = [self thumbnailImageForVideo:[NSURL fileURLWithPath:videoPath]];
            dispatch_async(dispatch_get_main_queue(),^{
                [thumbnails replaceObjectAtIndex:indexPath.item withObject:_imageTemporary];
                libraryCell.itemImage.image = _imageTemporary;
            });
        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), blockLoadThumbnail);
    }
    
    return libraryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSIndexPath * visibleItemIndexPath in tableView.indexPathsForVisibleRows) {
        LibraryCell *visibleLibraryCell = (LibraryCell *)[tableView cellForRowAtIndexPath:visibleItemIndexPath];
        visibleLibraryCell.itemImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    LibraryCell *libraryCell = (LibraryCell *)[tableView cellForRowAtIndexPath:indexPath];
    libraryCell.itemImage.layer.borderColor = [UIColor colorWithRed:109.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:1.0].CGColor;
    
    selectedCell = indexPath.item;
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)sourceURL
{
    AVAsset *asset = [AVAsset assetWithURL:sourceURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef); // CGImageRef won't be released by ARC
    return thumbnail;
}

- (void)playVideo
{
    if (-1 != selectedCell) {
        NSString *videoPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], [libraryFiles objectAtIndex:selectedCell]];
        NSLog(videoPath);
        NSURL *url=[[NSURL alloc] initWithString:videoPath];
        MPMoviePlayerController *moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDonePressed) name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayer];
    
        moviePlayer.controlStyle=MPMovieControlStyleDefault;
        [moviePlayer play];
        [self.view addSubview:moviePlayer.view];
        [moviePlayer setFullscreen:YES animated:YES];
    }
}

- (void)moviePlayBackDidFinish
{
    NSLog(@"aaa");
}

- (void)moviePlayBackDonePressed
{
    NSLog(@"bbb");
}

- (void)removeVideo
{
    if (-1 != selectedCell) {
        NSString *pathToMovie = [NSString stringWithFormat: @"%@/%@/%@", NSHomeDirectory() , @"Documents", [libraryFiles objectAtIndex:selectedCell]];
        [libraryFiles removeObjectAtIndex:selectedCell];
        [thumbnails removeObjectAtIndex:selectedCell];
        [durations removeObjectAtIndex:selectedCell];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:selectedCell inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        unlink([pathToMovie UTF8String]);
        selectedCell = -1;
    }
}

@end
