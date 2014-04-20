//
//  HRAppDelegate.m
//  GridClick
//
//  Created by Hannes Remahl on 15/04/14.
//  Copyright (c) 2014 Hannes Remahl. All rights reserved.
//

#import "HRAppDelegate.h"

@implementation HRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    modKeyValues =  [[NSMutableArray alloc] init];
    
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID gMyHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    
    InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,NULL,NULL);
    
    gMyHotKeyID.id=1;
    
    RegisterEventHotKey(49, cmdKey+optionKey, gMyHotKeyID,
    GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    
    globalSelf = self;
    
    [self createMenu];
}

- (NSValue *)assignHotKey:(UInt32)key modifiers:(UInt32)mods {
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID gMyHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    gMyHotKeyID.id=key;
    
    RegisterEventHotKey(key, 0, gMyHotKeyID,
                        GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    
    NSValue *refValue = [NSValue valueWithPointer:(EventHotKeyRef)gMyHotKeyRef];
    
    return refValue;
}


- (void)createMenu {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setTitle:@"🐭"];
    
    menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"About GridClick" action:@selector(showAboutWindow) keyEquivalent:@""];
    
    [statusItem setMenu:menu];
}

- (void)showAboutWindow {
    //if (!self.aboutWindowController) {
    //    self.aboutWindowController = [[HRAboutWindowController alloc] initWithWindowNibName:@"HRAboutWindowController"];
    //}
    //[self.aboutWindowController loadWindow];
    //[self.aboutWindowController showWindow:self.aboutWindowController.window];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:nil];
}

- (void)showGrid {
    //self.gridWindowController = [[HRGridWindowController alloc] initWithWindowNibName:@"HRGridWindowController"];
    //
    [self.gridWindowController showWindow:self.gridWindowController];
}

static HRAppDelegate *globalSelf;
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,
                         void *userData)
{
    
    NSRunningApplication *oldApp = [[NSWorkspace sharedWorkspace] frontmostApplication];
    
    if (!globalSelf.gridWindowController) {
        globalSelf.gridWindowController = [[HRGridWindowController alloc] initWithWindowNibName:@"HRGridWindowController" numViews:9 keys: @[@46, @43, @47, @38, @40, @37, @32, @34, @31]];
    }
    if (globalSelf.gridWindowController.window.isVisible) {
        [globalSelf.gridWindowController.window close];
        //[globalSelf.gridWindowController.oldApp activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    } else {
        globalSelf.gridWindowController.oldApp = oldApp;
        
        [globalSelf.gridWindowController showWindow:globalSelf.gridWindowController];
        [globalSelf.gridWindowController reloadGrid:[NSScreen mainScreen].frame];
    }
    
    return noErr;
}

@end
