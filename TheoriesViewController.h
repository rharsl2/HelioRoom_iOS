//
//  TheoriesViewController.h
//  HelioRoom
//
//  Created by admin on 1/18/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheoryReasonViewController.h"

@interface TheoriesViewController : UIViewController<TheoryReasonDelegate>
{
    UIPopoverController * _reasonPopover;

    
    //Drop Areas    
    __weak IBOutlet UIImageView *mercuryDrop;
    __weak IBOutlet UIImageView *venusDrop;
    __weak IBOutlet UIImageView *earthDrop;
    __weak IBOutlet UIImageView *marsDrop;
    __weak IBOutlet UIImageView *jupiterDrop;
    __weak IBOutlet UIImageView *saturnDrop;
    __weak IBOutlet UIImageView *uranusDrop;
    __weak IBOutlet UIImageView *neptuneDrop;
    //__weak IBOutlet UIImageView *plutoDrop;
}
//Created Planets in Drop Area
@property (strong, nonatomic) NSMutableArray *allDropAreas;
@property (strong, nonatomic) NSMutableArray *mercuryDropArea;
@property (strong, nonatomic) NSMutableArray *venusDropArea;
@property (strong, nonatomic) NSMutableArray *earthDropArea;
@property (strong, nonatomic) NSMutableArray *marsDropArea;
@property (strong, nonatomic) NSMutableArray *jupiterDropArea;
@property (strong, nonatomic) NSMutableArray *saturnDropArea;
@property (strong, nonatomic) NSMutableArray *uranusDropArea;
@property (strong, nonatomic) NSMutableArray *neptuneDropArea;
//@property (strong, nonatomic) NSMutableArray *plutoDropArea;


@property (weak, nonatomic) IBOutlet UITableView *planetTable;
@property (retain, nonatomic) UIPopoverController * reasonPopover;


//EVENT HANDLERS
- (IBAction)planetDragInside:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)planetTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)createdPlanetDragInside:(UIButton *)sender;
- (IBAction)createdPlanetTouchUpInside:(UIButton *)sender;

//HELPER FUNCTIONS
-(void) createdPlanetPopover:(UIButton *)created:(NSString *)planet;
-(NSString *)getPlanetImage:(NSInteger)tag;
-(NSMutableArray *)getDropArea:(int)i;
-(CGPoint)isValidDrop:(UIButton *)sender:(UIEvent *)event:(UIButton *)newPlanet;
-(CGPoint)getDropAreaOpening:(int) i:(UIButton *)newPlanet;
@end
