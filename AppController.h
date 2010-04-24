//
//  AppController.h
//  ThreadDraw
//
//  Created by Steve Baker on 4/20/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//  Ref Dalrymple Advanced Mac OS X Programming Ch 22
//  Ref UW Q3HW4 Chris Parrish solution

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
#pragma mark instance variables

    NSView* drawView_;
    BOOL shouldDrawColor1;
    BOOL shouldDrawColor2;
    BOOL shouldDrawColor3;
    
    NSColor *color1_;
    NSColor *color2_;
    NSColor *color3_;
}

#pragma mark properties
// use atomic properties for thread safety
@property(retain)IBOutlet NSView* drawView;

@property(assign) BOOL shouldDrawColor1;
@property(assign) BOOL shouldDrawColor2;
@property(assign) BOOL shouldDrawColor3;

@property(retain)NSColor *color1;
@property(retain)NSColor *color2;
@property(retain)NSColor *color3;

- (BOOL)shouldDrawColor:(NSColor*)color;

- (void)threadDrawForColor:(NSColor *)color;

- (IBAction)drawColor1Checked:(id)sender;

- (IBAction)drawColor2Checked:(id)sender;

- (IBAction)drawColor3Checked:(id)sender;

- (IBAction)handleClearDrawingButton:(id)sender;

@end
