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
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger modeChanged = [[NSUserDefaults standardUserDefaults] integerForKey:@"modechanged"];
    if(modeChanged == 1){
        size = [[NSUserDefaults standardUserDefaults] integerForKey:@"previoussize"];
        mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"previousmode"];
    }
    if(mode == 0){
        if(size == 0){
            _sizeLabel.string = @"3x3";
            _modeLabel.string = @"Classic";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3classic"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3classic"];
    
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
            
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore3classic"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel3classic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
    
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 1){
            _sizeLabel.string = @"4x4";
            _modeLabel.string = @"Classic";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4classic"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4classic"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore4classic"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel4classic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
            
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 2){
            _sizeLabel.string = @"5x5";
            _modeLabel.string = @"Classic";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5classic"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5classic"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                    
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore5classic"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel5classic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
                
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
    }
    else if(mode == 1){
        if(size == 0){
            _sizeLabel.string = @"3x3";
            _modeLabel.string = @"Blitz";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3blitz"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3blitz"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore3blitz"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel3blitz"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
                
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 1){
            _sizeLabel.string = @"4x4";
            _modeLabel.string = @"Blitz";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4blitz"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4blitz"];
            
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore4blitz"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel4blitz"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
            
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 2){
            _sizeLabel.string = @"5x5";
            _modeLabel.string = @"Blitz";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5blitz"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5blitz"];
            
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore5blitz"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel5blitz"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
            
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
    }
    else if(mode == 2){
        if(size == 0){
            _sizeLabel.string = @"3x3";
            _modeLabel.string = @"Sudden Death";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3sudden"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3sudden"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore3sudden"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel3sudden"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
            
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 1){
            _sizeLabel.string = @"4x4";
            _modeLabel.string = @"Sudden Death";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4sudden"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4sudden"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore4sudden"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel4sudden"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
            
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 2){
            _sizeLabel.string = @"5x5";
            _modeLabel.string = @"Sudden Death";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5sudden"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5sudden"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                    
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore5sudden"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel5sudden"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
                
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
    }
    else if(mode == 3){
        if(size == 0){
            _sizeLabel.string = @"3x3";
            _modeLabel.string = @"Nightmare";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3nightmare"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3nightmare"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore3nightmare"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel3nightmare"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
            
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 1){
            _sizeLabel.string = @"4x4";
            _modeLabel.string = @"Nightmare";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4nightmare"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4nightmare"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                    
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore4nightmare"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel4nightmare"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
                
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
        else if(size == 2){
            _sizeLabel.string = @"5x5";
            _modeLabel.string = @"Nightmare";
            NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5nightmare"];
            NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5nightmare"];
                
            if(score <= bestscore){
                _highscoreLabel.opacity = 0.0;
            }
            else if(score > bestscore){
                bestScore = score;
                bestLevel = level;
                    
                [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"bestscore5nightmare"];
                [[NSUserDefaults standardUserDefaults] setInteger:bestLevel forKey:@"bestlevel5nightmare"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
                
            _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)score];
            _levelLabel.string = [NSString stringWithFormat:@"%d", (int)level];
                
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
        }
    }
}



@end
