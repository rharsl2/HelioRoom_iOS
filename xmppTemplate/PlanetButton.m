//
//  PlanetButton.m
//  ios-xmppBase
//
//  Created by admin on 10/6/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "PlanetButton.h"

@implementation PlanetButton
-(id)initWithFrame:(CGRect)frame{
    NSLog(@"HI RACHEL 1");
    self = [super initWithFrame:frame];
        //[UIButton buttonWithType:UIButtonTypeCustom];
    [self addTarget:self action:@selector(planetTouchExit) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(planetTouchExit) forControlEvents:UIControlEventTouchDragOutside];
    [self setFrame:frame];
    return self;
}
-(id)init{
    NSLog(@"HI RACHEL 1_1");
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addTarget:self action:@selector(planetTouchExit) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(planetTouchExit) forControlEvents:UIControlEventTouchDragOutside];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSLog(@"HI RACHEL 1_2");
    self=[super initWithCoder:aDecoder];
    [self addTarget:self action:@selector(planetTouchExit) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(planetTouchExit) forControlEvents:UIControlEventTouchDragOutside];
    return self;
}

-(void) test{
    NSLog(@"HI RACHEL 2");
    [self addTarget:self action:@selector(planetTouchExit) forControlEvents:UIControlEventTouchDragExit];

    for (NSString *s in [self actionsForTarget:self forControlEvent:UIControlEventTouchDragExit]) {
        NSLog(@"action for PlanetButton:%@",s);
    }
}
- (IBAction)planetTouchExit:(UIButton *)sender forEvent:(UIEvent *)event {
    NSLog(@"Touch Exit Event Called");
}
-(void)setCustomState {
   // customState |= kUIControlStateCustomState;
}

-(void)unsetCustomState {
   // customState &= ~kUIControlStateCustomState;
}

- (UIControlState)state {
  //  return [super state] | customState;
}
- (void)setSelected:(BOOL)newSelected {
    [super setSelected:newSelected];
}

- (void)setHighlighted:(BOOL)newHighlighted {
    [super setHighlighted:newHighlighted];
}

- (void)setEnabled:(BOOL)newEnabled {
    [super setEnabled:newEnabled];
}

@end
