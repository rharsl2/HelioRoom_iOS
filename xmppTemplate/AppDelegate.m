//
//  AppDelegate.m
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Modified by Rachel Harsley 9/2012
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//old bundle id: ltg.${PRODUCT_NAME:rfc1034identifier}.helioRoom.*

#import "AppDelegate.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "LoginViewController.h"
#import "ChooseInFrontViewController.h"

#import <CFNetwork/CFNetwork.h>

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface AppDelegate()
@property (strong, nonatomic) LoginViewController *loginController;
@property (strong, nonatomic) ChooseInFrontViewController *chooseFirstController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize window;

//RACHEL MODIFIED
@synthesize xmppRoomRosterStorage;
@synthesize xmppRoom;
@synthesize loginController =_loginController;
@synthesize chooseFirstController = _chooseFirstController;
@synthesize tabBarController = _tabBarController;
@synthesize successfullLogin;

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
//NSString *const xmppServer = @"rharsley-laptop.local"; //set to name address of your xmppServer OR use below
NSString *const xmppServer = @"169.254.225.196";  //set to ip address of your xmppServer
NSString *const chatLocation = @"helioRoom@conference.rharsley"; //set to location of chat room



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[[NSUserDefaults standardUserDefaults] setObject:@"@phenomena.evl.uic.edu" forKey:kXMPPmyJID];
    //[[NSUserDefaults standardUserDefaults] setObject:@"password" forKey:kXMPPmyPassword];
    // Configure logging framework
	
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //RACHEL MODIFIED
    successfullLogin = NO;
    
    // Setup the XMPP stream
    
	[self setupStream];
    
	if (![self connect]) //TODO join chat
	{
        DDLogVerbose(@"Unable to connect. Need to login.");
		[self showLoginView:self.window.rootViewController];
	}
    else{       
        //already connected. Display the chooseFront UI
        successfullLogin = YES;
        DDLogVerbose(@"Already connected. Proceeding to main app");
        //[self showChooseFirstView:self.window.rootViewController];
        [self showTabBarView:self.window.rootViewController];
    }
    
    [self tabBarController].delegate = self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	//xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	//xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	//xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	//xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    //xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    //xmppCapabilities.autoFetchHashedCapabilities = YES;
    //xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    //	[xmppvCardTempModule   activate:xmppStream];
    //	[xmppvCardAvatarModule activate:xmppStream];
    //	[xmppCapabilities      activate:xmppStream];
    //
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
    //RACHEL MODIFIED
    [xmppStream setHostName:xmppServer];
    [xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = YES;
	allowSSLHostNameMismatch = YES;
}


- (void)teardownStream
{
	[xmppStream removeDelegate:self];
    
	
	[xmppReconnect         deactivate];
    [xmppRoster            deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
    
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
    NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
    DDLogVerbose(@"Attempting to connect to to XMPP Stream Server %@ with JID: %@ and pass: %@", xmppServer,myJID, myPassword);
	if (![xmppStream isDisconnected] && successfullLogin) {
		return YES;
	}
    

	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
    DDLogVerbose(@"No Error Connecting to XMPP Stream Server %@. But authentication may fail later.", xmppServer);
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    // DDLogVerbose(@"RACHEL hostname: %@:", [xmppStream hostName]);
    
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
    if(successfullLogin != YES){
        successfullLogin = YES;
        //[self showChooseFirstView:self.window.rootViewController];
        [self showTabBarView:self.window.rootViewController];
    }
    
    [self joinChat];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString * displayName = @"Error";
    NSString * body = @"Unable to login with given username and password. Please try again.";
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Ok";
        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }

}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
//		
//		NSString *body = [[message elementForName:@"body"] stringValue];
//		NSString *displayName = [message fromStr];
        
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                                message:body
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
			[alertView show];
		}
		else
		{
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}



- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
        DDLogError(@"The RACHEL error: %@", [error description] );
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Rachel Functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)getLoggedInUser{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
}
-(void)joinChat{
    DDLogError(@"Attempting to join chatroom.");
    if(xmppRoomRosterStorage==nil){
        xmppRoomRosterStorage = [[XMPPRoomCoreDataStorage alloc] init];
        DDLogError(@"Initializing roomRosterStorage");
    }
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomRosterStorage jid:[XMPPJID jidWithString:chatLocation] dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];

    [xmppRoom joinRoomUsingNickname:[self getLoggedInUser] history:nil];    
}
- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    DDLogError(@"Joined chatroom.");
}
-(void)showLoginView:(UIViewController *)activeViewController{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [activeViewController presentViewController:self.loginController animated:YES completion:nil];
    });
}
-(void)showChooseFirstView:(UIViewController *)activeViewController{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [activeViewController presentViewController:self.chooseFirstController animated:NO completion:nil];
    });
    
}
-(void)showTabBarView:(UIViewController *)activeViewController{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [activeViewController presentViewController:self.tabBarController animated:NO completion:nil];
    });
    
}
-(LoginViewController *)loginController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                             bundle: nil];
    
    if(!_loginController) _loginController = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginController"];
    return _loginController;
}
-(ChooseInFrontViewController *)chooseFirstController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                             bundle: nil];
    if(!_chooseFirstController) _chooseFirstController = (ChooseInFrontViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"chooseFrontController"];
    return _chooseFirstController;
}
-(UITabBarController *)tabBarController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                             bundle: nil];
    if(!_tabBarController) _tabBarController = (UITabBarController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"tabBarController"];
    return _tabBarController;
    
}
-(UIViewController *)getRootViewController{
    return self.window.rootViewController;
}

- (void)sendMessage:(NSString *)msg:(NSString *)to{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:msg];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    
    [[self xmppStream] sendElement:message];
}
- (void)sendGroupMessage:(NSString *)msg{
    [xmppRoom sendMessage:msg];
}
- (int)inFrontGroupMessage:(NSString *)planet1:(NSString *)planet2{
    [self goOnline];
    DDLogError(@"Sending the isInFrontOf group message. Planet1: %@ and Planet2: %@", planet1,planet2);
    NSXMLElement *message = [NSXMLElement elementWithName:@"inFrontOf"];
    [message addAttributeWithName:@"front" stringValue:planet1];
    [message addAttributeWithName:@"back" stringValue:planet2];
    [message addAttributeWithName:@"user" stringValue:[self getLoggedInUser]];
    

    [xmppRoom sendMessage:[message XMLString]];
    
    //TODO introduce some delay/animated gif??
    //TODO check whether sent?
    return 1;
 
}
- (int)identifyGroupMessage:(NSString *)planetColor:(NSString *)planetName{
    [self goOnline];
    DDLogError(@"Sending the identify group message. PlanetColor: %@ and PlanetName: %@", planetColor,planetName);
    NSXMLElement *message = [NSXMLElement elementWithName:@"identify"];
    [message addAttributeWithName:@"color" stringValue:planetColor];
    [message addAttributeWithName:@"name" stringValue:planetName];
    [message addAttributeWithName:@"user" stringValue:[self getLoggedInUser]];
    
    
    [xmppRoom sendMessage:[message XMLString]];
    
    //TODO introduce some delay/animated gif??
    //TODO check whether sent?
    return 1;
    
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger i, tag;
    tag= [[viewController view] tag];
    
    //Reset Choose In Front View Controller //TODO : change loop <30
    if(tag==1){
        ChooseInFrontViewController * choose =viewController;
//        for (i=21; i<24; i++){
//            NSString *planetName = [[self chooseFirstController] tagToPlanet:i];
//            DDLogVerbose(@"setting large planet %@ to zero.", planetName);
//
//            [[choose getLargePlanetButton:planetName] setAlpha:0];
//        }
        //[choose clearDropAreas];
       // [choose updateSubmitButton];
   }
}
-(void)writeDebugMessage:(NSString *)msg{
    DDLogError(@"%@", msg);
}

@end
