//
//  ChoosePlanetViewController.h
//  ios-xmppBase
//
//  Created by admin on 11/5/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePlanetViewController : UIViewController{
    NSString *redGuess;
    NSString *blueGuess;
    NSString *yellowGuess;
    NSString *orangeGuess;
    NSString *brownGuess;
    NSString *pinkGuess;
    NSString *greenGuess;
    NSString *purpleGuess;
    NSString *grayGuess;



    __weak IBOutlet UIImageView *redDrop;
    __weak IBOutlet UIImageView *blueDrop;
    __weak IBOutlet UIImageView *yellowDrop;
    __weak IBOutlet UIImageView *orangeDrop;
    __weak IBOutlet UIImageView *brownDrop;
    __weak IBOutlet UIImageView *pinkDrop;
    __weak IBOutlet UIImageView *greenDrop;
    __weak IBOutlet UIImageView *purpleDrop;
    __weak IBOutlet UIImageView *grayDrop;
}


@property (strong, nonatomic) NSMutableArray *dropAreas;
@property (strong, nonatomic) NSMutableArray *planetGuesses;


//EVENT HANDLERS
- (IBAction)nameDragInside:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)nameTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)submitButtonPressed:(id)sender;

//LOGICAL METHODS
- (NSString *)tagToPlanet:(NSInteger)tag;
-(void)setPlanetGuess:(int)tag guess:(NSString *) planetGuess;
- (CGPoint) getOriginalNameLocation:(NSString *)planet;
- (BOOL) isDropAreaEmpty:(int) index;
-(void)removeGuess:(NSString *)planetGuess;
-(void)submitGuesses;
@end
