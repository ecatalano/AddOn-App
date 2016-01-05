//
//  Grid.h
//  AddOn
//
//  Created by Elliot Catalano on 10/17/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Grid : CCNodeColor

@property (nonatomic,assign) NSInteger score;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,assign) NSInteger theme;
@property (nonatomic,assign) NSInteger currentValue;
@property (nonatomic,assign) NSInteger gridSize;
@property (nonatomic,assign) NSString* device;

@property (nonatomic,assign) BOOL endGame;
@property (nonatomic,assign) BOOL doneLoading;
@property (nonatomic,assign) BOOL p5A;
@property (nonatomic,assign) BOOL p5B;
@property (nonatomic,assign) BOOL reachableTilesFilled;
@property (weak, nonatomic) NSTimer *myTimer;

@property int remainingSeconds;

-(void)stopTimer;

@end
