//
//  ConversionEngine.m
//  VideoConvert
//
//  Created by Jim Dusseau on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConversionEngine.h"
#import "iTunesInterface.h"

@implementation ConversionEngine

@synthesize videoURL, resultVideoURL;

-(BOOL)convertToMp4
{
   NSArray *argumentsArray = [NSArray arrayWithObjects:@"-i", [self.videoURL path], @"-o", [self.resultVideoURL path], @"--preset", @"AppleTV",  nil];
   
   NSTask *task = [[NSTask alloc] init];
   [task setArguments:argumentsArray];
   [task setLaunchPath:@"~/bin/HandBrakeCLI"];
   [task launch];
   
   NSLog(@"********** Writing Converted File to: %@ **********", self.resultVideoURL);
   
   [task waitUntilExit];
   
   int status = [task terminationStatus];
   if (status == 0)
   {
      NSLog(@"Convert Succeeded.");
      return YES;
   }
   else
   {
      NSLog(@"********** Warning: Convert Failed **********");
      return NO;
   }
}

-(void)addToITunes
{
   iTunesInterface *interface = [[iTunesInterface alloc] init];
   [interface addVideoToiTunes:self.resultVideoURL];
   [[NSFileManager defaultManager] removeItemAtURL:self.resultVideoURL error:NULL];
}

-(void)go
{
   NSLog(@"\n\n\n");
   NSLog(@"********** Beginning work on %@ **********", self.videoURL);
   
   BOOL convertSucceeded = [self convertToMp4];
   if(convertSucceeded)
   {
      NSLog(@"********** Adding to iTunes **********");
      [self addToITunes];
   }
}

@end
