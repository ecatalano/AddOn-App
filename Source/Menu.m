//
//  Menu.m
//  AddOn
//
//  Created by Elliot Catalano on 12/19/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import "Menu.h"

@implementation Menu{
    CCButton *_themeButton;
    CCButton *_modeButton;
    CCButton *_sizeButton;
    CCLabelTTF *_themeLabel;
    CCLabelTTF *_modeLabel;
    CCLabelTTF *_sizeLabel;
    CCNodeGradient *_baseGradient;
    CCNodeGradient *_backgroundGradient;
}
-(void)didLoadFromCCB{
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];
    
    if(theme == 0){
        _themeLabel.string = @"Classic";
        _themeButton.title = @"Classic";
    }
    else if(theme == 1){
        //Day Theme
        _backgroundGradient.startColor = [CCColor grayColor];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
        
        _themeLabel.string = @"Daylight";
        _themeButton.title = @"Daylight";
    }
    else if(theme == 2){
        //Midnight Theme
        _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3];
        
        _themeLabel.string = @"Midnight";
        _themeButton.title = @"Midnight";
    }
    if(mode == 0){
        _modeLabel.string = @"Classic";
        _modeButton.title = @"Classic";
    }
    else if(mode == 1){
        _modeLabel.string = @"Blitz";
        _modeButton.title = @"Blitz";
    }
    else if(mode == 2){
        _modeLabel.string = @"Sudden Death";
        _modeButton.title = @"Sudden Death";
    }
    else if(mode == 3){
        _modeLabel.string = @"Nightmare";
        _modeButton.title = @"Nightmare";
    }
    if(size == 0){
        _sizeLabel.string = @"3x3";
        _sizeButton.title = @"3x3";
    }
    else if(size == 1){
        _sizeLabel.string = @"4x4";
        _sizeButton.title = @"4x4";
    }
    else if(size == 2){
        _sizeLabel.string = @"5x5";
        _sizeButton.title = @"5x5";
    }
}

- (void)selectTheme {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Themes"];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)classicTheme {
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    if(theme != 0){
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"theme"];
        _backgroundGradient.startColor = [CCColor colorWithRed:0.220 green:0.770 blue:0.780 alpha:0.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.498 green:0.408 blue:0.571 alpha:0.0];
        _themeLabel.string = @"Classic";
        _themeButton.title = @"Classic";
    }
}
- (void)dayTheme {
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    if(theme != 1){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"theme"];
        _backgroundGradient.startColor = [CCColor grayColor];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
        _themeLabel.string = @"Daylight";
        _themeButton.title = @"Daylight";
    }
}
- (void)nightTheme {
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    if(theme != 2){
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"theme"];
        _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
        _themeLabel.string = @"Midnight";
        _themeButton.title = @"Midnight";
    }
}
- (void)classicMode {
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];

    if(mode != 0){
        [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"previousmode"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"previoussize"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"mode"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"modechanged"];
        _modeLabel.string = @"Classic";
        _modeButton.title = @"Classic";
    }
}
- (void)blitzMode {
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];

    if(mode != 1){
        [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"previousmode"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"previoussize"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"mode"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"modechanged"];
        _modeLabel.string = @"Blitz";
        _modeButton.title = @"Blitz";
    }
}
- (void)suddenDeathMode {
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];

    if(mode != 2){
        [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"previousmode"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"previoussize"];
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"mode"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"modechanged"];
        _modeLabel.string = @"Sudden Death";
        _modeButton.title = @"Sudden Death";
    }
}
- (void)nightmareMode {
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];

    if(mode != 3){
        [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"previousmode"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"previoussize"];
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"mode"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"modechanged"];
        _modeLabel.string = @"Nightmare";
        _modeButton.title = @"Nightmare";
    }
}
- (void)fiveSize {
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];
    if(size != 2){
        [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"previousmode"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"previoussize"];
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"size"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"modechanged"];
        _sizeLabel.string = @"5x5";
        _sizeButton.title = @"5x5";
    }
}
- (void)fourSize {
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    if(size != 1){
        [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"previousmode"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"previoussize"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"size"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"modechanged"];
        _sizeLabel.string = @"4x4";
        _sizeButton.title = @"4x4";
    }
}
- (void)threeSize {
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"mode"];
    if(size != 0){
        [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"previousmode"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"previoussize"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"size"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"modechanged"];
        _sizeLabel.string = @"3x3";
        _sizeButton.title = @"3x3";
    }
}

- (void)selectMode {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Modes"];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)selectSize {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Sizes"];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)back {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)done {
    [[CCDirector sharedDirector] popScene];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"instructions"];
}
-(void)displayHighscores{
    CCScene *instructionScene = [CCBReader loadAsScene:@"Highscores"];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}

@end
