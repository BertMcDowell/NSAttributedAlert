//
//  AppDelegate.h
//  AttributedAlert
//
//  Created by Robert McDowell on 25/10/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSTextView * _message;
    IBOutlet NSPopUpButton * _messageType;
    IBOutlet NSTextView * _information;
    IBOutlet NSPopUpButton * _informationType;
    
    IBOutlet NSButton * _iconEnabled;
    IBOutlet NSButton * _accesoryViewEnabled;
    IBOutlet NSButton * _sheet;
    IBOutlet NSPopUpButton * _buttons;
    IBOutlet NSPopUpButton * _style;
    
    IBOutlet NSTextField * _code;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)alert:(id)sender;

- (IBAction)attributedAlert:(id)sender;

@end
