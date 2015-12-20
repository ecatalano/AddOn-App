#import "MainScene.h"
#import "AppDelegate.h"
#import "Grid.h"
#import "Menu.h"
#import "Instruction.h"
#import "iAdHelper.h"

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
}

- (void)didLoadFromCCB {
    [iAdHelper sharedHelper];
    [iAdHelper setBannerPosition:BOTTOM];
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    if(theme == 0){
        _backgroundGradient.startColor = [CCColor colorWithRed:0.220 green:0.770 blue:0.780 alpha:0.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.498 green:0.408 blue:0.571 alpha:0.0];
    }
    else if(theme == 1){
        //Midnight Theme
        _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3];
    }
    else if(theme == 2){
        //Day Theme
        _backgroundGradient.startColor = [CCColor grayColor];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
    }
    
    NSInteger currentTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"currenttime"];
    NSInteger currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"];
    NSInteger currentScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentscore"];
    NSInteger greatestPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"greatestpath"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"instructions"];


    _levelLabel.string = [NSString stringWithFormat:@"%d", (int)currentLevel];
    _timeLabel.string = [NSString stringWithFormat:@"%d", (int)currentTime];
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
    if ([keyPath isEqualToString:@"time"]) {
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
            //Midnight Theme
            _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
            _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3];
        }
        else if(_grid.theme == 2){
            //Day Theme
            _backgroundGradient.startColor = [CCColor grayColor];
            _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
        }
    }

}
- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"time"];
    [_grid removeObserver:self forKeyPath:@"theme"];
    [_grid removeObserver:self forKeyPath:@"endGame"];
    [_grid removeObserver:self forKeyPath:@"currentValue"];

}

- (void)infoButtonPressed{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"instructions"];
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 1"];
    CCTransition *slide = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:.2];
    [[CCDirector sharedDirector] pushScene:instructionScene];
    //NSLog(@"Instructions should launch");
}
- (void)menuButtonPressed{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"instructions"];
    CCScene *instructionScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}

@end
