//
//  PlanetButton.h
//  ios-xmppBase
//
//  Created by admin on 10/6/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUIControlStateCustomState (1 << 3)

@interface PlanetButton : UIButton{
   // UIControlState customState;
}

- (void) test;
- (IBAction)planetTouchExit:(UIButton *)sender forEvent:(UIEvent *)event;
- (void)setCustomState;
- (void)unsetCustomState;
- (UIControlState)state;
- (void)setSelected:(BOOL)newSelected;
- (void)setHighlighted:(BOOL)newHighlighted;
- (void)setEnabled:(BOOL)newEnabled;

@end
