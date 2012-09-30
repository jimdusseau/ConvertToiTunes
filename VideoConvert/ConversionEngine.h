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

@property NSURL *videoURL;
@property NSArray *excludededFileExtensions;
@property NSArray *passthroughFileExtensions;

-(void)doConversion;

@end
