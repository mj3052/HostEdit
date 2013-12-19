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
    NSString *file = [NSString stringWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *unparsedHosts = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *hosts = [NSMutableArray array];
    
    for (int i = 0; i < [unparsedHosts count]; i++) {
        @try {
            NSString *line = [unparsedHosts objectAtIndex:i];
            
            if(![[line substringToIndex:1]  isEqual: @"#"] && [line length] > 5) {
                //NSLog(@"%@",line);
                
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:nil];
                
                line = [regex stringByReplacingMatchesInString:line options:0 range:NSMakeRange(0, [line length]) withTemplate:@" "];
                line = [line stringByReplacingOccurrencesOfString:@"	" withString:@" "];
                
                NSArray *singleHost = [line componentsSeparatedByString:@" "];
                
                
                [hosts addObject:singleHost];
                
            }
        }
        @catch (NSException *exception) {
            
        }
        
        
    }
    
    return hosts;
}

- (void)writeHostsFromArray:(NSMutableArray *)hosts
{
    NSMutableArray *lines = [NSMutableArray array];
    
    for (int i = 0; i < [hosts count]; i++) {
        NSString *ip = [[hosts objectAtIndex:i] objectAtIndex:0];
        NSString *host = [[hosts objectAtIndex:i] objectAtIndex:1];
        
        NSString *line = [[[ip stringByAppendingString:@"    "] stringByAppendingString:host] stringByAppendingString:@"\n"];
        
        [lines addObject:line];
        
    }
    
    NSString *file = @"";
    
    for (int i = 0; i < [lines count]; i++) {
        file = [file stringByAppendingString:[lines objectAtIndex:i]];
    }
    NSLog(@"%@", file);
    
    id blTmp = [BLAuthentication sharedInstance];
    
    NSString *myCommand = @"/bin/cp";
    
    [file writeToFile:@"/tmp/hosts" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSArray *para = [[NSArray alloc] initWithObjects:@"/tmp/hosts", @"/etc/hosts", nil];
    
    [blTmp authenticate:myCommand];
    
    if([blTmp isAuthenticated:myCommand] == true) {
        NSLog(@"Authenticated");
        [blTmp executeCommandSynced:myCommand withArgs:para];
        
    } else { NSLog(@"Not Authenticated"); }
    
    
    
}


@end
