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
}

- (void)didLoadFromCCB {
    NSInteger currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"];
    NSInteger currentScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentscore"];

    _levelLabel.string = [NSString stringWithFormat:@"%d", (int)currentLevel];
    _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)currentScore];

    [_grid addObserver:self forKeyPath:@"time" options:0 context:NULL];
    [_grid addObserver:self forKeyPath:@"endGame" options:0 context:NULL];


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
    }
}
- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"time"];
    [_grid removeObserver:self forKeyPath:@"endGame"];
}

@end
