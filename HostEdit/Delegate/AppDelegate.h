//
//  AppDelegate.h
//  HostEdit
//
//  Created by Mathias Jensen on 19/12/13.
//  Copyright (c) 2013 Mathias Jensen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HostsManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSMutableArray *hosts;

@end
