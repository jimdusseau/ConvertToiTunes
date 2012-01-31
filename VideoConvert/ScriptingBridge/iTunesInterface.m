//
//  iTunesInterface.m
//  VideoConvert
//
//  Created by Jim Dusseau on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iTunesInterface.h"
#import "iTunes.h"

@implementation iTunesInterface

-(void)setMetaDataFromFileName:(NSString *)fileName onTrack:(iTunesTrack *)track
{
   NSError *regexError = nil;
   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"S(\\d+)E(\\d+)" options:NSRegularExpressionCaseInsensitive error:&regexError];
   if(!regex)
   {
      NSLog(@"Regex Error: %@", regexError);
      return;
   }
   
   NSString *searchString = fileName;
   NSTextCheckingResult *result = [regex firstMatchInString:searchString options:0 range:NSMakeRange(0, [searchString length])];
   if(result && result.numberOfRanges == 3)
   {
      NSRange seasonRange = [result rangeAtIndex:1];
      NSRange episodeRange = [result rangeAtIndex:2];
      
      NSString *showName = [searchString substringWithRange:NSMakeRange(0, seasonRange.location-2)];
      showName = [showName stringByReplacingOccurrencesOfString:@"." withString:@" "];
      
      NSInteger seasonNumber = [[searchString substringWithRange:seasonRange] integerValue];
      NSInteger episodeNumber = [[searchString substringWithRange:episodeRange] integerValue];

      NSLog(@"Setting season number: %ld episode number: %ld show name: %@ on track: %@", seasonNumber, episodeNumber, showName, track);
      
      track.seasonNumber = seasonNumber;
      track.episodeNumber = episodeNumber;
      track.show = showName;
   }
}

-(void)addVideoToiTunes:(NSURL *)videoURL
{
   iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
   if(![iTunes isRunning])
   {
      [iTunes activate];
   }
   
   NSString* sourceMediaFile = [videoURL path];
   iTunesTrack * track = [iTunes add:[NSArray arrayWithObject:[NSURL fileURLWithPath:sourceMediaFile]] to:nil];
   NSLog(@"Added %@ to track: %@",sourceMediaFile,track);
   track.videoKind = iTunesEVdKTVShow;
   
   [self setMetaDataFromFileName:[sourceMediaFile lastPathComponent] onTrack:track];
}

@end
