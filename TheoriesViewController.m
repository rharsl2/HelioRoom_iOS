//
//  TheoriesViewController.m
//  HelioRoom
//
//  Created by admin on 1/18/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "TheoriesViewController.h"
#import "AppDelegate.h"
#import "PlanetObservationModel.h"


@interface TheoriesViewController ()
@end

@implementation TheoriesViewController
@synthesize reasonPopover = _reasonPopover;
@synthesize allDropAreas = _allDropAreas;
@synthesize mercuryDropArea =_mercuryDropArea;
@synthesize venusDropArea = _venusDropArea;
@synthesize earthDropArea = _earthDropArea;
@synthesize marsDropArea = _marsDropArea;
@synthesize jupiterDropArea = _jupiterDropArea;
@synthesize saturnDropArea = _saturnDropArea;
@synthesize uranusDropArea = _uranusDropArea;
@synthesize neptuneDropArea = _neptuneDropArea;
//@synthesize plutoDropArea = _plutoDropArea;

//@synthesize reasonViewController = _reasonViewController;

- (NSMutableArray *) allDropAreas{
    if(!_allDropAreas) _allDropAreas=[[NSMutableArray alloc] initWithObjects:mercuryDrop,venusDrop,earthDrop,marsDrop,jupiterDrop,saturnDrop,uranusDrop,neptuneDrop, nil];
    return _allDropAreas;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mercuryDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    self.venusDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    self.earthDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    self.marsDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    self.jupiterDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    self.saturnDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    self.uranusDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    self.neptuneDropArea = [[NSMutableArray alloc] initWithCapacity:5];
    //self.plutoDropArea = [[NSMutableArray alloc] initWithCapacity:5];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//EVENT HANDLERS
- (IBAction)planetDragInside:(UIButton *)sender forEvent:(UIEvent *)event {
    
    //  NSString * planetName = [self tagToPlanet:sender.tag];
    
    //NSLog(@"drag inside event");
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    sender.center=point;

    
    [[self appDelegate] writeDebugMessage:@"drag inside event"];
}

- (IBAction)planetTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event  {
    
    //if in view area of planet. Create new button
    UIButton * newPlanet =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newPlanet setTitle:[self getPlanetColor:sender.tag] forState:UIControlStateNormal];
    CGPoint dropLocation=[self isValidDrop:sender :event :newPlanet];
    if(dropLocation.x !=0){
        [newPlanet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newPlanet setBackgroundImage:[UIImage imageNamed:[self getPlanetImage:sender.tag]] forState:UIControlStateNormal];
        [newPlanet setFrame:CGRectMake(0,0,60,60)];
        [newPlanet addTarget:self action:@selector(createdPlanetDragInside:forEvent:) forControlEvents:UIControlEventTouchDragInside];
        [newPlanet addTarget:self action:@selector(createdPlanetTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newPlanet];
       // CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
        newPlanet.center=dropLocation;
        //create popover event
        [self createdPlanetPopover:newPlanet :@"Mercury"];//TODO change to proper destination
        [sender setAlpha:0];
        [sender setUserInteractionEnabled:NO];
    }
    //else do nothing
    
}

- (IBAction)createdPlanetDragInside:(UIButton *)sender forEvent:(UIEvent *)event{
    //TODO : remove??
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    sender.center=point;
    
    
    [[self appDelegate] writeDebugMessage:@"created planet drag inside event"];
}
- (IBAction)createdPlanetTouchUpInside:(UIButton *)sender{
    //Get previous reason popover and display.
    [[self appDelegate] writeDebugMessage:@"created planet touch up inside event"];
}
//HELPER FUNCTIONS
 -(void) createdPlanetPopover:(UIButton *)created:(NSString *)planet{
     //popover with reasons and delete option.
     TheoryReasonViewController *reasonViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"theoryReason"];
     //TheoryReasonViewController *reasonViewController=[[TheoryReasonViewController alloc] init];
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:reasonViewController];
     reasonViewController.delegate=self;
     self.reasonPopover = [[UIPopoverController alloc] initWithContentViewController:nav];
     
     [self.reasonPopover presentPopoverFromRect:created.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     
 }
-(NSString *)getPlanetImage:(NSInteger)tag{
    int tagInt =tag;
    //printf("tag is %d\n",tagInt);
    switch (tagInt) {
        case 1:return @"redLg.png";
        case 2:return @"blueLg.png";
        case 3:return @"yellowLg.png";
        case 4:return @"orangeLg.png";
        case 5:return @"brownLg.png";
        case 6:return @"pinkLg.png";
        case 7:return @"greenLg.png";
        case 8:return @"grayLg.png";
            
        default:
            return @"An error occured in getPlanetImage";
    }
    return @"An error occured in getPlanetImage";
}
-(NSString *)getPlanetColor:(NSInteger)tag{
    int tagInt =tag;
    //printf("tag is %d\n",tagInt);
    switch (tagInt) {
        case 1:return @"red";
        case 2:return @"blue";
        case 3:return @"yellow";
        case 4:return @"orange";
        case 5:return @"brown";
        case 6:return @"pink";
        case 7:return @"green";
        case 8:return @"gray";
            
        default:
            return @"An error occured in getPlanetImage";
    }
    return @"An error occured in getPlanetImage";
}

-(NSMutableArray *)getDropArea:(int)i{
    //printf("tag is %d\n",tagInt);
    switch (i) {
        case 1:return self.mercuryDropArea;
        case 2:return self.venusDropArea;
        case 3:return self.earthDropArea;
        case 4:return self.marsDropArea;
        case 5:return self.jupiterDropArea;
        case 6:return self.saturnDropArea;
        case 7:return self.uranusDropArea;
        case 8:return self.neptuneDropArea;
        //case 9:return self.plutoDropArea;
            
        default:
            return nil;
    }
    return nil;
}
-(CGPoint)isValidDrop:(UIButton *)sender:(UIEvent *)event:(UIButton *)newPlanet{
    UIControl *control = sender;
    BOOL droppedViewInKnownArea = NO;
    int i=1;
    for (UIImageView *dropArea in self.allDropAreas){
        CGPoint pointInDropView = [[[event allTouches] anyObject] locationInView:dropArea];
        if ([dropArea pointInside:pointInDropView withEvent:nil]) {
            printf("dropped in\n");
            droppedViewInKnownArea =YES;
            //check not drop on top of other planet guess
            CGPoint dropAreaPlacement = [self getDropAreaOpening:i:newPlanet];
            if(dropAreaPlacement.x ==0){
                printf("drop area not open");
                droppedViewInKnownArea=NO;
                [self.view addSubview:sender];
                return dropAreaPlacement;
            }else{
                control.center = dropArea.center;
                CGRect frame = control.frame;
                [sender setFrame:frame];
                [[self appDelegate] writeDebugMessage:@"was in valid drop area!"];
                //control.center = dropAreaPlacement;
                return dropAreaPlacement;
            }
        }
        i++;
    }
    if (!droppedViewInKnownArea) {
//        CGRect frame = sender.frame;
//        frame.origin=[self getOriginalNameLocation:planetName];
//        control.frame =frame;
        [[self appDelegate] writeDebugMessage:@"was not in drop area"];
        [self.view addSubview:sender];
        return CGPointMake(0, 0); 
    }
    
}
-(CGPoint)getDropAreaOpening:(int) i:(UIButton *)newPlanet{
    //iterate and see next open space
    //else return nil;
    NSMutableArray * dropArea = [self getDropArea:i];
    float j=0;
    for (UIButton *createdPlanet in dropArea){
        if([createdPlanet.titleLabel.text isEqualToString:newPlanet.titleLabel.text]){
            //color already present
            [[self appDelegate] writeDebugMessage:@"color already in drop area"];
             return CGPointMake(0, 0);
        }
        j++;
    }
    if(j<=4){//can add another button
        CGFloat x = 260.0 + j*100.0;
        CGFloat y = 35.0 + i*70.0;
        [dropArea addObject:newPlanet];
        return CGPointMake(x,y);  
    }
    return CGPointMake(0, 0);
}

//Delegate Functions
-(void) cancel{
    [self.reasonPopover dismissPopoverAnimated:YES];
}

@end
