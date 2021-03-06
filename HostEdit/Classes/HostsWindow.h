//
//  hostsWindow.h
//  HostEdit
//
//  Created by Mathias Jensen on 19/12/13.
//  Copyright (c) 2013 Mathias Jensen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HostsManager.h"
#import "AppDelegate.h"

@interface HostsWindow : NSWindow <NSTableViewDataSource, NSTableViewDelegate>
- (IBAction)saveButtonClick:(id)sender;
- (IBAction)addClick:(id)sender;
- (IBAction)deleteClick:(id)sender;
- (IBAction)refreshClick:(id)sender;
- (IBAction)menuSave:(id)sender;
- (IBAction)menuRefresh:(id)sender;
- (IBAction)menuAddRow:(id)sender;
- (IBAction)menuDeleteRow:(id)sender;
@property (weak) IBOutlet NSTableView *TableView;

@property (readwrite) bool tableHasChanged;

@end
