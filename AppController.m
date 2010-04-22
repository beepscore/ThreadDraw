//
//  AppController.m
//  ThreadDraw
//
//  Created by Steve Baker on 4/20/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "AppController.h"
#import <unistd.h> // for sleep

#define SLEEP_TIME_MICROSECONDS 500000

@implementation AppController

#pragma mark properties
@synthesize drawView;
@synthesize redCheckbox;
@synthesize greenCheckbox;
@synthesize blueCheckbox;


- (NSPoint) randomPointInBounds: (NSRect) bounds
{
    NSPoint result;
    int width, height;
    width = round (bounds.size.width);
    height = round (bounds.size.height);
    result.x = (random() % width) + bounds.origin.x;
    result.y = (random() % height) + bounds.origin.y;
    return (result);
}


- (void)threadDraw:(NSColor *)color
{
    NSAutoreleasePool *poolOne = [[NSAutoreleasePool alloc] init];
    
    BOOL okToDraw = NO;
    NSPoint lastPoint = [drawView bounds].origin;
    
    while (true) {
        
        // sb added
        NSAutoreleasePool *poolTwo = [[NSAutoreleasePool alloc] init];
        
        // for each color, get state of its checkbox - probably can do this more elegantly
        if ((([NSColor redColor] == color) && (NSOnState == [[self redCheckbox] state])) ||
            (([NSColor greenColor] == color) && (NSOnState == [[self greenCheckbox] state])) ||
            (([NSColor blueColor] == color) && (NSOnState == [[self blueCheckbox] state])) ) {
            okToDraw = YES;
        } else {
            okToDraw = NO;
        }        
        NSLog(@"okToDraw = %d", okToDraw);
        
        // ????: this stops drawing but won't restart it.  Why?
        // Evaluating lockFocusIfCanDraw locks focus even if okToDraw is false, then we don't unlock?
        // if ([[self drawView] lockFocusIfCanDraw] && okToDraw) {
        
        if (okToDraw) {
            
            if ([[self drawView] lockFocusIfCanDraw]) {
                NSPoint point;
                point = [self randomPointInBounds:[drawView bounds]];
                [color set];
                [NSBezierPath strokeLineFromPoint:lastPoint 
                                          toPoint:point];
                [[[self drawView] window] flushWindow];
                [[self drawView] unlockFocus];
                usleep (random() % SLEEP_TIME_MICROSECONDS); // up to 1/2 second 
                lastPoint = point;
            }
        }
        // sb added
        [poolTwo release];
    }
    [poolOne release];
}


- (void)awakeFromNib
{
    [[self drawView] setNeedsDisplay:YES];
    
    [NSThread detachNewThreadSelector:@selector(threadDraw:) 
                             toTarget:self
                           withObject:[NSColor redColor]];
    
    [NSThread detachNewThreadSelector:@selector(threadDraw:) 
                             toTarget:self
                           withObject:[NSColor greenColor]];    
    
    [NSThread detachNewThreadSelector:@selector(threadDraw:) 
                             toTarget:self
                           withObject:[NSColor blueColor]];
}


// ????: don't dealloc properties used by threads?


- (IBAction)handleClearDrawingButton:(id)sender{
    [[self drawView] setNeedsDisplay:YES];
}

@end


