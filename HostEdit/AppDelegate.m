//
//  AppDelegate.m
//  HostEdit
//
//  Created by Mathias Jensen on 19/12/13.
//  Copyright (c) 2013 Mathias Jensen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    hostsManager *manager = [[hostsManager alloc] init];
    
    _hosts = [manager getHostsAsArray];
    
}

@end
