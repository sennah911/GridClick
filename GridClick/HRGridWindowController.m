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

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.styleMask = NSBorderlessWindowMask;
    self.window.backgroundColor = [NSColor clearColor];
    self.window.opaque = NO;
    self.window.level = kCGMainMenuWindowLevel;
    self.window.ignoresMouseEvents = YES;
    
    
    NSScreen *screen = [NSScreen mainScreen];
    NSPoint mouseLoc = [NSEvent mouseLocation];
    [self.window setFrame:CGRectMake(0, 0, screen.frame.size.width, screen.frame.size.height) display:NO];
    
    
    [NSApp activateIgnoringOtherApps:YES];
    //[self.window makeKeyAndOrderFront:nil];
    [self.window makeFirstResponder:self];
    
    NSColor *white = [NSColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    NSColor *black = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    view1 = [[NSView alloc] initWithFrame:CGRectMake(0, 0, mouseLoc.x, mouseLoc.y)];
    [view1 setWantsLayer:YES];
    view1.layer.borderColor = [white CGColor];
    view1.layer.backgroundColor = [black CGColor];
    view1.layer.borderWidth = 2;
    [self.window.contentView addSubview:view1];
    
    
    view2 = [[NSView alloc] initWithFrame:CGRectMake(mouseLoc.x, 0, screen.frame.size.width - mouseLoc.x, mouseLoc.y)];
    [view2 setWantsLayer:YES];
    view2.layer.borderColor = [white CGColor];
    view2.layer.backgroundColor = [black CGColor];
    view2.layer.borderWidth = 2;
    [self.window.contentView addSubview:view2];
    
    
    view3 = [[NSView alloc] initWithFrame:CGRectMake(0, mouseLoc.y, mouseLoc.x, screen.frame.size.height - mouseLoc.y)];
    [view3 setWantsLayer:YES];
    view3.layer.borderColor = [white CGColor];
    view3.layer.backgroundColor = [black CGColor];
    view3.layer.borderWidth = 2;
    [self.window.contentView addSubview:view3];
    
    view4 = [[NSView alloc] initWithFrame:CGRectMake(mouseLoc.x, mouseLoc.y, screen.frame.size.width - mouseLoc.x, screen.frame.size.height - mouseLoc.y)];
    [view4 setWantsLayer:YES];
    view4.layer.borderColor = [white CGColor];
    view4.layer.backgroundColor = [black CGColor];
    view4.layer.borderWidth = 2;
    [self.window.contentView addSubview:view4];
}

- (void)reloadGrid {
    NSScreen *screen = [NSScreen mainScreen];
    NSPoint mouseLoc = [NSEvent mouseLocation];
    focusCoord = CGPointMake(1, 1);
    
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeFirstResponder:self];
    
    
    view1.frame = CGRectMake(0, 0, mouseLoc.x, mouseLoc.y);
    view2.frame = CGRectMake(mouseLoc.x, 0, screen.frame.size.width - mouseLoc.x, mouseLoc.y);
    view3.frame = CGRectMake(0, mouseLoc.y, mouseLoc.x, screen.frame.size.height - mouseLoc.y);
    view4.frame = CGRectMake(mouseLoc.x, mouseLoc.y, screen.frame.size.width - mouseLoc.x, screen.frame.size.height - mouseLoc.y);
    
}

void postMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point) {
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
    CGEventSetType(theEvent, type);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"%@", theEvent);
    NSScreen *screen = [NSScreen mainScreen];
    
    NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;

    if (flags == NSCommandKeyMask) {
        if ([theEvent keyCode] == 4) {
            NSLog(@"Cmd-H");
            if (focusCoord.x > 0) {
                focusCoord.x -= 1;
            }
        } else if ([theEvent keyCode] == 38) {
            NSLog(@"Cmd-J");
            if (focusCoord.y > 0) {
                focusCoord.y -= 1;
            }
        } else if ([theEvent keyCode] == 40) {
            NSLog(@"Cmd-K");
            if (focusCoord.y < 2) {
                focusCoord.y += 1;
            }
        } else if ([theEvent keyCode] == 37) {
            NSLog(@"Cmd-L");
            if (focusCoord.x < 2) {
                focusCoord.x += 1;
            }
        }
        
        focusCoord.x = (int)focusCoord.x % 3;
        focusCoord.y = (int)focusCoord.y % 3;
        NSLog(@"%f, %f", focusCoord.x, focusCoord.y);
        NSLog(@"%f, %f", newFrame.origin.x, newFrame.origin.y);
        
        //CGWarpMouseCursorPosition(CGPointMake(newFrame.origin.x + newFrame.size.width/2*focusCoord.x, screen.frame.size.height - (newFrame.origin.y + newFrame.size.height/2*focusCoord.y)));
        CGPoint newMousePoint;
        
        if (focusCoord.x == 0) {
            newMousePoint.x = view1.frame.origin.x;
        } else if (focusCoord.x == 1) {
            newMousePoint.x = view2.frame.origin.x;
        } else if (focusCoord.x == 2) {
            newMousePoint.x = view2.frame.origin.x + view2.frame.size.width;
        }
        
        
        if (focusCoord.y == 0) {
            newMousePoint.y = screen.frame.size.height - view1.frame.origin.y;
        } else if (focusCoord.y == 1) {
            newMousePoint.y = screen.frame.size.height - view3.frame.origin.y;
        } else if (focusCoord.y == 2) {
            newMousePoint.y = screen.frame.size.height - (view3.frame.origin.y + view3.frame.size.height);
        }
        
        CGWarpMouseCursorPosition(newMousePoint);
        
        
    } else {
    
        if ([theEvent keyCode] == 38) { //1
            NSLog(@"1 pressed");
            newFrame = view1.frame;
        } else if ([theEvent keyCode] == 40) {
            NSLog(@"2 pressed");
            newFrame = view2.frame;
        } else if ([theEvent keyCode] == 32) {
            NSLog(@"3 pressed");
            newFrame = view3.frame;
        } else if ([theEvent keyCode] == 34) {
            NSLog(@"4 pressed");
            newFrame = view4.frame;
        }
    
        if ([theEvent keyCode] == 38 || [theEvent keyCode] == 40 || [theEvent keyCode] == 32 || [theEvent keyCode] == 34) {
    
            view1.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y, newFrame.size.width/2, newFrame.size.height/2);
            view2.frame = CGRectMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y, newFrame.size.width/2, newFrame.size.height/2);
            view3.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y + newFrame.size.height/2, newFrame.size.width/2, newFrame.size.height/2);
            view4.frame = CGRectMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2, newFrame.size.width/2, newFrame.size.height/2);
        }
        
        CGPoint newMousePoint;
        
        if (focusCoord.x == 0) {
            newMousePoint.x = view1.frame.origin.x;
        } else if (focusCoord.x == 1) {
            newMousePoint.x = view2.frame.origin.x;
        } else if (focusCoord.x == 2) {
            newMousePoint.x = view2.frame.origin.x + view2.frame.size.width;
        }
        
        
        if (focusCoord.y == 0) {
            newMousePoint.y = screen.frame.size.height - view1.frame.origin.y;
        } else if (focusCoord.y == 1) {
            newMousePoint.y = screen.frame.size.height - view3.frame.origin.y;
        } else if (focusCoord.y == 2) {
            newMousePoint.y = screen.frame.size.height - (view3.frame.origin.y + view3.frame.size.height);
        }
        
        CGWarpMouseCursorPosition(newMousePoint);
        
        if ([theEvent keyCode] == 36) {
            NSLog(@"Enter");
            NSLog(@"MousePoint = %f, %f", newMousePoint.x, newMousePoint.y);
            
            [NSApp activateIgnoringOtherApps:NO];
            
            [self resignFirstResponder];
            [self close];
            
            [self clickMouse];
        }
    }
}


- (void)clickMouse {
    postMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, [NSEvent mouseLocation]);
    postMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, [NSEvent mouseLocation]);
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
