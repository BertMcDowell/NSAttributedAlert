//
//  AppDelegate.m
//  AttributedAlert
//
//  Created by Robert McDowell on 25/10/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import "AppDelegate.h"
#import "NSAttributedAlert.h"

static NSString * message = @"This is an alert message";
static NSString * information = @"This is the Informative Text.\n\nWith a link in it <a href=\"www.google.com\">Google</a>\n\ntext text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_message setString:message];
    [_information setString:information];
    
    [_buttons removeAllItems];
    for ( int i=0; i<10; i++ )
    {
        [_buttons addItemWithTitle:[@(i) stringValue]];
    }
    
    [_style removeAllItems];
    [_style addItemsWithTitles:@[@"NSWarningAlertStyle", @"NSInformationalAlertStyle", @"NSCriticalAlertStyle"]];
}

- (IBAction)alert:(id)sender
{
    NSAlert * alert = [[NSAlert alloc] init];
    [alert setMessageText:[_message string]];
    [alert setInformativeText:[_information string]];
    for (int i=0; i<[_buttons indexOfItem:[_buttons selectedItem]]; i++) {
        [alert addButtonWithTitle:[NSNumberFormatter localizedStringFromNumber:@(i) numberStyle:NSNumberFormatterSpellOutStyle]];
    }
    if ( [_iconEnabled state] == 0 )
    {
        [alert setIcon:nil];
    }
    else
    {
        [alert setIcon:[[NSApplication sharedApplication] applicationIconImage]];
    }
    if ( [_accesoryViewEnabled state] != 0)
    {
        NSTextField * field = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 500, 40)];
        [field setStringValue:@"AccessoryView that can be added to an alert."];
        [alert setAccessoryView:field];
    }
    
    [alert setAlertStyle:[_style indexOfItem:[_style selectedItem]]];
    
    if ( [_sheet state] == 0 )
    {
        NSInteger val = [alert runModal];
        [_code setStringValue:[@(val) stringValue]];
    }
    else
    {
        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
    }
}

- (IBAction)attributedAlert:(id)sender
{
    NSAttributedAlert * alert = [[NSAttributedAlert alloc] init];

    switch ([_messageType indexOfItem:[_messageType selectedItem]]) {
        case 0:
            [alert setMessageText:[_message string]];
            break;
        case 1:
            [alert setMessageText:[_message string] containsHtml:YES];
            break;
        case 2:
            [alert setMessageAttributedText:[_message attributedString]];
            break;
        default:
            break;
    }
    
    switch ([_informationType indexOfItem:[_informationType selectedItem]]) {
        case 0:
            [alert setInformativeText:[_information string]];
            break;
        case 1:
            [alert setInformativeText:[_information string] containsHtml:YES];
            break;
        case 2:
            [alert setInformativeAttributedText:[_information attributedString]];
            break;
        default:
            break;
    }
    for (int i=0; i<[_buttons indexOfItem:[_buttons selectedItem]]; i++) {
        [alert addButtonWithTitle:[NSNumberFormatter localizedStringFromNumber:@(i) numberStyle:NSNumberFormatterSpellOutStyle]];
    }
    if ( [_iconEnabled state] == 0 )
    {
        [alert setIcon:nil];
    }
    else
    {
        [alert setIcon:[[NSApplication sharedApplication] applicationIconImage]];
    }
    if ( [_accesoryViewEnabled state] != 0)
    {
        NSTextField * field = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 500, 40)];
        [field setStringValue:@"AccessoryView that can be added to an alert."];
        [alert setAccessoryView:field];
    }

    if ( [_sheet state] == 0 )
    {
        NSInteger val = [alert runModal];
        [_code setStringValue:[@(val) stringValue]];
    }
    else
    {
        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
    }
}

@end
