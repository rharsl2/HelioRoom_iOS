//
//  OrderViewController.h
//  HelioRoom
//
//  Created by admin on 1/26/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderReasonViewController.h"

@interface OrderViewController : UIViewController<OrderReasonDelegate>
{
    //OrderReasonViewController * _reasonPicker;
    UIPopoverController * _reasonPopover;
    
    
    
    //Drop Areas
    __weak IBOutlet UIImageView *redDrop;
    __weak IBOutlet UIImageView *blueDrop;
    __weak IBOutlet UIImageView *yellowDrop;
    __weak IBOutlet UIImageView *orangeDrop;
    __weak IBOutlet UIImageView *brownDrop;
    __weak IBOutlet UIImageView *pinkDrop;
    __weak IBOutlet UIImageView *greenDrop;
    __weak IBOutlet UIImageView *grayDrop;

}
//Created Colors in Drop Area stored in these arrays
@property (strong, nonatomic) NSMutableArray *allDropAreas;
@property (strong, nonatomic) NSMutableArray *redDropArea;
@property (strong, nonatomic) NSMutableArray *blueDropArea;
@property (strong, nonatomic) NSMutableArray *yellowDropArea;
@property (strong, nonatomic) NSMutableArray *orangeDropArea;
@property (strong, nonatomic) NSMutableArray *brownDropArea;
@property (strong, nonatomic) NSMutableArray *pinkDropArea;
@property (strong, nonatomic) NSMutableArray *greenDropArea;
@property (strong, nonatomic) NSMutableArray *grayDropArea;


@property (weak, nonatomic) IBOutlet UITableView *planetTable;
//@property (nonatomic,retain) OrderReasonViewController *reasonPicker;
@property (retain, nonatomic) UIPopoverController * reasonPopover;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;


//EVENT HANDLERS
- (IBAction)colorDragInside:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)colorTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)createdColorDragInside:(UIButton *)sender;
- (IBAction)createdColorTouchUpInside:(UIButton *)sender;

//HELPER FUNCTIONS
-(void) createdColorPopover:(UIButton *)created:(NSString *)destination;
-(NSString *)getColorImage:(NSInteger)tag;
-(NSString *)getColor:(NSInteger)tag;
-(NSMutableArray *)getDropArea:(int)i;
-(UIImageView *)getDropPlanetObject:(int)i;
-(CGPoint)isValidDrop:(UIButton *)sender:(UIEvent *)event:(UIButton *)newColor;
-(CGPoint)getDropAreaOpening:(int) i:(UIButton *)newColor;

@end
