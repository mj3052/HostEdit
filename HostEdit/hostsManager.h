//
//  hostsManager.h
//  HostEdit
//
//  Created by Mathias Jensen on 19/12/13.
//  Copyright (c) 2013 Mathias Jensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLAuthentication.h"

@interface hostsManager : NSObject

- (NSMutableArray *)getHostsAsArray;

- (void)writeHostsFromArray:(NSMutableArray *)hosts;

@end
