//
//  iTunesInterfaceTests.m
//  VideoConvert
//
//  Created by Jim Dusseau on 7/8/12.
//
//

#import "iTunesInterfaceTests.h"


#import "TrackInfo.h"
#import "iTunesInterface.h"
#import "STAssertAdditions.h"

@interface iTunesInterface (UnitTestingMethods)

- (TrackInfo *)trackInfoFromFileName:(NSString *)fileName;

@end

@implementation iTunesInterfaceTests

-(void)testWhenGivenSeasonFormattedFileName_seasonAndEpisodeWillBeSetOnTrack
{
   NSString *testFileName = @"Some.Show.S01E01.FORMAT-WHATEVER.AVI";
   NSString *expectedShowName = @"Some Show";
   NSInteger expectedSeasonNumber = 1;
   NSInteger expectedEpisodeNumber = 1;

   
   iTunesInterface *interface = [[iTunesInterface alloc] init];
   TrackInfo *trackInfo = [interface trackInfoFromFileName:testFileName];
   
   STAssertEqualStrings(expectedShowName, trackInfo.show);
   STAssertEquals(expectedSeasonNumber, trackInfo.seasonNumber, nil);
   STAssertEquals(expectedEpisodeNumber, trackInfo.episodeNumber, nil);
}

-(void)testWhenGivenDateFormattedFileName_ShowAndDateWillBeSetOnTrack
{
   NSString *testFileName = @"Some.Show.2012.06.25.FORMAT-WHATEVER.AVI";
   NSString *expectedShowName = @"Some Show";
   NSInteger expectedSeasonNumber = 2012;
   NSInteger expectedEpisodeNumber = 625;
   
   
   iTunesInterface *interface = [[iTunesInterface alloc] init];
   TrackInfo *trackInfo = [interface trackInfoFromFileName:testFileName];
   
   STAssertEqualStrings(expectedShowName, trackInfo.show);
   STAssertEquals(expectedSeasonNumber, trackInfo.seasonNumber, nil);
   STAssertEquals(expectedEpisodeNumber, trackInfo.episodeNumber, nil);
}


@end
