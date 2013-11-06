//
//  NSAttributedAlert.h
//  AttributedAlert
//
//  Created by Robert McDowell on 25/10/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAttributedAlert : NSPanel

- (id) init;

- (NSImage*) icon;
- (void) setIcon:(NSImage*)image;

- (NSArray*) buttons;
- (void) addButtonWithTitle:(NSString*)title;

- (void) setMessageText:(NSString*)text;
- (void) setMessageText:(NSString*)text containsHtml:(BOOL)state;
- (void) setMessageAttributedText:(NSAttributedString*)text;

- (void) setInformativeText:(NSString*)text;
- (void) setInformativeText:(NSString*)text containsHtml:(BOOL)state;
- (void) setInformativeAttributedText:(NSAttributedString*)text;

- (void)setAccessoryView:(NSView *)view;
- (NSView *)accessoryView;

- (void) layout;

- (NSInteger) runModal;

- (void)beginSheetModalForWindow:(NSWindow *)window
                   modalDelegate:(id)modalDelegate
                  didEndSelector:(SEL)alertDidEndSelector
                     contextInfo:(void *)contextInfo;
@end
