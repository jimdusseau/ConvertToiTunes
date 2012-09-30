//
//  main.m
//  VideoConvert
//
//  Created by Jim Dusseau on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversionEngine.h"

int main (int argc, const char * argv[])
{
   @autoreleasepool
   {
      if(argc != 2)
      {
         NSString *appName = [NSString stringWithCString:argv[0] encoding:NSUTF8StringEncoding];
         NSLog(@"Expected 1 argument! %@ [path to video] ", appName);
         return 1;
      }
      
      NSString *path = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
      NSURL *pathURL = [NSURL fileURLWithPath:path];
      
      NSFileManager *fileManager = [[NSFileManager alloc] init];
      if(![fileManager fileExistsAtPath:path]) {
         NSLog(@"File not found at path: %@", path);
         return 1;
      }
      
      NSString *logPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Logs/VideoConvert.log"];
      freopen([logPath fileSystemRepresentation], "a", stderr);
      
      ConversionEngine *engine = [[ConversionEngine alloc] init];
      engine.excludededFileExtensions = [NSArray arrayWithObject:@"mkv"];
      engine.passthroughFileExtensions = @[@"mp4"];
      engine.videoURL = pathURL;
      BOOL conversionSuccess = [engine doConversion];
      
      if(conversionSuccess && [fileManager respondsToSelector:@selector(trashItemAtURL:resultingItemURL:error:)]) {
         NSLog(@"********** Trashing Original File **********\n");
         NSError *fileTrashingError = nil;
         NSURL *resultURL = nil;
         BOOL trashingSuccess = [fileManager trashItemAtURL:pathURL resultingItemURL:&resultURL error:&fileTrashingError];
         if(trashingSuccess) {
            NSLog(@"Successfully trashed %@ to %@", pathURL, resultURL);
         }
         else {
            NSLog(@"Trashing %@ failed with error %@", pathURL, fileTrashingError);
         }
      }
      
   }
   return 0;
}

