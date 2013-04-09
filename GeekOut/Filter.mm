//
//  Filter.m
//  GeekOut
//
//  Created by Richard Knop on 09/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "Filter.h"

@implementation Filter

- (Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (void)applyFilter:(Mat &)image filter:(int)filter
{
    // Do some OpenCV stuff with the image
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    if (0 == filter) {
        // Grey
        cvtColor(image_copy, image, CV_BGR2GRAY);
    } else if (1 == filter) {
        // Sepia
        Mat kern = (Mat_<float>(4,4) <<  0.272, 0.534, 0.131, 0,
                    0.349, 0.686, 0.168, 0,
                    0.393, 0.769, 0.189, 0,
                    0, 0, 0, 1);
        cv::transform(image_copy, image, kern);
    } else if (2 == filter) {
        // + 30% contrast, + 15% brigtness adjustment
        image_copy.convertTo(image_copy, -1, 1.3, 0.15);
        cvtColor(image_copy, image, CV_BGR2BGRA);
    } else if (3 == filter) {
        //TODO
    } else if (4 == filter) {
        //TODO
    } else if (5 == filter) {
        //TODO
    } else if (6 == filter) {
        //TODO
    } else if (7 == filter) {
        //TODO
    } else if (8 == filter) {
        //TODO
    }
}

@end
