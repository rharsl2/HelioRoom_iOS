//
//  ChoosePlanetViewController.m
//  ios-xmppBase
//
//  Created by Rachel Harsley on 11/5/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "ChoosePlanetViewController.h"
#import "AppDelegate.h"
#import "PlanetObservationModel.h"

@interface ChoosePlanetViewController ()
@property (nonatomic,strong) PlanetObservationModel *planetModel;
@end

@implementation ChoosePlanetViewController
@synthesize planetModel= _planetModel;
@synthesize dropAreas = _dropAreas;
@synthesize planetGuesses=_planetGuesses;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.jpeg"]];
    self.view.backgroundColor = background;
    
//    redGuess=nil;
//    blueGuess=nil;
//    yellowGuess=nil;
//    orangeGuess=nil;
//    brownGuess=nil;
//    pinkGuess=nil;
//    greenGuess=nil;
//    purpleGuess=nil;
//    grayGuess=nil;
//    
    redGuess=@"empty";
    blueGuess=@"empty";
    yellowGuess=@"empty";
    orangeGuess=@"empty";
    brownGuess=@"empty";
    pinkGuess=@"empty";
    greenGuess=@"empty";
    purpleGuess=@"empty";
    grayGuess=@"empty";
    

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
- (NSMutableArray *) dropAreas{
    if(!_dropAreas) _dropAreas=[[NSMutableArray alloc] initWithObjects:redDrop,blueDrop,yellowDrop, orangeDrop,brownDrop,pinkDrop,greenDrop,purpleDrop,grayDrop, nil];
    return _dropAreas;
}
- (NSMutableArray *) planetGuesses{
    if(!_planetGuesses) _planetGuesses=[[NSMutableArray alloc] initWithObjects:redGuess,blueGuess,yellowGuess,orangeGuess,brownGuess,pinkGuess,greenGuess,purpleGuess,grayGuess, nil];
    return _planetGuesses;
}
-(PlanetObservationModel *)planetModel{
    if(!_planetModel) _planetModel=[[PlanetObservationModel alloc] init];
    return _planetModel;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Event Handlers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)nameDragInside:(UIButton *)sender forEvent:(UIEvent *)event {
    //TODO check if in drag area. if so clear 
    NSString * planetName = [self tagToPlanet:sender.tag];
    
    [[self appDelegate] writeDebugMessage:@"drag inside event"];

    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    sender.center=point;
 
}

- (IBAction)nameTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event {
    [[self appDelegate] writeDebugMessage:@"touch up inside event"];
    NSString * planetName = [self tagToPlanet:sender.tag];
    [self removeGuess:planetName];
    UIControl *control = sender;
    BOOL droppedViewInKnownArea = NO;
    int i=1;
    for (UITextField *dropArea in self.dropAreas){
        CGPoint pointInDropView = [[[event allTouches] anyObject] locationInView:dropArea];
        if ([dropArea pointInside:pointInDropView withEvent:nil]) {
            printf("dropped in\n");
            droppedViewInKnownArea =YES;
            //check not drop on top of other planet guess
            BOOL dropAreaEmpty = [self isDropAreaEmpty:i];
            if(dropAreaEmpty ==NO){
                printf("drop area not empty");
                droppedViewInKnownArea=NO;
            }else{
                control.center = dropArea.center;
                CGRect frame = control.frame;
                [sender setFrame:frame];
                [self setPlanetGuess:i guess:planetName];
                [[self appDelegate] writeDebugMessage:@"was in drop area!"];
                control.center = CGPointMake(dropArea.center.x, dropArea.center.y+51);
                break;
            }
        }
        i++;
    }
    if (!droppedViewInKnownArea) {
        CGRect frame = sender.frame;
        frame.origin=[self getOriginalNameLocation:planetName];
        control.frame =frame;
        [[self appDelegate] writeDebugMessage:@"was not in drop area"];
    }
//    NSLog(@"PlanetinDropArea1:%@ PlanetInDropArea2:%@ currentTitle:%@",planetInDropArea1,planetInDropArea2,
//          planetName);
    
     
}

- (IBAction)submitButtonPressed:(id)sender {
    printf("Submit button pressed\n");
    //for each observation, send message
//    int i=1;
//    for (NSString * planetGuess in self.planetGuesses){
//        if(planetGuess !=@"empty"){
//            NSString * planetColor =[self indexToColor:i];
//            [[self planetModel] identify:planetColor :planetGuess];
//            NSLog(@"Planet guess: color=%@ guess=%@",planetColor,planetGuess);
//        }
//        printf("i value %d\n",i);
//        i++;
//    }
//
    [self submitGuesses];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Submit Successful"
                                                        message:@"Your observation was submitted."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    //[self.submitButton setAlpha:0]; TODO??
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Logical Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)tagToPlanet:(NSInteger)tag{
    int tagInt =tag;
    //printf("tag is %d\n",tagInt);
    switch (tagInt) {
        case 51:return @"earth";
        case 52:return @"jupiter";
        case 53:return @"mars";
        case 54:return @"mercury";
        case 55:return @"neptune";
        case 56:return @"pluto";
        case 57:return @"saturn";
        case 58:return @"uranus";
        case 59:return @"venus";
            
        default:
            return @"An error occured in tagToPlanet";
    }
    return @"An error occured in tagToPlanet";
}
-(NSString *)indexToColor:(int)index{
    //printf("tag is %d\n",tagInt);
    switch (index) {
        case 1:return @"red";
        case 2:return @"blue";
        case 3:return @"yellow";
        case 4:return @"orange";
        case 5:return @"brown";
        case 6:return @"pink";
        case 7:return @"green";
        case 8:return @"purple";
        case 9:return @"gray";
            
        default:
            return @"An error occured in tagToPlanet";
    }
    return @"An error occured in tagToPlanet";
}
-(void)setPlanetGuess:(int)index guess:(NSString *) planetGuess{
    NSLog(@"setting planet guess index %d\n to %@",index, planetGuess);
    switch (index) {
        case 1:redGuess=planetGuess;
            return;
        case 2:blueGuess=planetGuess;
            return;
        case 3:yellowGuess=planetGuess;
            return;
        case 4:orangeGuess=planetGuess;
            return;
        case 5:brownGuess=planetGuess;
            return;
        case 6:pinkGuess=planetGuess;
            return;
        case 7:greenGuess=planetGuess;
            return;
        case 8:purpleGuess=planetGuess;
            return;
        case 9:grayGuess=planetGuess;
            return;
            
        default:
            return; //error
    }
}
- (CGPoint) getOriginalNameLocation:(NSString *)planet{
    if([planet isEqualToString:@"earth"]){
        return CGPointMake(296, 540);
    }
    else if([planet isEqualToString:@"jupiter"]){
        return CGPointMake(446, 540);
    }else if([planet isEqualToString:@"mars"]){
        return CGPointMake(596, 540);
    }else if([planet isEqualToString:@"mercury"]){
        return CGPointMake(296, 585);
    }else if([planet isEqualToString:@"neptune"]){
        return CGPointMake(446, 585);
    }else if([planet isEqualToString:@"pluto"]){
        return CGPointMake(596, 585);
    }else if([planet isEqualToString:@"saturn"]){
        return CGPointMake(296, 636);
    }else if([planet isEqualToString:@"uranus"]){
        return CGPointMake(446, 636);
    }else if([planet isEqualToString:@"venus"]){
        return CGPointMake(596, 636);
    }else{
        return CGPointMake(0, 0); //error
    }
}
- (BOOL) isDropAreaEmpty:(int) index{
    switch (index) {
        case 1:
            if(redGuess ==@"empty"){
                printf("in red switch");
                [[self appDelegate] writeDebugMessage:redGuess];
                return YES;
            }return NO;
        case 2:
            if(blueGuess==@"empty"){
                return YES;
            }return NO;
        case 3:
            if(yellowGuess==@"empty"){
                return YES;
            }return NO;
        case 4:
            if(orangeGuess==@"empty"){
                return YES;
            }return NO;
        case 5:
            if(brownGuess==@"empty"){
                return YES;
            }return NO;
        case 6:
            if(pinkGuess==@"empty"){
                return YES;
            }return NO;
        case 7:
            NSLog(@"Green guess %@",greenGuess);
            if(greenGuess==@"empty"){
                return YES;
            }return NO;
        case 8:
            if(purpleGuess==@"empty"){
                return YES;
            }return NO;
        case 9:
            if(grayGuess==@"empty"){
                return YES;
            }return NO;
        default:
            return NO;
    }
    return NO;
}
-(void)removeGuess:(NSString *)planetGuess{
    if(redGuess ==planetGuess){
        redGuess =@"empty";
    }else if (blueGuess ==planetGuess){
        blueGuess = @"empty";
    }else if (yellowGuess==planetGuess){
        yellowGuess = @"empty";
    }else if (orangeGuess ==planetGuess){
        orangeGuess = @"empty";
    }else if (brownGuess ==planetGuess){
        brownGuess = @"empty";
    }else if (pinkGuess ==planetGuess){
        pinkGuess = @"empty";
    }else if (greenGuess ==planetGuess){
        greenGuess = @"empty";
    }else if (purpleGuess ==planetGuess){
        purpleGuess = @"empty";
    }else if (grayGuess ==planetGuess){
        grayGuess = @"empty";
    }
}
-(void)submitGuesses{
    if(redGuess != @"empty"){
        [[self planetModel] identify:@"red" :redGuess];
        NSLog(@"Planet guess: color=red guess=%@",redGuess);
    }if (blueGuess  != @"empty"){
        [[self planetModel] identify:@"blue" :blueGuess];
        NSLog(@"Planet guess: color=blue guess=%@",blueGuess);
    }if (yellowGuess != @"empty"){
        [[self planetModel] identify:@"yellow" :yellowGuess];
        NSLog(@"Planet guess: color=yellow guess=%@",yellowGuess);
    }if (orangeGuess  != @"empty"){
        [[self planetModel] identify:@"orange" :orangeGuess];
        NSLog(@"Planet guess: color=orange guess=%@",orangeGuess);
    }if (brownGuess  != @"empty"){
        [[self planetModel] identify:@"brown" :brownGuess];
        NSLog(@"Planet guess: color=brown guess=%@",brownGuess);
    }if (pinkGuess  != @"empty"){
        [[self planetModel] identify:@"pink" :pinkGuess];
        NSLog(@"Planet guess: color=pink guess=%@",pinkGuess);
    }if (greenGuess  != @"empty"){
        [[self planetModel] identify:@"green" :greenGuess];
        NSLog(@"Planet guess: color=green guess=%@",greenGuess);
    }if (purpleGuess  != @"empty"){
        [[self planetModel] identify:@"purple" :purpleGuess];
        NSLog(@"Planet guess: color=purple guess=%@",purpleGuess);
    }if (grayGuess  != @"empty"){
        [[self planetModel] identify:@"gray" :grayGuess];
        NSLog(@"Planet guess: color=gray guess=%@",grayGuess);
    }
}

@end
