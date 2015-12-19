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
        //Midnight Theme
        _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3];
        
        _themeLabel.string = @"Midnight";
        _themeButton.title = @"Midnight";
    }
    else if(theme == 2){
        //Day Theme
        _backgroundGradient.startColor = [CCColor grayColor];
        _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
        
        _themeLabel.string = @"Day";
        _themeButton.title = @"Day";

    }
}

- (void)selectTheme {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Themes"];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)classicTheme {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"theme"];
    _backgroundGradient.startColor = [CCColor colorWithRed:0.220 green:0.770 blue:0.780 alpha:0.0];
    _backgroundGradient.endColor = [CCColor colorWithRed:0.498 green:0.408 blue:0.571 alpha:0.0];
    _themeLabel.string = @"Classic";
    _themeButton.title = @"Classic";
}
- (void)nightTheme {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"theme"];
    _backgroundGradient.startColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _backgroundGradient.endColor = [CCColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
    _themeLabel.string = @"Midnight";
    _themeButton.title = @"Midnight";
}
- (void)dayTheme {
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"theme"];
    _backgroundGradient.startColor = [CCColor grayColor];
    _backgroundGradient.endColor = [CCColor colorWithRed:0.100 green:0.370 blue:0.780 alpha:1.0];
    _themeLabel.string = @"Day";
    _themeButton.title = @"Day";
}
- (void)selectMode {
    //CCScene *instructionScene = [CCBReader loadAsScene:@"Modes"];
    //[[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)selectSize {
    //CCScene *instructionScene = [CCBReader loadAsScene:@"Sizes"];
    //[[CCDirector sharedDirector] pushScene:instructionScene];
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

@end
