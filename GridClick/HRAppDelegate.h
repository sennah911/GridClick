//
//  HRAppDelegate.h
//  GridClick
//
//  Created by Hannes Remahl on 15/04/14.
//  Copyright (c) 2014 Hannes Remahl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "HRGridWindowController.h"

@interface HRAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property HRGridWindowController* gridWindowController;


@end
