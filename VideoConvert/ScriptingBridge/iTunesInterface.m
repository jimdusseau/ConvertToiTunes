//
//  iTunesInterface.m
//  VideoConvert
//
//  Created by Jim Dusseau on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iTunesInterface.h"

#import "iTunes.h"
#import "TrackInfo.h"

@interface iTunesInterface ()

@property (retain) NSArray *regexArray;

@end

@implementation iTunesInterface

- (id)init
{
   self = [super init];
   if (self) {
      self.regexArray = [self fileMatcherRegexArray];
   }
   return self;
}

-(NSArray *)fileMatcherRegexArray
{
   NSError *regexError = nil;
   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"S(\\d+)E(\\d+)" options:NSRegularExpressionCaseInsensitive error:&regexError];
   if(!regex)
   {
      NSLog(@"Regex Error: %@", regexError);
      return nil;
   }
   
   return @[regex];
}

- (TrackInfo *)trackInfoFromFileName:(NSString *)fileName
{
   NSAssert(self.regexArray && [self.regexArray count] == 1, @"RegexArray must exist and contain exactly one object");
   NSRegularExpression *regex = [self.regexArray objectAtIndex:0];
   
   NSString *searchString = fileName;
   NSTextCheckingResult *result = [regex firstMatchInString:searchString options:0 range:NSMakeRange(0, [searchString length])];
   
   TrackInfo *trackInfo = nil;
   if(result && result.numberOfRanges == 3)
   {
      NSRange seasonRange = [result rangeAtIndex:1];
      NSRange episodeRange = [result rangeAtIndex:2];
      
      NSString *showName = [searchString substringWithRange:NSMakeRange(0, seasonRange.location-2)];
      showName = [showName stringByReplacingOccurrencesOfString:@"." withString:@" "];
      
      NSInteger seasonNumber = [[searchString substringWithRange:seasonRange] integerValue];
      NSInteger episodeNumber = [[searchString substringWithRange:episodeRange] integerValue];
      
      
      
      trackInfo = [[TrackInfo alloc] init];
      
      trackInfo.seasonNumber = seasonNumber;
      trackInfo.episodeNumber = episodeNumber;
      trackInfo.show = showName;
   }
   return trackInfo;
}

-(void)setMetaDataFromFileName:(NSString *)fileName onTrack:(iTunesTrack *)track
{
   TrackInfo *trackInfo;
   trackInfo = [self trackInfoFromFileName:fileName];
   
   if(trackInfo)
   {
      NSLog(@"Setting season number: %ld episode number: %ld show name: %@ on track: %@", trackInfo.seasonNumber, trackInfo.episodeNumber, trackInfo.show, track);
      
      track.seasonNumber = trackInfo.seasonNumber;
      track.episodeNumber = trackInfo.episodeNumber;
      track.show = trackInfo.show;
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
