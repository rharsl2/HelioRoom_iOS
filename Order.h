//
//  Order.h
//  HelioRoom
//
//  Created by admin on 1/30/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Order : NSManagedObject

@property (nonatomic, retain) NSString * frontColor;
@property (nonatomic, retain) NSString * backColor;
@property (nonatomic, retain) NSManagedObject *reasoning;

@end
