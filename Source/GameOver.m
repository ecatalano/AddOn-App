//
//  GameOver.m
//  AddOn
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
    CCLabelTTF *_highscoreLabel;
    CCNodeColor *_backgroundColor;
    ADBannerView *_bannerView;
    CCLabelTTF *_sizeLabel;
    CCLabelTTF *_modeLabel;
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
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger modeChanged = [[NSUserDefaults standardUserDefaults] integerForKey:@"modechanged"];
    if(modeChanged == 1){
        mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"previousmode"];
    }
    if(mode == 0){
        _modeLabel.string = @"Classic";
        NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscoreclassic"];
        NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelclassic"];
    
        if(score <= bestscore){
            _highscoreLabel.opacity = 0.0;
        }
        else if(score > bestscore){
            bestScore = score;
            bestLevel = level;
            
            [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscoreclassic"];
            [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevelclassic"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    
        _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
        _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
    }
    else if(mode == 1){
        _modeLabel.string = @"Blitz";
        NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscoreblitz"];
        NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelblitz"];
        
        if(score <= bestscore){
            _highscoreLabel.opacity = 0.0;
        }
        else if(score > bestscore){
            bestScore = score;
            bestLevel = level;
            
            [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscoreblitz"];
            [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevelblitz"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
        _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
    }
    else if(mode == 2){
        _modeLabel.string = @"Sudden Death";
        NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscoresudden"];
        NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelsudden"];
        
        if(score <= bestscore){
            _highscoreLabel.opacity = 0.0;
        }
        else if(score > bestscore){
            bestScore = score;
            bestLevel = level;
            
            [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscoresudden"];
            [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevelsudden"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
        _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
    }
    else if(mode == 3){
        _modeLabel.string = @"Nightmare";
        NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscorenightmare"];
        NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevelnightmare"];
        
        if(score <= bestscore){
            _highscoreLabel.opacity = 0.0;
        }
        else if(score > bestscore){
            bestScore = score;
            bestLevel = level;
            
            [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscorenightmare"];
            [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevelnightmare"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
        _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
        _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
        _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
    }
    
}



@end
