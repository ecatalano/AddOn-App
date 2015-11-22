//
//  GameOver.m
//  2048Tutorial
//
//  Created by Elliot Catalano on 11/7/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver {
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_bestscoreLabel;
    CCLabelTTF *_bestlevelLabel;
    //display "New Highscore!" if there is a highscore.
    CCLabelTTF *_highscoreLabel;
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
    
    _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
    _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
    
    _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
    _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
    

    if(score > bestscore){
        _highscoreLabel.string = @"New Highscore!";
        
        bestScore = score;
        bestLevel = level;
        
        [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore"];
        [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)level];

    }

}


@end
