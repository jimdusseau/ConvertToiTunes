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
      if(argc == 2)
      {
         NSString *logPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Logs/VideoConvert.log"];
         freopen([logPath fileSystemRepresentation], "a", stderr);
         
         NSString *path = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
         NSURL *pathURL = [NSURL fileURLWithPath:path];
         
         NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[path lastPathComponent]];
         tempPath  = [[tempPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"m4v"];
         NSURL *resultURL = [NSURL fileURLWithPath:tempPath];
         
         ConversionEngine *engine = [[ConversionEngine alloc] init];
         engine.videoURL = pathURL;
         engine.resultVideoURL = resultURL;
         
         [engine go];
      }
      else
      {
         NSString *appName = [NSString stringWithCString:argv[0] encoding:NSUTF8StringEncoding];
         NSLog(@"Expected 1 argument! %@ [path to video] ", appName);
      }
      
   }
   return 0;
}

