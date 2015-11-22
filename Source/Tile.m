//
//  Tile.m
//  2048Tutorial
//
//  Created by Elliot Catalano on 10/17/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import "Tile.h"

@implementation Tile{
    CCLabelTTF *_valueLabel;
    CCNodeColor *_backgroundNode;
    BOOL _isSelected;
}

- (id)init {
    NSInteger maxVal = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"] + 4;
    self = [super init];
    if (self) {
        self.value = (arc4random()%(maxVal)+1);
        self.pointSize = self.contentSizeInPoints;
    }
    return self;
}

- (void)updateValueDisplay {
    _valueLabel.string = [NSString stringWithFormat:@"%d",self.value];
}

-(void) selectTile{
    self.isSelected = true;
    _backgroundNode.color = [CCColor magentaColor];
    _backgroundNode.opacity = .3;
    
}
-(void) deselectTile{
    self.isSelected = false;
    _backgroundNode.color = [CCColor whiteColor];
    _backgroundNode.opacity = .13;
}
- (void)didLoadFromCCB {
    [self updateValueDisplay];
}



@end
