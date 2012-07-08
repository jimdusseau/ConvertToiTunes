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
   NSRegularExpression *seasonRegex = [NSRegularExpression regularExpressionWithPattern:@"S(\\d+)E(\\d+)" options:NSRegularExpressionCaseInsensitive error:&regexError];
   if(!seasonRegex)
   {
      NSLog(@"Season Regex Error: %@", regexError);
      return nil;
   }
   
   NSRegularExpression *dateRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\d\\d\\d\\d)\\.(\\d\\d\\.\\d\\d)" options:NSRegularExpressionCaseInsensitive error:&regexError];
   if(!dateRegex)
   {
      NSLog(@"Date Regex Error: %@", regexError);
      return nil;
   }
   
   return @[seasonRegex, dateRegex];
}

- (TrackInfo *)trackInfoFromFileName:(NSString *)fileName
{
   NSAssert(self.regexArray && [self.regexArray count] > 0, @"RegexArray must exist and have one or more objects");
   
   TrackInfo *trackInfo = nil;
   for (NSRegularExpression *regex in self.regexArray)
   {
      NSString *searchString = fileName;
      NSTextCheckingResult *result = [regex firstMatchInString:searchString options:0 range:NSMakeRange(0, [searchString length])];
      
      NSLog(@"Result %@ for regex %@\n", result, regex);
      if(result && result.numberOfRanges == 3)
      {
         NSRange seasonRange = [result rangeAtIndex:1];
         NSRange episodeRange = [result rangeAtIndex:2];
         
         NSString *showName = [searchString substringWithRange:NSMakeRange(0, seasonRange.location-1)];
         showName = [showName stringByReplacingOccurrencesOfString:@"." withString:@" "];
         showName = [showName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         
         NSInteger seasonNumber = [[searchString substringWithRange:seasonRange] integerValue];
         NSInteger episodeNumber = [[[searchString substringWithRange:episodeRange] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
         
         
         
         trackInfo = [[TrackInfo alloc] init];
         
         trackInfo.seasonNumber = seasonNumber;
         trackInfo.episodeNumber = episodeNumber;
         trackInfo.show = showName;
      }
      
      if(trackInfo)
      {
         break;
      }
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
