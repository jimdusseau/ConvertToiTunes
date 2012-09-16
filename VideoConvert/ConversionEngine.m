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
@synthesize excludededFileExtensions;

-(void)doConversion
{
   NSLog(@"\n\n\n********** Beginning work on %@ **********", self.videoURL);
   
   if([excludededFileExtensions containsObject:[self.videoURL pathExtension]])
   {
      NSLog(@"********** Stopping convert because the path extension is on the excluded list. **********\n\n");
      return;
   }
   
   HandbrakeWrapper *handbrakeWrapper = [[HandbrakeWrapper alloc] init];
   NSURL *convertedFileUrl = [handbrakeWrapper convertVideoURL:self.videoURL usingPreset:@"AppleTV 3" newExtension:@"m4v"];
   if(convertedFileUrl)
   {
      NSLog(@"********** Adding to iTunes **********");
      
      iTunesInterface *interface = [[iTunesInterface alloc] init];
      [interface addVideoToiTunes:convertedFileUrl];
      [[NSFileManager defaultManager] removeItemAtURL:convertedFileUrl error:NULL];
   }
}

@end
