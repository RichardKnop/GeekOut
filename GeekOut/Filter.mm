//
//  Filter.m
//  GeekOut
//
//  Created by Richard Knop on 09/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "Filter.h"

@implementation Filter

- (GPUImageOutput<GPUImageInput> *)getFilter:(int)filter
{
    if (0 == filter) {
        return [[GPUImageSepiaFilter alloc] init];
    } else if (1 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    } else if (2 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    } else if (3 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    } else if (4 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    } else if (5 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    } else if (6 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    } else if (7 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    } else if (8 == filter) {
        return [[GPUImageGammaFilter alloc] init];
    }
    return [[GPUImageGammaFilter alloc] init];
}

@end
