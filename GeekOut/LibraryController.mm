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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    libraryFiles = [[NSMutableArray alloc] init];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL];
    for (NSString *file in files) {
        if (NSNotFound != [file rangeOfString:@".m4v"].location) {
            [libraryFiles addObject:file];
        }
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *playButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playVideo)];
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeVideo)];
    NSArray* toolbarItems = [NSArray arrayWithObjects:flexibleSpace, playButton, flexibleSpace, removeButton, flexibleSpace, nil];
    self.toolbarItems = toolbarItems;
    self.navigationController.toolbarHidden = NO;
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    libraryCell.itemLabel.text = [libraryFiles objectAtIndex:indexPath.item];
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], [libraryFiles objectAtIndex:indexPath.item]];
    libraryCell.itemImage.image = [self thumbnailImageForVideo:[NSURL fileURLWithPath:videoPath]];
    
    return libraryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
//    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
}

- (void)removeVideo
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSString *pathToMovie = [NSString stringWithFormat: @"%@/%@/%@", NSHomeDirectory() , @"Documents", [libraryFiles objectAtIndex:selectedIndexPath.item]];
    [libraryFiles removeObjectAtIndex:selectedIndexPath.item];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    unlink([pathToMovie UTF8String]);
}

@end
