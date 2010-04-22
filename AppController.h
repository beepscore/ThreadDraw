//
//  AppController.h
//  ThreadDraw
//
//  Created by Steve Baker on 4/20/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {

    NSView* drawView;
    NSButton* redCheckbox;
    NSButton* greenCheckbox;
    NSButton* blueCheckbox;
}

#pragma mark properties
// use atomic properties for thread safety
@property(retain)IBOutlet NSView* drawView;

@property(retain)IBOutlet NSButton *redCheckbox;
@property(retain)IBOutlet NSButton *greenCheckbox;
@property(retain)IBOutlet NSButton *blueCheckbox;

@end
