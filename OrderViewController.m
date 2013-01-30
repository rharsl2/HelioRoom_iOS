//
//  OrderViewController.m
//  HelioRoom
//
//  Created by admin on 1/26/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "OrderViewController.h"
#import "AppDelegate.h"

@interface OrderViewController ()

@end

@implementation OrderViewController
//@synthesize reasonPicker = _reasonPicker;
@synthesize reasonPopover = _reasonPopover;
@synthesize allDropAreas = _allDropAreas;
@synthesize redDropArea =_redDropArea;
@synthesize blueDropArea = _blueDropArea;
@synthesize yellowDropArea = _yellowDropArea;
@synthesize orangeDropArea = _orangeDropArea;
@synthesize brownDropArea = _brownDropArea;
@synthesize pinkDropArea = _pinkDropArea;
@synthesize greenDropArea = _greenDropArea;
@synthesize grayDropArea = _grayDropArea;

NSString * mostRecentDropColor=@"";


//@synthesize reasonViewController = _reasonViewController;

- (NSMutableArray *) allDropAreas{
    if(!_allDropAreas) _allDropAreas=[[NSMutableArray alloc] initWithObjects:redDrop,blueDrop,yellowDrop,orangeDrop,brownDrop,pinkDrop,greenDrop,grayDrop, nil];
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
    self.redDropArea = [[NSMutableArray alloc] initWithCapacity:7];
    self.blueDropArea = [[NSMutableArray alloc] initWithCapacity:7];
    self.yellowDropArea = [[NSMutableArray alloc] initWithCapacity:7];
    self.orangeDropArea = [[NSMutableArray alloc] initWithCapacity:7];
    self.brownDropArea = [[NSMutableArray alloc] initWithCapacity:7];
    self.pinkDropArea = [[NSMutableArray alloc] initWithCapacity:7];
    self.greenDropArea = [[NSMutableArray alloc] initWithCapacity:7];
    self.grayDropArea = [[NSMutableArray alloc] initWithCapacity:7];
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
- (IBAction)colorDragInside:(UIButton *)sender forEvent:(UIEvent *)event {
    
    //  NSString * planetName = [self tagToPlanet:sender.tag];
    
    //NSLog(@"drag inside event");
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    sender.center=point;
    
    
    [[self appDelegate] writeDebugMessage:@"drag inside event"];
}

- (IBAction)colorTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event  {
    
    //if in view area of planet. Create new button
    UIButton * newPlanet =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newPlanet setTitle:[self getColor:sender.tag] forState:UIControlStateNormal];
    CGPoint dropLocation=[self isValidDrop:sender :event :newPlanet];
    if(dropLocation.x !=0){
        [newPlanet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newPlanet setBackgroundImage:[UIImage imageNamed:[self getColorImage:sender.tag]] forState:UIControlStateNormal];
        [newPlanet setFrame:CGRectMake(0,0,70,70)];
        [newPlanet addTarget:self action:@selector(createdColorDragInside:forEvent:) forControlEvents:UIControlEventTouchDragInside];
        [newPlanet addTarget:self action:@selector(createdColorTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newPlanet];
        // CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
        newPlanet.center=dropLocation;
        //create popover event
        [self createdColorPopover:newPlanet :mostRecentDropColor];//TODO change change to proper destination

    }
    //else do nothing
    
}

- (IBAction)createdColorDragInside:(UIButton *)sender forEvent:(UIEvent *)event{
    //TODO : remove??
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    sender.center=point;
    
    
    [[self appDelegate] writeDebugMessage:@"created planet drag inside event"];
}
- (IBAction)createdColorTouchUpInside:(UIButton *)sender{
    //Get previous reason popover and display.
    [[self appDelegate] writeDebugMessage:@"created planet touch up inside event"];
}

- (IBAction)loginButtonPressed:(id)sender {
    [[self appDelegate] disconnect];
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[self appDelegate] showLoginView:self];
    }];
}

//HELPER FUNCTIONS
-(void) createdColorPopover:(UIButton *)created:(NSString *)destination{
    //popover with reasons and delete option.
    //OrderReasonViewController *reasonViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"OrderReason"];
    
    OrderReasonViewController *reasonViewController=[[OrderReasonViewController alloc] initWithStyle:UITableViewStylePlain];
    [reasonViewController setReasons:created.titleLabel.text :destination];
    [reasonViewController.view setNeedsDisplay];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:reasonViewController];
    reasonViewController.delegate=self;
    self.reasonPopover = [[UIPopoverController alloc] initWithContentViewController:nav];
    self.reasonPopover.passthroughViews = [[NSArray alloc] initWithObjects:self.view, nil];
    [self.reasonPopover presentPopoverFromRect:created.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
-(NSString *)getColorImage:(NSInteger)tag{
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
-(NSString *)getColor:(NSInteger)tag{
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
        case 1:return self.redDropArea;
        case 2:return self.blueDropArea;
        case 3:return self.yellowDropArea;
        case 4:return self.orangeDropArea;
        case 5:return self.brownDropArea;
        case 6:return self.pinkDropArea;
        case 7:return self.greenDropArea;
        case 8:return self.grayDropArea;
            
        default:
            return nil; //ERROR
    }
    return nil; //ERROR
}
-(UIImageView *)getDropPlanetObject:(int)i{
    //printf("tag is %d\n",tagInt);
    switch (i) {
        case 1:return redDrop;
        case 2:return blueDrop;
        case 3:return yellowDrop;
        case 4:return orangeDrop;
        case 5:return brownDrop;
        case 6:return pinkDrop;
        case 7:return greenDrop;
        case 8:return grayDrop;
            
        default:
            return nil; //ERROR
    }
    return nil; //ERROR
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
                mostRecentDropColor = [self getColor:i];
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
    if([newPlanet.titleLabel.text isEqualToString:[self getColor:i]]){
        [[self appDelegate] writeDebugMessage:@"placing on same color"];
        return CGPointMake(0, 0);
    }
    for (UIButton *createdPlanet in dropArea){
        if([createdPlanet.titleLabel.text isEqualToString:newPlanet.titleLabel.text]){ //TODO FIx! Check for placement of same color
            //color already present
            [[self appDelegate] writeDebugMessage:@"color already in drop area."];
            return CGPointMake(0, 0);
        }
        j++;
    }
    CGPoint dropOrigin = [self getDropPlanetObject:i].frame.origin;
    if(j<=2){//>= 3 colors dropped 
        CGFloat x = dropOrigin.x + 80 + j*70.0;
        CGFloat y = dropOrigin.y +70;
        [dropArea addObject:newPlanet];
        return CGPointMake(x,y);
    }
    else if(j<=5){//>= 6 colors dropped
        CGFloat x = dropOrigin.x + 80+ fmod(j, 3.0)*70.0;
        CGFloat y = dropOrigin.y + 140;
        [dropArea addObject:newPlanet];
        return CGPointMake(x,y);
    }
    else if(j<=6){//>= 7 colors dropped
        CGFloat x = dropOrigin.x + 80+ fmod(j, 3.0)*70.0;
        CGFloat y = dropOrigin.y + 210;
        [dropArea addObject:newPlanet];
        return CGPointMake(x,y);
    }
    NSLog(@"j %f",j);
    return CGPointMake(0, 0);
}

//Delegate Functions
-(void) cancel{
    [self.reasonPopover dismissPopoverAnimated:YES];
}

- (void)reasonSelected:(NSString *)reason {
    //TODO Submit reason
    [self.reasonPopover dismissPopoverAnimated:YES];
}

@end
