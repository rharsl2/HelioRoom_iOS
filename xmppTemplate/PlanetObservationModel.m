//
//  PlanetObservationModel.m
//  ios-xmppBase
//
//  Created by Rachel Harsley on 9/27/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

 //TODO check for conflicting results?

#import "PlanetObservationModel.h"
#import "AppDelegate.h"
#include "mongo.h"

@implementation PlanetObservationModel

const char * mogodbServer = "169.254.225.196"; //set to ip of your mongodbServer
//const char * mogodbServer = "131.193.79.212"; //set to ip of your mongodbServer

-(int)isInFrontOf:(NSString *)planet1:(NSString *)planet2{
     
    int inDB = [self checkMongoPlanetOrder:planet1 :planet2];
    if(inDB == -1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error checking database."
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return -1;
    }else if(inDB == 1){
        //print message already submitted this
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You have already submitted this observation!"
                                                            message:@"Submit a new observation."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return -1;
    }else{
        //Save in Database 
        //Send group message
        
        int result =[self updateMongoPlanetOrder:planet1 :planet2];
        if(result == -1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error updating database."
                                                                message:@"See console for error details."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            return -1;
        }
        [self inFrontGroupMessage:planet1 :planet2];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Submit Successful"
                                                            message:@"Your observation was submitted."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return 1;
    }
    
    //TODO check for conflicting results?
    
}
-(void)identify:(NSString *)planetColor :(NSString *)planetName{
    
    int inDB = [self checkMongoPlanetIdentify:planetColor :planetName];
    if(inDB == -1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error checking database."
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(inDB == 1){
        [[self appDelegate] writeDebugMessage:@"Duplicate submission. Will skip."];
        return;
    }else{
        //Save in Database
        //Send group message
        
        int result =[self updateMongoPlanetIdentify:planetColor :planetName];
        if(result == -1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error updating database."
                                                                message:@"See console for error details."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [self identityGroupMessage:planetColor :planetName];
        return;
    }
    
    //TODO check for conflicting results?
}
- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)sendMessage:(NSString *)msg:(NSString *)to{
    [[self appDelegate] sendMessage:msg :to];
}
-(void)sendGroupMessage:(NSString *)msg{
    [[self appDelegate] sendGroupMessage:msg];
}
-(int)inFrontGroupMessage:(NSString *)planet1:(NSString *)planet2{
    return [[self appDelegate] inFrontGroupMessage:planet1:planet2];
}
-(int)identityGroupMessage:(NSString *)planetColor:(NSString *)planetName{
    return [[self appDelegate] identifyGroupMessage:planetColor:planetName];
}
-(int)updateMongoPlanetOrder:(NSString *)planet1:(NSString *)planet2{
    bson b, empty;
    mongo conn;
    mongo_cursor cursor;
    

    const char * p1 = [planet1 UTF8String];
    const char * p2 =[planet2 UTF8String];
    const char * user = [[[self appDelegate] getLoggedInUser] UTF8String];
    
    /* Create a rich document like this one:
     *
     *{ "_id" : { "$oid" : "50972af20401767400000001" }, 
     *   "fake@rharsley" : [ 
     *   { "front" : "blue", "back" : "yellow" }
     *   ]
     *}
     */
    bson_init( &b );
    bson_append_new_oid( &b, "_id" );// needed?
    
    bson_append_start_array( &b, user);
    bson_append_start_object( &b, "0" );
    bson_append_string( &b, "front", p1);
    bson_append_string( &b, "back", p2 );
    bson_append_finish_object( &b );
    bson_append_finish_object( &b );

    
    /* Finish the BSON obj. */
    bson_finish( &b );
    printf("Here's the whole BSON object:\n");
    bson_print( &b );
    

    
    /* Now make a connection to MongoDB. */
    if( mongo_connect( &conn, mogodbServer, 27017 ) != MONGO_OK ) {
        switch( conn.err ) {
            case MONGO_CONN_NO_SOCKET:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not create a socket!\n" ];
                break;
            case MONGO_CONN_FAIL:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not connect to mongod. Make sure it's listening at the given server on port 27017.\n"];
                break;
        }
        
        return -1;
    }
    
    /* Insert the sample BSON document. */
    if( mongo_insert( &conn, "helio.inFrontOf", &b, NULL ) != MONGO_OK ) {
        [[self appDelegate] writeDebugMessage: [ NSString stringWithFormat:@"FAIL: Failed to insert document with error %d\n", conn.err ]];
        return -1;
    }
    
    /* Query for the inserted document. */
    mongo_cursor_init( &cursor, &conn, "helio.inFrontOf" );
    mongo_cursor_set_query( &cursor, bson_empty( &empty ) );
    if( mongo_cursor_next( &cursor ) != MONGO_OK ) {
        [[self appDelegate] writeDebugMessage:@"FAIL: Failed to find inserted document." ];
        return -1;
    }
    
    
    printf( "Found saved BSON object:\n" );
    bson_print( (bson *)mongo_cursor_bson( &cursor ) );
    
    //mongo_cmd_drop_collection( &conn, "helio", "inFrontOf", NULL );
    mongo_cursor_destroy( &cursor );
    bson_destroy( &b );
    mongo_destroy( &conn );
    
    return 0;
}
-(int)checkMongoPlanetOrder:(NSString *)planet1:(NSString *)planet2{
    
    bson b;
    bson_iterator it;
    mongo conn;
    mongo_cursor cursor;
    bool found =NO;
    
    const char * p1 = [planet1 UTF8String];
    const char * p2 =[planet2 UTF8String];
    const char * user = [[[self appDelegate] getLoggedInUser] UTF8String];

    bson_init( &b );
    bson_append_start_array( &b, user);
    bson_append_start_object( &b, "0" );
    bson_append_string( &b, "front", p1);
    bson_append_string( &b, "back", p2 );
    bson_append_finish_object( &b );
    bson_append_finish_object( &b );
    
    /* Finish the BSON obj. */
    bson_finish( &b );
    printf("Here's the whole BSON object:\n");
    bson_print( &b );
    
    /* Now make a connection to MongoDB. */
    if( mongo_connect( &conn, mogodbServer, 27017 ) != MONGO_OK ) {
        switch( conn.err ) {
            case MONGO_CONN_NO_SOCKET:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not create a socket!\n" ];
                break;
            case MONGO_CONN_FAIL:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not connect to mongodbs. Make sure it's listening at the given server on port 27017.\n" ];
                break;
        }
        
        return -1;
    }
    
    /* Query for the observation. */
    mongo_cursor_init( &cursor, &conn, "helio.inFrontOf" );
    mongo_cursor_set_query( &cursor, &b);
    while(mongo_cursor_next( &cursor ) == MONGO_OK ) {
        bson_iterator iterator[1];
        [[self appDelegate] writeDebugMessage:@"checkMongo: FOUND the query." ];
        found =YES;
    }
    mongo_cursor_destroy( &cursor );
    bson_destroy( &b );
    mongo_destroy( &conn );
    
    if(!found){
        printf("Not already in db.\n");
        return 0;
    }else{
        return 1;
    }
    
}
-(int)updateMongoPlanetIdentify:(NSString *)planetColor:(NSString *)planetName{
    bson b, empty;
    mongo conn;
    mongo_cursor cursor;
    
    
    const char * pColor = [planetColor UTF8String];
    const char * pName =[planetName UTF8String];
    const char * user = [[[self appDelegate] getLoggedInUser] UTF8String];
    
    /* Create a rich document like this one:
     *
     *{ "_id" : { "$oid" : "50972af20401767400000001" },
     *   "fake@rharsley" : [
     *   { "front" : "blue", "back" : "yellow" }
     *   ]
     *}
     */
    bson_init( &b );
    bson_append_new_oid( &b, "_id" );// needed?
    
    bson_append_start_array( &b, user);
    bson_append_start_object( &b, "0" );
    bson_append_string( &b, "color", pColor);
    bson_append_string( &b, "name", pName );
    bson_append_finish_object( &b );
    bson_append_finish_object( &b );
    
    
    /* Finish the BSON obj. */
    bson_finish( &b );
    printf("Here's the whole BSON object:\n");
    bson_print( &b );
    
    
    
    /* Now make a connection to MongoDB. */
    if( mongo_connect( &conn, mogodbServer, 27017 ) != MONGO_OK ) {
        switch( conn.err ) {
            case MONGO_CONN_NO_SOCKET:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not create a socket!\n" ];
                break;
            case MONGO_CONN_FAIL:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not connect to mongod. Make sure it's listening at the given server on port 27017.\n"];
                break;
        }
        
        return -1;
    }
    
    /* Insert the sample BSON document. */
    if( mongo_insert( &conn, "helio.identify", &b, NULL ) != MONGO_OK ) {
        [[self appDelegate] writeDebugMessage: [ NSString stringWithFormat:@"FAIL: Failed to insert document with error %d\n", conn.err ]];
        return -1;
    }
    
    /* Query for the inserted document. */
    mongo_cursor_init( &cursor, &conn, "helio.identify" );
    mongo_cursor_set_query( &cursor, bson_empty( &empty ) );
    if( mongo_cursor_next( &cursor ) != MONGO_OK ) {
        [[self appDelegate] writeDebugMessage:@"FAIL: Failed to find inserted document." ];
        return -1;
    }
    
    
    printf( "Found saved BSON object:\n" );
    bson_print( (bson *)mongo_cursor_bson( &cursor ) );
    
    //mongo_cmd_drop_collection( &conn, "helio", "inFrontOf", NULL );
    mongo_cursor_destroy( &cursor );
    bson_destroy( &b );
    mongo_destroy( &conn );
    
    return 0;
}
-(int)checkMongoPlanetIdentify:(NSString *)planetColor:(NSString *)planetName{
    bson b;
    bson_iterator it;
    mongo conn;
    mongo_cursor cursor;
    bool found =NO;
    
    const char * pColor= [planetColor UTF8String];
    const char * pName =[planetName UTF8String];
    const char * user = [[[self appDelegate] getLoggedInUser] UTF8String];
    
    bson_init( &b );
    bson_append_start_array( &b, user);
    bson_append_start_object( &b, "0" );
    bson_append_string( &b, "color", pColor);
    bson_append_string( &b, "name", pName );
    bson_append_finish_object( &b );
    bson_append_finish_object( &b );
    
    /* Finish the BSON obj. */
    bson_finish( &b );
    printf("Here's the whole BSON object:\n");
    bson_print( &b );
    
    /* Now make a connection to MongoDB. */
    if( mongo_connect( &conn, mogodbServer, 27017 ) != MONGO_OK ) {
        switch( conn.err ) {
            case MONGO_CONN_NO_SOCKET:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not create a socket!\n" ];
                break;
            case MONGO_CONN_FAIL:
                [[self appDelegate] writeDebugMessage:@"FAIL: Could not connect to mongodbs. Make sure it's listening at the given server on port 27017.\n" ];
                break;
        }
        
        return -1;
    }
    
    /* Query for the observation. */
    mongo_cursor_init( &cursor, &conn, "helio.identify" );
    mongo_cursor_set_query( &cursor, &b);
    while(mongo_cursor_next( &cursor ) == MONGO_OK ) {
        bson_iterator iterator[1];
        [[self appDelegate] writeDebugMessage:@"checkMongo: FOUND the query." ];
        found =YES;
    }
    mongo_cursor_destroy( &cursor );
    bson_destroy( &b );
    mongo_destroy( &conn );
    
    if(!found){
        printf("Not already in db.\n");
        return 0;
    }else{
        return 1;
    }
}
@end
