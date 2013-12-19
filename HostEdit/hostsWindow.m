//
//  hostsWindow.m
//  HostEdit
//
//  Created by Mathias Jensen on 19/12/13.
//  Copyright (c) 2013 Mathias Jensen. All rights reserved.
//

#import "hostsWindow.h"

@implementation hostsWindow

- (void)awakeFromNib
{
    [_TableView setDoubleAction:@selector(addClick:)];
    
    [_TableView setAction:@selector(doClickEdit:)];
    [_TableView setAllowsColumnSelection:NO];
    _tableHasChanged = NO;
}

- (IBAction)saveButtonClick:(id)sender {
    hostsManager *manager = [[hostsManager alloc] init];
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    
    NSMutableArray *array = delegate.hosts;
    
    [manager writeHostsFromArray:array];
}

- (IBAction)addClick:(id)sender {
    _tableHasChanged = YES;
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    
    [delegate.hosts addObject:[NSMutableArray arrayWithObjects:@"ip", @"host", nil]];
    [_TableView reloadData];
    
    NSMutableArray *hosts = delegate.hosts;
    
    
    
    [_TableView editColumn:0 row:[hosts count]-1 withEvent:nil select:YES];
}

- (IBAction)deleteClick:(id)sender {
    _tableHasChanged = YES;
    NSInteger row = _TableView.selectedRow;
    [_TableView editColumn:-1 row:-1 withEvent:nil select:NO];
    if(row != -1) {
        AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
        [delegate.hosts removeObjectAtIndex:row];
        [_TableView reloadData];
    }
    
}

- (IBAction)refreshClick:(id)sender {
    hostsManager *manager = [[hostsManager alloc] init];
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    
    NSMutableArray *refreshedHosts = [manager getHostsAsArray];
    
    if(_tableHasChanged) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Reload"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Be careful..."];
        [alert setInformativeText:@"If you reload changes will be lost."];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            delegate.hosts = refreshedHosts;
            [_TableView reloadData];
            _tableHasChanged = NO;
        }
        
    } else {
        delegate.hosts = refreshedHosts;
        [_TableView reloadData];
        _tableHasChanged = NO;
    }
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    NSMutableArray *delegatehosts = [NSMutableArray arrayWithArray:delegate.hosts];
    
    if([delegatehosts count] != 0) {
        return [delegate.hosts count];
    } else {
        hostsManager *manager = [[hostsManager alloc] init];
        
        NSMutableArray *hosts = [manager getHostsAsArray];
        
        return [hosts count];
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:
(NSInteger)row {
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];

    if([tableColumn.identifier  isEqual: @"ip"]) {
        return [[delegate.hosts objectAtIndex:row] objectAtIndex:0];
    }
    else if([tableColumn.identifier  isEqual: @"host"]) {
        return [[delegate.hosts objectAtIndex:row] objectAtIndex:1];
    } else
    {
        return @"Error";
    }
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    @try {
        _tableHasChanged = YES;
        
        NSLog(@"SetObject");
        AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
        
        //NSArray *currentObject = [delegate.hosts objectAtIndex:rowIndex];
        
        NSMutableArray *newObject = [NSMutableArray array];

        if([aTableColumn.identifier  isEqual: @"ip"]) {
            NSLog(@"First");
            NSString *host = [[delegate.hosts objectAtIndex:rowIndex] objectAtIndex:1];
            
            newObject = [NSMutableArray arrayWithObjects:anObject, host, nil];
            
        }
        else {
            NSString *ip = [[delegate.hosts objectAtIndex:rowIndex] objectAtIndex:0];
            
            newObject = [NSMutableArray arrayWithObjects:ip, anObject, nil];
        }
        
        [delegate.hosts replaceObjectAtIndex:rowIndex withObject:newObject];
        
    }
    @catch (NSException *exception) {
        
    }


}

- (void)doClickEdit:(id)sender
{
    NSInteger row = [_TableView clickedRow];
    NSInteger column = [_TableView clickedColumn];
    
    [_TableView editColumn:column row:row withEvent:nil select:YES];
}




@end