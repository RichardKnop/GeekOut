//
//  ViewController.h
//  GeekOut
//
//  Created by Richard Knop on 06/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <opencv2/highgui/cap_ios.h>
using namespace cv;

@interface ViewController : UIViewController<CvVideoCameraDelegate>
{
    CvVideoCamera* videoCamera;
}

@property (nonatomic, retain) CvVideoCamera* videoCamera;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
- (IBAction)stopAction:(id)sender;
@end
