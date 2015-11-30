#import "MainScene.h"
#import "Grid.h"

@implementation MainScene{
    Grid *_grid;
    
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
    NSInteger currentTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"currenttime"];
    NSInteger currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"];
    NSInteger currentScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentscore"];
    NSInteger greatestPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"greatestpath"];

    _levelLabel.string = [NSString stringWithFormat:@"%d", (int)currentLevel];
    _timeLabel.string = [NSString stringWithFormat:@"%d", (int)currentTime];
    _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)currentScore];
    _greatestValueLabel.string = [NSString stringWithFormat:@"%d", (int)greatestPath];

    [_grid addObserver:self forKeyPath:@"time" options:0 context:NULL];
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
        if(_grid.time <=5){
            _timeLabel.color = [CCColor yellowColor];
            if (_grid.time <= 3){
                _timeLabel.color = [CCColor orangeColor];
                if(_grid.time <1) {
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

}
- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"time"];
    [_grid removeObserver:self forKeyPath:@"endGame"];
    [_grid removeObserver:self forKeyPath:@"currentValue"];

}

@end
