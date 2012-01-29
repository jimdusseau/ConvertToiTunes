//
//  ConversionEngine.h
//  VideoConvert
//
//  Created by Jim Dusseau on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversionEngine : NSObject
{
   
}

@property (retain, nonatomic) NSURL *videoURL;
@property (retain, nonatomic) NSURL *resultVideoURL;

-(void)go;

@end
