//
//  hostsWindow.m
//  HostEdit
//
//  Created by Mathias Jensen on 19/12/13.
//  Copyright (c) 2013 Mathias Jensen. All rights reserved.
//

#import "hostsWindow.h"

@implementation HostsWindow

- (void)awakeFromNib
{
    [_TableView setDoubleAction:@selector(addClick:)];
    
    [_TableView setAction:@selector(doClickEdit:)];
    [_TableView setAllowsColumnSelection:NO];
    _tableHasChanged = NO;
}

- (IBAction)saveButtonClick:(id)sender {
    [self save];
}

- (IBAction)addClick:(id)sender {
    [self addRow];
}

- (IBAction)deleteClick:(id)sender {
    [self deleteRow];
}

- (IBAction)refreshClick:(id)sender {
    [self reload];
}

- (IBAction)menuSave:(id)sender {
    [self save];
}

- (IBAction)menuRefresh:(id)sender {
    [self reload];
}

- (IBAction)menuAddRow:(id)sender {
    [self addRow];
}

- (IBAction)menuDeleteRow:(id)sender {
    [self deleteRow];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    NSMutableArray *delegatehosts = [NSMutableArray arrayWithArray:delegate.hosts];
    
    if([delegatehosts count] != 0) {
        return [delegate.hosts count];
    } else {
        HostsManager *manager = [[HostsManager alloc] init];
        
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

- (void)save
{
    HostsManager *manager = [[HostsManager alloc] init];
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    
    NSMutableArray *array = delegate.hosts;
    
    [manager writeHostsFromArray:array];
}

- (void)addRow
{
    _tableHasChanged = YES;
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    
    [delegate.hosts addObject:[NSMutableArray arrayWithObjects:@"ip", @"host", nil]];
    [_TableView reloadData];
    
    NSMutableArray *hosts = delegate.hosts;
    [_TableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[hosts count]-1] byExtendingSelection:NO];
    
    [_TableView scrollToEndOfDocument:nil];
}

- (void)deleteRow
{
    _tableHasChanged = YES;
    NSInteger row = _TableView.selectedRow;
    [_TableView editColumn:-1 row:-1 withEvent:nil select:NO];
    if(row != -1) {
        AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
        [delegate.hosts removeObjectAtIndex:row];
        [_TableView reloadData];
        [_TableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[delegate.hosts count]-1] byExtendingSelection:NO];
    }
    [_TableView scrollToEndOfDocument:nil];
}

- (void)reload
{
    HostsManager *manager = [[HostsManager alloc] init];
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
    [_TableView deselectAll:nil];
    
}


@end
