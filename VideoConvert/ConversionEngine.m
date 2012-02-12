//
//  ConversionEngine.m
//  VideoConvert
//
//  Created by Jim Dusseau on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConversionEngine.h"
#import "iTunesInterface.h"
#import "HandbrakeWrapper.h"

@implementation ConversionEngine

@synthesize videoURL;

-(void)doConversion
{
   NSLog(@"\n\n\n********** Beginning work on %@ **********", self.videoURL);
   
   HandbrakeWrapper *handbrakeWrapper = [[HandbrakeWrapper alloc] init];
   NSURL *convertedFileUrl = [handbrakeWrapper convertVideoURL:self.videoURL usingPreset:@"AppleTV" newExtension:@"m4v"];
   if(convertedFileUrl)
   {
      NSLog(@"********** Adding to iTunes **********");
      
      iTunesInterface *interface = [[iTunesInterface alloc] init];
      [interface addVideoToiTunes:convertedFileUrl];
      [[NSFileManager defaultManager] removeItemAtURL:convertedFileUrl error:NULL];
   }
}

@end
