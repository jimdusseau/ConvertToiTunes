//
//  HandbrakeWrapper.m
//  VideoConvert
//
//  Created by Jim Dusseau on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HandbrakeWrapper.h"

@implementation HandbrakeWrapper

-(NSURL *)outputUrlWithSourceFileName:(NSString *)sourceFileName newExtension:(NSString *)newExtension
{
   NSString *fileNameWithoutExtension = [sourceFileName stringByDeletingPathExtension];
   NSString *newFileName = [fileNameWithoutExtension stringByAppendingPathExtension:newExtension];
   
   NSURL *tempPathUrl = [NSURL fileURLWithPath:NSTemporaryDirectory()];
   
   NSURL *outputURL = [tempPathUrl URLByAppendingPathComponent:newFileName];
   
   return outputURL;
}

-(NSURL *)convertVideoURL:(NSURL *)sourceVideoURL usingPreset:(NSString *)preset newExtension:(NSString *)newExtension
{
   NSURL *outputURL = [self outputUrlWithSourceFileName:[sourceVideoURL lastPathComponent] newExtension:newExtension];
   
   //Credit Steven Frank: http://stevenf.com/notes/index.php/?Using+HandBrake+from+the+command+line
   NSArray *argumentsArray = [NSArray arrayWithObjects:
                              @"-i", [sourceVideoURL path],
                              @"-o", [outputURL path],
                              @"--preset", preset, nil];
   
   NSTask *task = [[NSTask alloc] init];
   [task setArguments:argumentsArray];
   [task setLaunchPath:@"~/bin/HandBrakeCLI"];
   [task launch];
   
   NSLog(@"********** Writing Converted File to: %@ **********", outputURL);
   
   [task waitUntilExit];
   
   int status = [task terminationStatus];
   if (status == 0)
   {
      NSLog(@"Convert Succeeded.");
      return outputURL;
   }
   else
   {
      NSLog(@"********** Warning: Convert Failed **********");
      return nil;
   }
}

@end
