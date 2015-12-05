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
    //display "New Highscore!" if there is a highscore.
    CCLabelTTF *_highscoreLabel;
    CCButton *_infoButton;
    ADBannerView *_bannerView;
}

- (void)newGame {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)setLevel:(NSInteger)level
             score:(NSInteger)score bestscore:(NSInteger)bestscore
         bestlevel:(NSInteger)bestlevel{
    
    NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore"];
    NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel"];
    
    if(score <= bestscore){
        _highscoreLabel.opacity = 0.0;
    }
    if(score > bestscore){
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

- (void)infoButtonPressed{    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"instructions"];
    
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 1"];
    CCTransition *slide = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:.2];
    [[CCDirector sharedDirector] pushScene:instructionScene withTransition:slide];
}

- (void)didLoadFromCCB {
    [iAdHelper sharedHelper];
    [iAdHelper setBannerPosition:BOTTOM];
}


@end
