//
//  HighScore.m
//  AddOn
//
//  Created by Elliot Catalano on 1/2/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import "HighScore.h"

@implementation HighScore
{
    CCLabelTTF *_bestscoreLabel;
    CCLabelTTF *_bestlevelLabel;
    CCButton *_modeButton;
    CCButton *_sizeButton;
    CCNodeGradient *_baseGradient;
    CCNodeGradient *_backgroundGradient;
}


-(void)didLoadFromCCB{
    [self updateDisplay];
}
-(void)updateDisplay{
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3classic"];
    NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3classic"];
    NSInteger selectedMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedmode"];
    if(selectedMode == 0){
        //Classic
        bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscoreclassic"];
        bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelclassic"];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        _modeButton.title = @"Classic";
    }
    if(selectedMode == 1){
        //Blitz
        bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscoreblitz"];
        bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelblitz"];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        _modeButton.title = @"Blitz";
    }
    if(selectedMode == 2){
        //Classic
        bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscoresudden"];
        bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelsudden"];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        _modeButton.title = @"Sudden Death";
    }
    if(selectedMode == 3){
        //Classic
        bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscorenightmare"];
        bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelnightmare"];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        _modeButton.title = @"Nightmare";
    }

    if(theme == 0){
        _backgroundGradient.startColor = [CCColor colorWithRed:0.220 green:0.770 blue:0.780 alpha:0.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.498 green:0.408 blue:0.571 alpha:0.0];
    }
    else if(theme == 1){
        //Day Theme
        _backgroundGradient.startColor = [CCColor grayColor];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
    }
    else if(theme == 2){
        //Midnight Theme
        _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3];
    }
}

-(void)modeButtonPressed{
    NSInteger selectedMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedmode"];
    if(selectedMode < 3){
        selectedMode+=1;
    }
    else if(selectedMode == 3){
        selectedMode = 0;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:selectedMode forKey:@"selectedmode"];
    [self updateDisplay];
}
- (void)back {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}


@end
