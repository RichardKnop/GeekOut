//
//  Filter.h
//  GeekOut
//
//  Created by Richard Knop on 09/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface Filter : NSObject

- (GPUImageOutput<GPUImageInput> *)getFilter:(NSString *)filterName;

@end
