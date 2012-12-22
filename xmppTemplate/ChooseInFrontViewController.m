//
//  ChooseInFrontViewController.m
//  ios-xmppBase
//
//  Created by Rachel Harsley on 9/26/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "ChooseInFrontViewController.h"
#import "AppDelegate.h"
#import "PlanetObservationModel.h"

@interface ChooseInFrontViewController ()
@property (nonatomic,strong) PlanetObservationModel *planetModel;
@end

@implementation ChooseInFrontViewController
@synthesize loginButton =_loginButton;
@synthesize planetModel= _planetModel;
@synthesize dropAreas = _dropAreas;

//TODO one planet in drop Area!!!
//Add X to remove planet

//Bring Large Planet back to original location


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.jpeg"]];
    self.view.backgroundColor = background;
    
    backPlanetChoseView.userInteractionEnabled=NO;
    [self.view sendSubviewToBack:backPlanetChoseView];
    
    frontPlanetChoseView.userInteractionEnabled=NO;
    [self.view sendSubviewToBack:frontPlanetChoseView];
    
    for (UIImageView *dropArea in self.dropAreas){
        dropArea.userInteractionEnabled=NO;
        [self.view sendSubviewToBack:dropArea];
    }
    
    [self.loginButton setTitle:[self.appDelegate getLoggedInUser]forState:UIControlStateNormal];
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"spaceshipSubmitButton1.png"],
                             [UIImage imageNamed:@"spaceshipSubmitButton2.png"],
                             [UIImage imageNamed:@"spaceshipSubmitButton3.png"],
                             [UIImage imageNamed:@"spaceshipSubmitButton4.png"],
                             [UIImage imageNamed:@"spaceshipSubmitButton5.png"],
                             nil];
    //UIImageView *animationView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,348, 450)];
    self.submitButtonAnimation.animationImages=animationArray;
    self.submitButtonAnimation.animationDuration=1.7;
    self.submitButtonAnimation.animationRepeatCount=0;
    //[self.submitButtonAnimation startAnimating];
    //[self.view addSubview:animationView];
    
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (NSMutableArray *) dropAreas{
    if(!_dropAreas) _dropAreas=[[NSMutableArray alloc] initWithObjects:frontPlanetArea,backPlanetArea, nil];
    return _dropAreas;
}
-(PlanetObservationModel *)planetModel{
    if(!_planetModel) _planetModel=[[PlanetObservationModel alloc] init];
    return _planetModel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Event Handlers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)sendPressed:(id)sender {
    [[self planetModel] sendMessage:msgField.text :toField.text];
}
- (IBAction)sendGroupPressed:(id)sender {
    //[[self planetModel] sendGroupMessage:msgField.text];
    [[self planetModel] isInFrontOf:@"blue" :@"red"];
}

- (IBAction)planetTouchDown:(UIButton *)sender forEvent:(UIEvent *)event {
    [[self appDelegate] writeDebugMessage:@"touchdown event"];
    NSString * planetName = [self tagToPlanet:sender.tag];
    
    [[self getLargePlanetButton:planetName] setAlpha:1];
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    [[self getLargePlanetButton:planetName] setAlpha:1];
    [self getLargePlanetButton:planetName].center=point;
}

- (IBAction)planetDragInside:(UIButton *)sender withEvent:(UIEvent *) event {
    UIControl *control = sender;
    NSString * planetName = [self tagToPlanet:sender.tag];

    [[self getLargePlanetButton:planetName] setAlpha:1];
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    control.center = point;
    [self getLargePlanetButton:planetName].center=point;
    [[self appDelegate] writeDebugMessage:@"drag inside event"];
}

- (IBAction)planetTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event {
    [[self appDelegate] writeDebugMessage:@"touch up inside event"];
    NSString * planetName = [self tagToPlanet:sender.tag];
    UIControl *control = sender;
    BOOL droppedViewInKnownArea = NO;
    int i=1;
    for (UIImageView *dropArea in self.dropAreas){
        CGPoint pointInDropView = [[[event allTouches] anyObject] locationInView:dropArea];
        if ([dropArea pointInside:pointInDropView withEvent:nil]) {
            droppedViewInKnownArea =YES;
            if((i==1 && planetInDropArea1!=nil)
               ||(i==2 && planetInDropArea2!=nil)){
                   droppedViewInKnownArea=NO;
            }else{
            control.center = dropArea.center;
            CGRect frame = control.frame;
            [sender setFrame:frame];
            [self planetInDropArea:i planet:sender ];
            [[self appDelegate] writeDebugMessage:@"was in drop area!"];
            control.center = CGPointMake(dropArea.center.x, dropArea.center.y-30);
            [self getLargePlanetButton:planetName].center=CGPointMake(dropArea.center.x, dropArea.center.y-30);
            }
        }
        i++;
    }
    if (!droppedViewInKnownArea) {
        if([planetInDropArea1 isEqualToString:planetName] ){
            planetInDropArea1=nil;
            [frontPlanetChoseView setAlpha:0];
            
        }else if([planetInDropArea2 isEqualToString:planetName]){
            planetInDropArea2=nil;
            [backPlanetChoseView setAlpha:0];
        }
        CGRect frame = sender.frame;
        frame.origin=[self getOriginalPlanetLocation:planetName];
        control.frame =frame;
        [[self getLargePlanetButton:planetName] setAlpha:0];
        [self getLargePlanetButton:planetName].frame=frame;
        [[self appDelegate] writeDebugMessage:@"was not in drop area"];
        [self updateDropView];
    }
    [self updateSubmitButton];
    //[self updateIsInFront];
    NSLog(@"PlanetinDropArea1:%@ PlanetInDropArea2:%@ currentTitle:%@",planetInDropArea1,planetInDropArea2,
          planetName);
}

- (IBAction)submitButtonPressed:(id)sender {
    [[self planetModel] isInFrontOf:planetInDropArea1 :planetInDropArea2];
    //[self.submitButton setAlpha:0]; TODO??
}

- (IBAction)loginButtonPressed:(id)sender {
    [[self appDelegate] disconnect];
    [self clearDropAreas];
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[self appDelegate] showLoginView:self];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Logical Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateIsInFront{
    if(planetInDropArea1!=nil && planetInDropArea2!=nil){
        isInFrontView.alpha=1;
    }else{
        isInFrontView.alpha=0;
    }
    
}
-(void) updateSubmitButton{
    if(planetInDropArea1 !=nil && planetInDropArea2!=nil){
        self.submitButton.alpha=1;
        self.submitButtonAnimation.alpha=1;
        self.submitButton.userInteractionEnabled=YES;
        [self.submitButtonAnimation startAnimating];
    }else{
        self.submitButton.alpha=0;
        self.submitButtonAnimation.alpha=0;
        self.submitButton.userInteractionEnabled=NO;
    }
}
- (void) updateDropView{
    if(planetInDropArea1==nil){
        [frontPlanetArea setAlpha:1];
        [frontPlanetChoseView setAlpha:0];
        [dropClosest setAlpha:1];
    }else{
        [frontPlanetArea setAlpha:0];
        [frontPlanetChoseView setAlpha:1];
        [dropClosest setAlpha:0];
    }
    if(planetInDropArea2==nil){
        [backPlanetArea setAlpha:1];
        [backPlanetChoseView setAlpha:0];
        [dropFurthest setAlpha:1];
        
    }else{
        [backPlanetArea setAlpha:0];
        [backPlanetChoseView setAlpha:1];
        [dropFurthest setAlpha:0];
        
    }
}
- (void) planetInDropArea:(int)dropArea planet:(UIButton *)planet {
    NSString * planetName = [self tagToPlanet:planet.tag];
    
    if(dropArea == 1){//in front dropArea
        planetInDropArea1 =planetName;
        if([planetInDropArea1 isEqualToString:planetInDropArea2]){
            [backPlanetChoseView setAlpha:0];
            planetInDropArea2=nil;
        }
        
    }else if(dropArea ==2){ //in back drop area
        planetInDropArea2=planetName;
        if([planetInDropArea2 isEqualToString:planetInDropArea1]){
            [frontPlanetChoseView setAlpha:0];
            planetInDropArea1=nil;
        }
    }
   [self updateDropView];
}

- (CGPoint) getOriginalPlanetLocation:(NSString *)planet{
    //Have to hard code :(?
    //TODO
    if([planet isEqualToString:@"red"]){
        return CGPointMake(0, 25);
    }
    else if([planet isEqualToString:@"blue"]){
        return CGPointMake(105, 25);
    }else if([planet isEqualToString:@"yellow"]){
        return CGPointMake(210, 25);
    }else if([planet isEqualToString:@"orange"]){
        return CGPointMake(315, 25);
    }else if([planet isEqualToString:@"brown"]){
        return CGPointMake(420, 25);
    }else if([planet isEqualToString:@"pink"]){
        return CGPointMake(525, 25);
    }else if([planet isEqualToString:@"green"]){
        return CGPointMake(630, 25);
    }else if([planet isEqualToString:@"purple"]){
        return CGPointMake(735, 25);
    }else if([planet isEqualToString:@"gray"]){
        return CGPointMake(840, 25);
    }
    else{
        return CGPointMake(0, 0);
    }
}
-(UIButton *)getPlanetButton:(NSString*)planet{
    if([planet isEqualToString:@"red"]){
        return self.redPlanet;
    }else if([planet isEqualToString:@"blue"]){
        return self.bluePlanet;
    }else if([planet isEqualToString:@"yellow"]){
        return self.yellowPlanet;
    }else if([planet isEqualToString:@"orange"]){
        return self.orangePlanet;
    }else if([planet isEqualToString:@"brown"]){
        return self.brownPlanet;
    }else if([planet isEqualToString:@"pink"]){
        return self.pinkPlanet;
    }else if([planet isEqualToString:@"green"]){
        return self.greenPlanet;
    }else if([planet isEqualToString:@"purple"]){
        return self.purplePlanet;
    }else if([planet isEqualToString:@"gray"]){
        return self.grayPlanet;
    }
    else{
        return NULL;
    }
}
-(UIButton *)getLargePlanetButton:(NSString*)planet{
    if([planet isEqualToString:@"red"]){
        return self.redPlanetLg;
    }else if([planet isEqualToString:@"blue"]){
        return self.bluePlanetLg;
    }else if([planet isEqualToString:@"yellow"]){
        return self.yellowPlanetLg;
    }else if([planet isEqualToString:@"orange"]){
        return self.orangePlanetLg;
    }else if([planet isEqualToString:@"brown"]){
        return self.brownPlanetLg;
    }else if([planet isEqualToString:@"pink"]){
        return self.pinkPlanetLg;
    }else if([planet isEqualToString:@"green"]){
        return self.greenPlanetLg;
    }else if([planet isEqualToString:@"purple"]){
        return self.purplePlanetLg;
    }else if([planet isEqualToString:@"gray"]){
        return self.grayPlanetLg;
    }
    else{
        return NULL;
    }
}
-(NSString *)tagToPlanet:(NSInteger)tag{
    if(tag == 11 || tag ==21){
        return @"red";
    }else if (tag ==12 || tag ==22){
        return @"blue";
    }else if (tag ==13 || tag ==23){
        return @"yellow";
    }else if (tag ==14 || tag ==24){
        return @"orange";
    }else if (tag ==15 || tag ==25){
        return @"brown";
    }else if (tag ==16 || tag ==26){
        return @"pink";
    }else if (tag ==17 || tag ==27){
        return @"green";
    }else if (tag ==18 || tag ==28){
        return @"purple";
    }else if (tag ==19 || tag ==29){
        return @"gray";
    }else{
        return @"An error occured in tagToPlanet";
    }
}
-(void) clearDropAreas{
    if(planetInDropArea1!=nil){
        [self getLargePlanetButton:planetInDropArea1].alpha =0;
        [self getPlanetButton:planetInDropArea1].center =[self getOriginalPlanetLocation:planetInDropArea1];
        [self getLargePlanetButton:planetInDropArea1].center =[self getOriginalPlanetLocation:planetInDropArea1];
        [frontPlanetChoseView setAlpha:0];
        [frontPlanetArea setAlpha:1];
    }
    if(planetInDropArea2!=nil){
        [self getLargePlanetButton:planetInDropArea2].alpha =0;
        [self getPlanetButton:planetInDropArea2].center =[self getOriginalPlanetLocation:planetInDropArea2];
        [self getLargePlanetButton:planetInDropArea2].center =[self getOriginalPlanetLocation:planetInDropArea2];
        [backPlanetChoseView setAlpha:0];
        [backPlanetArea setAlpha:1];
    }
    
    planetInDropArea1=nil;
    planetInDropArea2=nil;
    //isInFrontView.alpha=0;
    [self updateSubmitButton];

}
@end
