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

-(void)convertToMp4
{
   NSArray *argumentsArray = [NSArray arrayWithObjects:@"-i", [self.videoURL path], @"-o", [self.resultVideoURL path], @"--preset", @"AppleTV",  nil];
   
   NSTask *task = [[NSTask alloc] init];
   [task setArguments:argumentsArray];
   [task setLaunchPath:@"~/bin/HandBrakeCLI"];
   [task launch];
   [task waitUntilExit];
}

-(void)addToITunes
{
   iTunesInterface *interface = [[iTunesInterface alloc] init];
   [interface addVideoToiTunes:self.resultVideoURL];
   [[NSFileManager defaultManager] removeItemAtURL:self.resultVideoURL error:NULL];
}

-(void)go
{
   [self convertToMp4];
   [self addToITunes];
   
}

@end
