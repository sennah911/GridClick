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
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID gMyHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    
    InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,NULL,NULL);
    
    gMyHotKeyID.signature='htk1';
    gMyHotKeyID.id=1;
    
    RegisterEventHotKey(49, cmdKey+optionKey, gMyHotKeyID,
    GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    
    globalSelf = self;
}

- (void)showGrid {
    self.gridWindowController = [[HRGridWindowController alloc] initWithWindowNibName:@"HRGridWindowController"];
    [self.gridWindowController showWindow:self.gridWindowController];
}


static HRAppDelegate *globalSelf;
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,
                         void *userData)
{
    if (!globalSelf.gridWindowController) {
        globalSelf.gridWindowController = [[HRGridWindowController alloc] initWithWindowNibName:@"HRGridWindowController"];
    }
    if (globalSelf.gridWindowController.window.isVisible) {
        [globalSelf.gridWindowController.window close];
    } else {
        [globalSelf.gridWindowController showWindow:globalSelf.gridWindowController];
        [globalSelf.gridWindowController reloadGrid];
    }
    
    return noErr;
}

@end
