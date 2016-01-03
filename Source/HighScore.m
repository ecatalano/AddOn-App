//
//  HighScore.m
//  AddOn
//
//  Created by Elliot Catalano on 1/2/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import "HighScore.h"

@implementation HighScore
{
    CCLabelTTF *_bestscoreLabel;
    CCLabelTTF *_bestlevelLabel;
    CCButton *_modeButton;
    CCButton *_sizeButton;
    CCNodeGradient *_baseGradient;
    CCNodeGradient *_backgroundGradient;
}


-(void)didLoadFromCCB{
    [self updateDisplay];
}
-(void)updateDisplay{
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3classic"];
    NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3classic"];
    NSInteger selectedMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedmode"];
    NSInteger selectedSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedsize"];
    if(selectedMode == 0){
        if(selectedSize == 0){
            //3x3
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3classic"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3classic"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"3x3";
            _modeButton.title = @"Classic";
        }
        else if(selectedSize == 1){
            //4x4
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4classic"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4classic"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"4x4";
            _modeButton.title = @"Classic";
        }
        else if(selectedSize == 2){
            //5x5
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5classic"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5classic"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"5x5";
            _modeButton.title = @"Classic";
        }
    }
    else if(selectedMode == 1){
        if(selectedSize == 0){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3blitz"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3blitz"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"3x3";
            _modeButton.title = @"Blitz";
        }
        else if(selectedSize == 1){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4blitz"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4blitz"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"4x4";
            _modeButton.title = @"Blitz";
        }
        else if(selectedSize == 2){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5blitz"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5blitz"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"5x5";
            _modeButton.title = @"Blitz";
        }
    }
    else if(selectedMode == 2){
        if(selectedSize == 0){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3sudden"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3sudden"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"3x3";
            _modeButton.title = @"Sudden Death";
        }
        else if(selectedSize == 1){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4sudden"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4sudden"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"4x4";
            _modeButton.title = @"Sudden Death";
        }
        else if(selectedSize == 2){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5sudden"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5sudden"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"5x5";
            _modeButton.title = @"Sudden Death";
        }
    }
    else if(selectedMode == 3){
        if(selectedSize == 0){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore3nightmare"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel3nightmare"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"3x3";
            _modeButton.title = @"Nightmare";
        }
        else if(selectedSize == 1){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore4nightmare"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel4nightmare"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"4x4";
            _modeButton.title = @"Nightmare";

        }
        else if(selectedSize == 2){
            bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore5nightmare"];
            bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel5nightmare"];
            _bestscoreLabel.string = [NSString stringWithFormat:@"%d", (int)bestScore];
            _bestlevelLabel.string = [NSString stringWithFormat:@"%d", (int)bestLevel];
            _sizeButton.title = @"5x5";
            _modeButton.title = @"Nightmare";
        }
    }

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
}
-(void)sizeButtonPressed{
    NSInteger selectedSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedsize"];
    if(selectedSize < 2){
        selectedSize+=1;
    }
    else if(selectedSize == 2){
        selectedSize = 0;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:selectedSize forKey:@"selectedsize"];
    [self updateDisplay];
}
-(void)modeButtonPressed{
    NSInteger selectedMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedmode"];
    if(selectedMode < 3){
        selectedMode+=1;
    }
    else if(selectedMode == 3){
        selectedMode = 0;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:selectedMode forKey:@"selectedmode"];
    [self updateDisplay];
}
- (void)back {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}


@end
