//
//  GameOver.m
//  AddOn
//
//  Created by Elliot Catalano on 11/7/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import "GameOver.h"
#import "iAdHelper.h"

@implementation GameOver {
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_bestscoreLabel;
    CCLabelTTF *_bestlevelLabel;
    CCLabelTTF *_highscoreLabel;
    CCNodeColor *_backgroundColor;
    ADBannerView *_bannerView;
}

- (void)didLoadFromCCB {
    //midnight theme
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];

    if(theme == 0){
        //Classic theme, do nothing
    }
    else if(theme == 1){
        //Daylight theme
        _backgroundColor.color = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];

    }
    else if(theme == 2){
        //Midnight theme
        _backgroundColor.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.3];
    }
    
}

- (void)newGame {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"modechanged"];
}

- (void)setLevel:(NSInteger)level
             score:(NSInteger)score bestscore:(NSInteger)bestscore
         bestlevel:(NSInteger)bestlevel{
    
    //NSLog(@"Ran once");
    NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore"];
    NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel"];
    NSInteger modeChanged = [[NSUserDefaults standardUserDefaults] integerForKey:@"modechanged"];

    
    if(score <= bestscore){
        _highscoreLabel.opacity = 0.0;
    }
    else if(score > bestscore && modeChanged != 1){
        bestScore = score;
        bestLevel = level;
        
        [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore"];
        [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
    _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
    
    _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
    _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
}



@end
