//
//  PlanetObservationModel.h
//  ios-xmppBase
//
//  Created by Rachel Harsley on 9/27/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanetObservationModel : NSObject
-(int)isInFrontOf:(NSString *)planet1:(NSString *)planet2;
-(void)identify:(NSString *)planetColor :(NSString *)planetName;

//XMPP
-(void)sendMessage:(NSString *)msg:(NSString *)to;
-(void)sendGroupMessage:(NSString *)msg;
-(int)inFrontGroupMessage:(NSString *)planet1:(NSString *)planet2;
-(int)orderReasonGroupMessage:(NSString *)reason;
-(int)theoryReasonGroupMessage:(NSString *)reason;

@end
