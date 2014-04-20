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
    NSArray *keysInOrder;
    
    NSMutableArray *views;
    
    int numViews;
    
    CGPoint focusCoord;
    CGRect newFrame;
    CGPoint newMousePoint;
}

@property (strong) NSRunningApplication *oldApp;
- (void)reloadGrid:(CGRect)rect;
- (id)initWithWindowNibName:(NSString *)windowNibName numViews:(int)widthCount keys:(NSArray *)keys;

@end
