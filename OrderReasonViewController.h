//
//  OrderReasonViewController.h
//  HelioRoom
//
//  Created by admin on 1/26/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderReasonDelegate
- (void)reasonSelected:(NSString *)reason:(NSString *) front:(NSString *)back;
@end

@interface OrderReasonViewController : UITableViewController{
    NSMutableArray *_reasons;
    // id<OrderReasonDelegate> _delegate;
}
@property (nonatomic, retain) NSMutableArray *reasons;
@property (nonatomic, retain) id<OrderReasonDelegate> delegate;

//Helper functions
-(void) setReasons:(NSString *)created:(NSString *)destination;


@end
