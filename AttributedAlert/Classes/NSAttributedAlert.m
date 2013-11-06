//
//  NSAttributedAlert.m
//  AttributedAlert
//
//  Created by Robert McDowell on 25/10/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import "NSAttributedAlert.h"

static const int edgeInsetLeft = 20;
static const int edgeInsetRight = 40;
static const int edgeInsetTop = 18;

static const int edgeButtonsInsetBottom = 16;
static const int edgeButtonsInsetRight = 16;

static const int spacingx = 20;
static const int spacingy = 10;

@implementation NSAttributedAlert
{
    NSImageView * _iconview;
    NSTextView * _messageview;
    NSTextView * _informationview;
    NSView * _accessoryView;
    
    NSButton * _defaultButton;
    NSMutableArray * _buttons;
    
    BOOL _needslayout;
    NSInteger _code;
}

#pragma -- Public Functions

- (id) init
{
    NSRect rect = NSMakeRect(0, 0, 420, 200);
    if ( self = [super initWithContentRect:rect
                                 styleMask:NSTitledWindowMask
                                   backing:NSBackingStoreBuffered
                                     defer:YES] )
    {
        _needslayout = YES;
        _buttons = [NSMutableArray array];
        
        [self setWorksWhenModal:YES];
        [self setBecomesKeyOnlyIfNeeded:YES];
        [self setFloatingPanel:YES];
        [self setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];
        
        _iconview = [[NSImageView alloc] initWithFrame:NSMakeRect(10, 120, 64, 64)];
        [_iconview setImage:[[NSApplication sharedApplication] applicationIconImage]];
        
        _messageview = [[NSTextView alloc] init];
        [_messageview setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
        [_messageview setFocusRingType:NSFocusRingTypeNone];
        [_messageview setDrawsBackground:NO];
        [_messageview setEditable:NO];
        [_messageview setSelectable:YES];
        [_messageview setHorizontallyResizable:NO];
        [_messageview setVerticallyResizable:YES];
        [_messageview setTextContainerInset:NSZeroSize];
        [[_messageview textContainer] setLineFragmentPadding:0.0f];
        [_messageview setToolTip:@""];
        [_messageview setFrame:NSMakeRect(84, 150, 300, 30)];
        [_messageview setHidden:YES];
        
        _informationview = [[NSTextView alloc] init];
        [_informationview setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
        [_informationview setFocusRingType:NSFocusRingTypeNone];
        [_informationview setDrawsBackground:NO];
        [_informationview setEditable:NO];
        [_informationview setSelectable:YES];
        [_informationview setHorizontallyResizable:NO];
        [_informationview setVerticallyResizable:YES];
        [_informationview setTextContainerInset:NSZeroSize];
        [[_informationview textContainer] setLineFragmentPadding:0.0f];
        [_informationview setToolTip:@""];
        [_informationview setFrame:NSMakeRect(84, 100, 300, 100)];
        [_informationview setAutoresizingMask:NSViewHeightSizable];
        [_informationview setHidden:YES];
        
        _defaultButton = [self createButtonWithTitle:NSLocalizedString(@"OK", nil)
                                         isKeyButton:YES];
        [self sizeToFitButton:_defaultButton];
    }
    return self;
}

- (NSImage*) icon
{
    return [_iconview image];
}

- (void) setIcon:(NSImage*)image
{
    [_iconview setImage:image];
}

- (NSArray*) buttons
{
    return _buttons;
}

- (void) addButtonWithTitle:(NSString*)title
{
    [_buttons addObject:[self createButtonWithTitle:title
                                        isKeyButton:( [_buttons count] == 0 )]];
}

- (void) setMessageText:(NSString*)text
{
    [_messageview setString:text];
    [_messageview setHidden:[_messageview string] <= 0];
}

- (void) setMessageText:(NSString*)text containsHtml:(BOOL)state
{
    if ( state )
    {
        [self setTextContent:_messageview WithHtml:text];
    }
    else
    {
        [_messageview setString:text];
    }
    [_messageview setHidden:[_messageview string] <= 0];
}

- (void) setMessageAttributedText:(NSAttributedString*)text
{
    [[_messageview textStorage] setValue:text];
    [_messageview setHidden:[_messageview string] <= 0];
}

- (void) setInformativeText:(NSString*)text
{
    [[_informationview textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:text]];
    [_informationview setHidden:[_informationview string] <= 0];
}

- (void) setInformativeText:(NSString*)text containsHtml:(BOOL)state
{
    if ( state )
    {
        [self setTextContent:_informationview WithHtml:text];
    }
    else
    {
        [_informationview setString:text];
    }
        [_informationview setHidden:[_informationview string] <= 0];
}

- (void) setInformativeAttributedText:(NSAttributedString*)text
{
    [[_informationview textStorage] setAttributedString:text];
    [_informationview setHidden:[_informationview string] <= 0];
}

- (void)setAccessoryView:(NSView *)view
{
    [_accessoryView removeFromSuperview];
    _accessoryView = view;
}

- (NSView *)accessoryView
{
    return _accessoryView;
}

- (void) layout
{
    _needslayout = NO;
    
    [self sizeButtonsToFit];
    [self sizeContentToFit];
    [self panelSizeToFit];
    
    [self layoutPanelButtons];
    [self layoutPanelContents];
}

- (NSInteger) runModal
{
    [self setupContentIfNeeded];
    
    return [[NSApplication sharedApplication] runModalForWindow: self];
}

- (void)beginSheetModalForWindow:(NSWindow *)window
                   modalDelegate:(id)modalDelegate
                  didEndSelector:(SEL)alertDidEndSelector
                     contextInfo:(void *)contextInfo
{
    [self setupContentIfNeeded];
    // TODO : Repace this call as it's depricated in the 10.9 sdk
    [[NSApplication sharedApplication] beginSheet: self
                                   modalForWindow: window
                                    modalDelegate: modalDelegate
                                   didEndSelector: alertDidEndSelector
                                      contextInfo: contextInfo];
    [[NSApplication sharedApplication] runModalForWindow: self];
}

#pragma mark -- Private Functions

- (void) setupContentIfNeeded
{
    if ( _needslayout )
    {
        [self layout];
    }
    
    //[_messageview setNeedsLayout:YES];
    [_messageview resetCursorRects];
    [_messageview setToolTip:@""];
    
    [self disableCursorRects];
    //[self enableCursorRects];
    //[self resetCursorRects];
}

- (void) sizeContentToFit
{
    float width = [self contentWidth];
    if ( _accessoryView )
    {
        float widthOfAccessoryView = [_accessoryView frame].size.width;
        if ( widthOfAccessoryView > width )
        {
            float diff = widthOfAccessoryView - width;
            NSRect frame = [_contentView frame];
            frame.size.width += diff;
            [_contentView setFrame:frame];
            
            frame = [self frame];
            frame.size.width += diff;
            [self setFrame:frame display:NO];
            
            width = widthOfAccessoryView;
        }
    }
    
    NSRect messageFrame = [_messageview frame];
    NSRect informationFrame = [_informationview frame];
    
    messageFrame.size.width = width;
    informationFrame.size.width = width;
    
    [_messageview setFrame:messageFrame];
    [_informationview setFrame:informationFrame];
    
    [_messageview sizeToFit];
    [_informationview sizeToFit];
}

- (void) panelSizeToFit
{
    NSRect rect = [_contentView frame];
    float diff = [self frame].size.height - rect.size.height;
    
    rect.size.height = edgeInsetTop;
    if ( ![_messageview isHidden] )
    {
        rect.size.height += [_messageview frame].size.height;
        rect.size.height += spacingy;
    }
    if ( ![_informationview isHidden] )
    {
        rect.size.height += [_informationview frame].size.height;
        rect.size.height += spacingy;
    }
    if ( _accessoryView )
    {
        rect.size.height += [_accessoryView frame].size.height;
        rect.size.height += spacingy;
    }
    if ( [_buttons count] > 0 )
    {
        rect.size.height += [[_buttons objectAtIndex:0] frame].size.height;
    }
    else
    {
        rect.size.height += [_defaultButton frame].size.height;
    }
    rect.size.height += edgeButtonsInsetBottom;
    [_contentView setFrame:rect];
    
    rect.size.height += diff;
    [self setFrame:rect display:YES];
}

- (void) layoutPanelContents
{
    NSRect rect = [_contentView frame];

    CGPoint offset = CGPointMake(edgeInsetLeft, rect.size.height - edgeInsetTop);
    if ( [_iconview image] )
    {
        NSRect frame = [_iconview frame];
        frame.origin.x = offset.x;
        frame.origin.y = offset.y - (frame.size.height);
        [_iconview setFrame:frame];
        [_contentView addSubview:_iconview];
        
        offset.x += frame.size.width + spacingx;
    }
    else
    {
        [_iconview removeFromSuperview];
    }
    
    if ( ![_messageview isHidden] )
    {
        NSRect frame = [_messageview frame];
        frame.origin.x = offset.x;
        frame.origin.y = offset.y - frame.size.height;
        [_messageview setFrame:frame];
        [_contentView addSubview:_messageview];

        offset.y -= frame.size.height + spacingy;
    }
    else
    {
        [_messageview removeFromSuperview];
    }
    
    if ( ![_informationview isHidden] )
    {
        NSRect frame = [_informationview frame];
        frame.origin.x = offset.x;
        frame.origin.y = offset.y - frame.size.height;
        [_informationview setFrame:frame];
        [_contentView addSubview:_informationview];
        
        offset.y -= frame.size.height + spacingy;
    }
    else
    {
        [_informationview removeFromSuperview];
    }
    
    if ( _accessoryView != nil )
    {
        NSRect frame = [_accessoryView frame];
        frame.origin.x = offset.x;
        frame.origin.y = offset.y - frame.size.height;
        [_accessoryView setFrame:frame];
        [_contentView addSubview:_accessoryView];
        
        offset.y -= frame.size.height + spacingy;
    }
}

- (void) sizeButtonsToFit
{
    float width = [self contentWidth];
    float buttonsWidth = -27.0f;
    for ( NSButton * button in _buttons )
    {
        buttonsWidth += [self sizeToFitButton:button];
    }
    
    if ( buttonsWidth > width )
    {
        float diff = buttonsWidth - width;
        NSRect frame = [_contentView frame];
        frame.size.width += diff;
        [_contentView setFrame:frame];
        
        frame = [self frame];
        frame.size.width += diff;
        [self setFrame:frame display:NO];
    }
}

- (void) layoutPanelButtons
{
    NSRect rect = [_contentView frame];

    CGPoint offset = CGPointMake(rect.size.width - edgeButtonsInsetRight, edgeButtonsInsetBottom);
    
    if ( [_buttons count] > 0 )
    {
        for ( NSButton * button in _buttons )
        {
            NSRect frame = [button frame];
            frame.origin.x = offset.x - frame.size.width;
            frame.origin.y = offset.y;
            [button setFrame:frame];
            [_contentView addSubview:button];
            
            offset.x = frame.origin.x;
        }
        
        if ( [_buttons count] == 3 )
        {
            NSButton * button = [_buttons objectAtIndex:2];
            NSRect frame = [button frame];
            frame.origin.x = edgeInsetRight - (edgeButtonsInsetRight / 2);
            if ( [_iconview image] )
            {
                frame.origin.x += [_iconview frame].size.width;
                frame.origin.x += spacingx;
            }
            [button setFrame:frame];
        }
    }
    else
    {
        NSRect frame = [_defaultButton frame];
        frame.origin.x = offset.x - frame.size.width;
        frame.origin.y = offset.y;
        [_defaultButton setFrame:frame];
        [_contentView addSubview:_defaultButton];
    }
}

- (float) contentWidth
{
    NSView * contentView = [self contentView];
    NSRect contentBounds = [contentView bounds];
    float width = contentBounds.size.width - ( edgeInsetLeft + edgeInsetRight );
    
    if ( [_iconview image] )
    {
        width -= [_iconview bounds].size.width + spacingx;
    }
    
    return width;
}

- (NSButton*) createButtonWithTitle:(NSString*)title isKeyButton:(BOOL)makeKey
{
    NSButton * button = [[NSButton alloc] init];
    [button setBezelStyle:NSRoundedBezelStyle];
    [button setButtonType:NSMomentaryPushInButton];
    [button setBordered:YES];
    [button setFrame:NSMakeRect(0, 0, 80, 30)];
    [button setState:0];
    [button setTarget:self];
    [button setAction:@selector(selectButton:)];
    [button setTitle:title];
    if (makeKey)
    {
        [button setKeyEquivalent:@"\r"];
    }
    return button;
}

- (float) sizeToFitButton:(NSButton*)button
{
    NSRect frame = [button frame];
    frame.size.width = [self widthForString:[button stringValue] font:[button font]] + 80.0f;
    [button setFrame:frame];
    return frame.size.width;
}

- (void) setTextContent:(NSTextView*)view WithHtml:(NSString*)text
{
    NSFont *font = [view font];
    NSString *html = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
    NSString *htmlWithFont = [NSString stringWithFormat:@"<span style=\"font-family:'%@'; font-size:%dpx;\">%@</span>", [font fontName], (int)[font pointSize], html];
    NSData *data = [htmlWithFont dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString * content = [[NSAttributedString alloc] initWithHTML:data documentAttributes:nil];
    [[view textStorage] setAttributedString:content];
}

- (float) widthForString:(NSString*)text font:(NSFont*)font
{
    NSMutableDictionary * attributes = [[NSMutableDictionary alloc] init];
    attributes[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attributes].width;
}

- (float) heightForString:(NSString*)text font:(NSFont*)font width:(float)width
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:text];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(width, FLT_MAX)];
    ;
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:font
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    NSRect container = [layoutManager
                        usedRectForTextContainer:textContainer];
    return container.size.height;
}

- (void) selectButton:(id)sender
{
    if ( [_buttons containsObject:sender] )
    {
        _code = NSAlertFirstButtonReturn + [_buttons indexOfObject:sender];
    }
    else
    {
        _code = 0;
    }
    
    [[NSApplication sharedApplication] stopModalWithCode:_code];
    [[NSApplication sharedApplication] endSheet:self
                                     returnCode:_code];
    [self orderOut: nil];
}

@end
