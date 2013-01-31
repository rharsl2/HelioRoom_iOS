//
//  OrderReason.h
//  HelioRoom
//
//  Created by admin on 1/30/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface OrderReason : NSManagedObject

@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) Order *ordering;

@end
