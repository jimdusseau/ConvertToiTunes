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


-(BOOL)doConversion
{
   NSLog(@"\n\n\n********** Beginning work on %@ **********", self.videoURL);
   
   if([_excludededFileExtensions containsObject:[self.videoURL pathExtension]])
   {
      NSLog(@"********** Stopping convert because the path extension is on the excluded list. **********\n\n");
      return YES;
   }
   
   BOOL shouldConvertVideo = [_passthroughFileExtensions containsObject:[self.videoURL pathExtension]];
   NSURL *convertedFileUrl = nil;
   if(shouldConvertVideo) {
      NSLog(@"********** Not converting because the extension is on the passthrough list. **********\n\n");
      convertedFileUrl = self.videoURL;
   }
   else {
      HandbrakeWrapper *handbrakeWrapper = [[HandbrakeWrapper alloc] init];
      convertedFileUrl = [handbrakeWrapper convertVideoURL:self.videoURL usingPreset:@"AppleTV 3" newExtension:@"m4v"];
   }
   
   if(convertedFileUrl) {
      [self addToiTunes:convertedFileUrl];
      
      if(!shouldConvertVideo) {
         [[[NSFileManager alloc] init] removeItemAtURL:convertedFileUrl error:NULL];
      }
   }
   
   return convertedFileUrl != nil;
}

-(void)addToiTunes:(NSURL *)convertedFileUrl {
   NSLog(@"********** Adding to iTunes **********\n");
   
   iTunesInterface *interface = [[iTunesInterface alloc] init];
   [interface addVideoToiTunes:convertedFileUrl];
}

@end
