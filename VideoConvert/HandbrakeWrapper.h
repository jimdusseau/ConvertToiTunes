//
//  HandbrakeWrapper.h
//  VideoConvert
//
//  Created by Jim Dusseau on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandbrakeWrapper : NSObject

-(NSURL *)convertVideoURL:(NSURL *)sourceVideoURL usingPreset:(NSString *)preset newExtension:(NSString *)newExtension;

@end
