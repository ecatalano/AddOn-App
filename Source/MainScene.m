//
//  MainScene.m
//  AddOn
//
//  Created by Elliot Catalano on 10/17/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//
#import "MainScene.h"
#import "AppDelegate.h"
#import "Grid.h"
#import "Menu.h"
#import "Instruction.h"
#import "iAdHelper.h"
#import "GameOver.h"

@implementation MainScene{
    Grid *_grid;
    CCNodeGradient *_baseGradient;
    CCNodeGradient *_backgroundGradient;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_scoretLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_leveltLabel;
    CCLabelTTF *_timeLabel;
    CCLabelTTF *_timetLabel;
    CCLabelTTF *_currentValueLabel;
    CCLabelTTF *_greatesttValueLabel;
    CCLabelTTF *_greatestValueLabel;
    CCLabelTTF *_modeLabel;
}

- (void)didLoadFromCCB {
    [iAdHelper sharedHelper];
    [iAdHelper setBannerPosition:BOTTOM];
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];

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
    if(mode == 0){
        //Classic
        _modeLabel.string = @"Mode: Classic";
    }
    else if(mode == 1){
        //Blitz
        _modeLabel.string = @"Mode: Blitz";

    }
    else if(mode == 2){
        //Sudden Death
        _modeLabel.string = @"Mode: Sudden Death";
        _timeLabel.string = @"-";
        _greatesttValueLabel.opacity = 0.0;
        _greatestValueLabel.opacity = 0.0;
        _currentValueLabel.opacity = 0.0;
    }
    else if(mode == 3){
        //Nightmare
        _modeLabel.string = @"Mode: Nightmare";
        _timeLabel.string = @"?";
        _greatesttValueLabel.opacity = 0.0;
        _greatestValueLabel.opacity = 0.0;
        _currentValueLabel.opacity = 0.0;
    }
    if(size == 0){
        CGPoint pos = _grid.position;
        pos.x = pos.x * .91;
        _grid.position = pos;
    }
    else if(size == 1){
        CGPoint pos = _grid.position;
        pos.x = pos.x * .97;
        _grid.position = pos;
    }
    else if(size == 2){
        CGPoint pos = _grid.position;
        _grid.position = pos;
    }

    
    NSInteger currentTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"currenttime"];
    NSInteger currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"];
    NSInteger currentScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentscore"];
    NSInteger greatestPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"greatestpath"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"instructions"];


    _levelLabel.string = [NSString stringWithFormat:@"%d", (int)currentLevel];
    if(mode!=2 && mode!=3){
        _timeLabel.string = [NSString stringWithFormat:@"%d", (int)currentTime];
    }
    _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)currentScore];
    _greatestValueLabel.string = [NSString stringWithFormat:@"%d", (int)greatestPath];

    [_grid addObserver:self forKeyPath:@"time" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"theme" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"endGame" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"currentValue" options:0 context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];
    if ([keyPath isEqualToString:@"time"]) {
        if(mode != 3){
            _timeLabel.string = [NSString stringWithFormat:@"%d", (int)_grid.time];
            if(_grid.time <= 3){
                _timeLabel.color = [CCColor yellowColor];
                if (_grid.time <= 2){
                    _timeLabel.color = [CCColor orangeColor];
                    if(_grid.time <= 1) {
                        _timeLabel.color = [CCColor redColor];
                    }
                }
            }
        }
    }
    if ([keyPath isEqualToString:@"endGame"]) {
        _timeLabel.opacity = 0;
        _timetLabel.opacity = 0;
        _scoreLabel.opacity = 0;
        _scoretLabel.opacity = 0;
        _levelLabel.opacity = 0;
        _leveltLabel.opacity = 0;
        _greatesttValueLabel.opacity = 0;
        _greatestValueLabel.opacity = 0;
        _currentValueLabel.opacity = 0;
        _modeLabel.opacity = 0;
        
        GameOver *gameOverPopover = (GameOver *)[CCBReader load:@"GameOver"];
        gameOverPopover.positionType = CCPositionTypeNormalized;
        gameOverPopover.position = ccp(0.5, 0.5);
        gameOverPopover.zOrder = INT_MAX;
        NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3classic"];
        NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3classic"];
        NSInteger modeChanged = [[NSUserDefaults standardUserDefaults] integerForKey:@"modechanged"];

        if(modeChanged == 1){
            size = [[NSUserDefaults standardUserDefaults] integerForKey:@"previoussize"];
            mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"previousmode"];
        }
        if(size == 0){
            if(mode == 0){
                //classic
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3classic"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3classic"];
            }
            else if(mode == 1){
                //blitz
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3blitz"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3blitz"];
            }
            else if(mode == 2){
                //sudden
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3sudden"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3sudden"];
            }
            else if(mode == 3){
                //nightmare
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3nightmare"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3nightmare"];
            }
        }
        else if(size==1){
            if(mode == 0){
                //classic
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4classic"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4classic"];
            }
            else if(mode == 1){
                //blitz
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4blitz"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4blitz"];
            }
            else if(mode == 2){
                //sudden
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4sudden"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4sudden"];
            }
            else if(mode == 3){
                //nightmare
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4nightmare"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4nightmare"];
            }
        }
        else if(size == 2){
            if(mode == 0){
                //classic
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5classic"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5classic"];
            }
            else if(mode == 1){
                //blitz
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5blitz"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5blitz"];
            }
            else if(mode == 2){
                //sudden
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5sudden"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5sudden"];
            }
            else if(mode == 3){
                //nightmare
                bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5nightmare"];
                bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5nightmare"];
            }
        }
        NSInteger gameScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"gamescore"];
        NSInteger gameLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"gamelevel"];
    
        [gameOverPopover setLevel:gameLevel score:gameScore bestscore:bestScore bestlevel:bestLevel];
        [self addChild:gameOverPopover];
    }
    if ([keyPath isEqualToString:@"currentValue"]) {
        _currentValueLabel.string = [NSString stringWithFormat:@"%d", (int)_grid.currentValue];

    }
    if ([keyPath isEqualToString:@"theme"]) {
        if(_grid.theme == 0){
            _backgroundGradient.startColor = [CCColor colorWithRed:0.220 green:0.770 blue:0.780 alpha:0.0];
            _backgroundGradient.endColor = [CCColor colorWithRed:0.498 green:0.408 blue:0.571 alpha:0.0];
        }
        else if(_grid.theme == 1){
            //Day Theme
            _backgroundGradient.startColor = [CCColor grayColor];
            _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
        }
        else if(_grid.theme == 2){
            //Midnight Theme
            _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
            _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3];
        }
    }
}
- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"time"];
    [_grid removeObserver:self forKeyPath:@"theme"];
    [_grid removeObserver:self forKeyPath:@"endGame"];
    [_grid removeObserver:self forKeyPath:@"currentValue"];

}
- (void)menuButtonPressed{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"instructions"];
    CCScene *instructionScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}

@end
