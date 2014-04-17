//
//  HRGridWindowController.h
//  GridClick
//
//  Created by Hannes Remahl on 16/04/14.
//  Copyright (c) 2014 Hannes Remahl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface HRGridWindowController : NSWindowController {
    NSView *view1;
    NSView *view2;
    NSView *view3;
    NSView *view4;
    
    CGPoint focusCoord;
    CGRect newFrame;
}

- (void)reloadGrid;

@end
