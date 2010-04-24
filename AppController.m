//
//  AppController.m
//  ThreadDraw
//
//  Created by Steve Baker on 4/20/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "AppController.h"

@implementation AppController

#pragma mark properties
@synthesize drawView = drawView_;

@synthesize shouldDrawColor1;
@synthesize shouldDrawColor2;
@synthesize shouldDrawColor3;

@synthesize color1 = color1_;
@synthesize color2 = color2_;
@synthesize color3 = color3_;


- (id)init
{
    self = [super init];
    if (nil != self) {
        // set up the colors we want to draw with
        self.color1 = [NSColor redColor];
        self.color2 = [NSColor greenColor];
        self.color3 = [NSColor blueColor];
        
        self.shouldDrawColor1 = YES;
        self.shouldDrawColor2 = YES;
        self.shouldDrawColor3 = YES;
    }
    return self;
}


-(void)awakeFromNib
{
    [[self drawView] setNeedsDisplay:YES];
    
    // start 3 drawing threads
    [NSThread detachNewThreadSelector:@selector(threadDrawForColor:) 
                             toTarget:self
                           withObject:[self color1]];
    
    [NSThread detachNewThreadSelector:@selector(threadDrawForColor:) 
                             toTarget:self
                           withObject:[self color2]];    
    
    [NSThread detachNewThreadSelector:@selector(threadDrawForColor:) 
                             toTarget:self
                           withObject:[self color3]];    
}


- (void)dealloc
{
    [color1_ release], color1_ = nil;
    [color2_ release], color2_ = nil;
    [color3_ release], color3_ = nil;
    [super dealloc];
}


#pragma mark drawing

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

- (BOOL)shouldDrawColor:(NSColor*)color
{
    // use atomic properties for thread safety
    if ((color == self.color1 && self.shouldDrawColor1) ||
        (color == self.color2 && self.shouldDrawColor2) ||
        (color == self.color3 && self.shouldDrawColor3))
    {
        return YES;
    }
    return NO;
}


- (void)threadDrawForColor:(NSColor *)color
{
    NSAutoreleasePool *poolOne = [[NSAutoreleasePool alloc] init];
    NSLog(@"Started threadForColor: %@", [color description]);
    
    NSPoint lastPoint = [[self drawView] bounds].origin;
    
    // this thread runs indefinitely
    while (true)
    {        
        if ([[self drawView] lockFocusIfCanDraw])
        {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            if ([self shouldDrawColor:color])
            {
                NSPoint point;
                point = [self randomPointInBounds:[[self drawView] bounds]];
                [color set];
                [NSBezierPath strokeLineFromPoint:lastPoint 
                                          toPoint:point];
                [[[self drawView] window] flushWindow];
                lastPoint = point;
            }
            [[self drawView] unlockFocus];
            [pool release];
        }
    }
    NSLog(@"Exited threadForColor: %@", [color description]);
    [poolOne release];
}


#pragma mark -
#pragma mark IBAction

// Use checkboxes in view to set applicationController's properties.
// This is better MVC design than inspecting view checkbox properties in the controller.
- (IBAction)drawColor1Checked:(id)sender{
    self.shouldDrawColor1 = (NSOnState == [sender state]);
}


- (IBAction)drawColor2Checked:(id)sender{
    self.shouldDrawColor2 = (NSOnState == [sender state]);
}


- (IBAction)drawColor3Checked:(id)sender{
    self.shouldDrawColor3 = (NSOnState == [sender state]);
}


- (IBAction)handleClearDrawingButton:(id)sender{
    [[self drawView] setNeedsDisplay:YES];
}

@end


