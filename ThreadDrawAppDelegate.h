//
//  ThreadDrawAppDelegate.h
//  ThreadDraw
//
//  Created by Steve Baker on 4/20/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ThreadDrawAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
