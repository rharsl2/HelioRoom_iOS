//
//  ChooseInFrontViewController.h
//  ios-xmppBase
//
//  Created by Rachel Harsley on 9/26/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseInFrontViewController : UIViewController{
    __weak IBOutlet UITextField *toField;
    __weak IBOutlet UITextView *msgField;
    
    __weak IBOutlet UIImageView *frontPlanetArea;
    __weak IBOutlet UIImageView *backPlanetArea;
    
    __weak IBOutlet UIImageView *frontPlanetChoseView;
    __weak IBOutlet UIImageView *backPlanetChoseView;
    
    __weak IBOutlet UIImageView *isInFrontView;
    
    __weak IBOutlet UILabel *dropClosest;
    __weak IBOutlet UILabel *dropFurthest;
    
    NSString * planetInDropArea1;
    NSString * planetInDropArea2;
    
    UIImage * blank;
    
    UIImage *image;
    UIImage *image2;
}

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) NSMutableArray *dropAreas;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *submitButtonAnimation;

//PLANETS
@property (weak, nonatomic) IBOutlet UIButton *redPlanet;
@property (weak, nonatomic) IBOutlet UIButton *redPlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *bluePlanet;
@property (weak, nonatomic) IBOutlet UIButton *bluePlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *yellowPlanet;
@property (weak, nonatomic) IBOutlet UIButton *yellowPlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *orangePlanet;
@property (weak, nonatomic) IBOutlet UIButton *orangePlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *brownPlanet;
@property (weak, nonatomic) IBOutlet UIButton *brownPlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *pinkPlanet;
@property (weak, nonatomic) IBOutlet UIButton *pinkPlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *greenPlanet;
@property (weak, nonatomic) IBOutlet UIButton *greenPlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *purplePlanet;
@property (weak, nonatomic) IBOutlet UIButton *purplePlanetLg;
@property (weak, nonatomic) IBOutlet UIButton *grayPlanet;
@property (weak, nonatomic) IBOutlet UIButton *grayPlanetLg;



//EVENT HANDLING
- (IBAction)sendPressed:(id)sender;
- (IBAction)sendGroupPressed:(id)sender;
- (IBAction)planetTouchDown:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)planetDragInside:(UIButton *)sender withEvent:(UIEvent *) event;
- (IBAction)planetTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;


//LOGICAL METHODS
- (void) updateIsInFront;
-(void) updateSubmitButton;
- (void) updateDropView;
- (void) planetInDropArea:(int)dropArea planet:(UIButton *)planet;
- (CGPoint) getOriginalPlanetLocation:(NSString *)planet;
-(UIButton *)getPlanetButton:(NSString*)planet;
-(UIButton *)getLargePlanetButton:(NSString*)planet;
-(NSString *)tagToPlanet:(NSInteger)tag;
-(void) clearDropAreas;

@end
