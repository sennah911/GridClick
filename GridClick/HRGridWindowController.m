//
//  HRGridWindowController.m
//  GridClick
//
//  Created by Hannes Remahl on 16/04/14.
//  Copyright (c) 2014 Hannes Remahl. All rights reserved.
//

#import "HRGridWindowController.h"

@interface HRGridWindowController ()

@end

@implementation HRGridWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithWindowNibName:(NSString *)windowNibName numViews:(int)widthCount keys:(NSArray *)keys
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        // Initialization code here.
        numViews = widthCount * widthCount;
        keysInOrder = keys;
    }
    return self;
}

- (void)windowDidLoad
{
    numViews = 9;
    views = [[NSMutableArray alloc] init];
    [super windowDidLoad];
    
    [self.window setStyleMask:[self.window styleMask] | NSNonactivatingPanelMask];
    self.window.backgroundColor = [NSColor clearColor];
    self.window.opaque = NO;
    self.window.level = kCGMainMenuWindowLevel;
    self.window.ignoresMouseEvents = YES;
    
    
    NSScreen *screen = [NSScreen mainScreen];
    [self.window setFrame:CGRectMake(0, 0, screen.frame.size.width, screen.frame.size.height) display:NO];
    
    [self setupViews];
}

- (void)setupViews {
    int width = (int)sqrt(numViews);
    NSScreen *screen = [NSScreen mainScreen];
    NSColor *white = [NSColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    NSColor *black = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
            NSView *view = [[NSView alloc] initWithFrame:CGRectMake(i*screen.frame.size.width/width, j*screen.frame.size.height/width, screen.frame.size.width/width, screen.frame.size.height/width)];
            [view setWantsLayer:YES];
            view.layer.borderColor = [white CGColor];
            view.layer.backgroundColor = [black CGColor];
            view.layer.borderWidth = 2;
            [self.window.contentView addSubview:view];
            
            [views addObject:view];
        }
    }
}

- (void)reloadGrid:(CGRect)rect {
    focusCoord = CGPointMake(1, 1);
    
    int counter = 0;
    int width = (int)sqrt(numViews);
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
            NSView *view = [views objectAtIndex:counter];
            view.frame = CGRectMake(rect.origin.x + (j*rect.size.width/width), rect.origin.y + (i*rect.size.height/width), rect.size.width/width, rect.size.height/width);
            counter++;
        }
    }
    
    newFrame = rect;
    
    NSScreen *screen = [NSScreen mainScreen];
    newMousePoint = CGPointMake(rect.origin.x+rect.size.width/2, screen.frame.size.height - (rect.origin.y+rect.size.height/2));
    CGWarpMouseCursorPosition(newMousePoint);
}

void postMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point) {
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
    CGEventSetType(theEvent, type);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
}


- (void)keyDown:(NSEvent *)theEvent
{
    NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;

    if (flags == NSCommandKeyMask) {
        if ([theEvent keyCode] == 36) {
            [self rightClickMouse];
            [self close];
        }
        
        
    } else {
    
        for (NSNumber *key in keysInOrder) {
            if ([key intValue] == [theEvent keyCode]) {
                NSView *view = [views objectAtIndex:[keysInOrder indexOfObject:key]];
                newFrame = view.frame;
                [self reloadGrid:newFrame];
            }
        }
        
        if ([theEvent keyCode] == 36) {
            [self clickMouse];
            [self close];
        }
        
        if ([theEvent keyCode] == 17) {
            NSLog(@"tab pressed");
            [self toggleGridSize];
        }
 
    }
}

- (void)toggleGridSize {
    for (NSView *view in views) {
        [view removeFromSuperview];
    }
    //[views removeAllObjects];
    
    if (numViews == 9) {
        numViews = 4;
        for (int i = 0; i < numViews; i++) {
            [self.window.contentView addSubview:[views objectAtIndex:i]];
        }
        
        keysInOrder = @[@38, @40, @32, @34];
    } else {
        numViews = 9;
        for (int i = 0; i < numViews; i++) {
            [self.window.contentView addSubview:[views objectAtIndex:i]];
        }
        keysInOrder = @[@46, @43, @47, @38, @40, @37, @32, @34, @31];
    }
    [self reloadGrid:newFrame];
}


- (void)clickMouse {
    postMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, newMousePoint);
    postMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, newMousePoint);
}

- (void)rightClickMouse {
    postMouseEvent(kCGMouseButtonRight, kCGEventRightMouseDown, newMousePoint);
    postMouseEvent(kCGMouseButtonRight, kCGEventRightMouseUp, newMousePoint);
}

@end


@interface HRGridWindow : NSPanel

@end

@implementation HRGridWindow

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}

@end
