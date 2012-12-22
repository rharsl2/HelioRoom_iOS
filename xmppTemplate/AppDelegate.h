//
//  AppDelegate.h
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Modified by Rachel Harsley 9/2012
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"


@interface AppDelegate : NSObject <UIApplicationDelegate, XMPPRosterDelegate, UITabBarControllerDelegate> {//TODO was UIResponder
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;

    
    NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    UIWindow *window;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

//RACHEL MODIFIED
@property (nonatomic, strong, readonly) XMPPRoomCoreDataStorage *xmppRoomRosterStorage;
@property (nonatomic, strong, readonly) XMPPRoom *xmppRoom;
@property (nonatomic, assign) BOOL successfullLogin;;


- (NSManagedObjectContext *)managedObjectContext_roster;
- (BOOL)connect;
- (void)disconnect;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

//RACHEL METHODS
- (NSString *)getLoggedInUser;
- (void)sendMessage:(NSString *)msg:(NSString *)to;
- (void)sendGroupMessage:(NSString *)msg;
- (int)inFrontGroupMessage:(NSString *)planet1:(NSString *)planet2;
- (int)identifyGroupMessage:(NSString *)planetColor:(NSString *)planetName;
- (void)joinChat;
- (void)showLoginView:(UIViewController *)activeViewController;
- (void)showChooseFirstView:(UIViewController *)activeViewController;
- (void)showTabBarView:(UIViewController *)activeViewController;
- (UIViewController *)getRootViewController;

//FOR DEBUG
- (void)writeDebugMessage:(NSString *)msg;
@end
