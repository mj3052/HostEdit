//
//  hostsManager.m
//  HostEdit
//
//  Created by Mathias Jensen on 19/12/13.
//  Copyright (c) 2013 Mathias Jensen. All rights reserved.
//

#import "hostsManager.h"

@implementation hostsManager


- (NSMutableArray *)getHostsAsArray
{
    
    // Get the user's hosts file, read it as UTF8
    NSString *file = [NSString stringWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:nil];
    
    // Split by newlines, ready for parsing
    NSArray *unparsedHosts = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    // Create a readable array for containing the ip/host
    NSMutableArray *hosts = [NSMutableArray array];
    
    // For the number of lines in hosts
    for (int i = 0; i < [unparsedHosts count]; i++) {
        // We try/catch as there may be unexpected content in the file, we don't want a crash.
        @try {
            // Get the line we're working with
            NSString *line = [unparsedHosts objectAtIndex:i];
            
            // Make sure line isn't a comment
            if(![[line substringToIndex:1]  isEqual: @"#"] && [line length] > 5) {
                
                // Regex for removing one+ spaces
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:nil];
                
                // Use the regex for removing spaces, replacing them with a single one
                line = [regex stringByReplacingMatchesInString:line options:0 range:NSMakeRange(0, [line length]) withTemplate:@" "];
                
                // Also replace tabs with spaces, we don't want them
                line = [line stringByReplacingOccurrencesOfString:@"	" withString:@" "];
                
                /* 
                 Seperate the line in ip/host where there is a space
                 The hosts are currently looking like this:
                 127.0.0.0 example.com
                 */
                NSArray *singleHost = [line componentsSeparatedByString:@" "];
                
                // Add the parsed line to the hosts array
                [hosts addObject:singleHost];
                
            }
        }
        @catch (NSException *exception) {
            // Catch by doing nothing, for now.
        }
        
        
    }
    
    return hosts;
}

- (void)writeHostsFromArray:(NSMutableArray *)hosts
{
    // Create an array for containing the single line for the files we want to generate
    NSMutableArray *lines = [NSMutableArray array];
    
    // For the number of hosts
    for (int i = 0; i < [hosts count]; i++) {
        
        // Get the IP as a string
        NSString *ip = [[hosts objectAtIndex:i] objectAtIndex:0];
        // Get the domain/host as a string
        NSString *host = [[hosts objectAtIndex:i] objectAtIndex:1];
        
        // Generate the file one line at a time
        NSString *line = [[[ip stringByAppendingString:@"    "] stringByAppendingString:host] stringByAppendingString:@"\n"];
        
        // Add the line to the array containing them
        [lines addObject:line];
        
    }
    
    // Create an empty string for the file
    NSString *file = @"";
    
    // For the number of lines
    for (int i = 0; i < [lines count]; i++) {
        // Insert them in the file string
        file = [file stringByAppendingString:[lines objectAtIndex:i]];
    }
    
    // Get ready for write authentication using BLAuthentication
    id blTmp = [BLAuthentication sharedInstance];
    
    // We want to copy using the unix tool cp
    NSString *command = @"/bin/cp";
    
    // Write the file to /tmp/ in UTF8
    [file writeToFile:@"/tmp/hosts" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Create the parameters for the cp command
    NSArray *para = [[NSArray alloc] initWithObjects:@"/tmp/hosts", @"/etc/hosts", nil];
    
    // Get authentication for writing to /etc/
    [blTmp authenticate:command];
    
    // If we have authentication
    if([blTmp isAuthenticated:command] == true) {
        NSLog(@"Authenticated");
        
        // Copy the file from /tmp/ to /etc/ using the command
        [blTmp executeCommandSynced:command withArgs:para];
        
    } else {
        
        // If it isn't authenticated don't try to copy the file (we can't)
        // An error could be added, not necessary
        NSLog(@"Not Authenticated"); }
    
    
    
}


@end
