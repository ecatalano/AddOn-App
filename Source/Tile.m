//
//  Tile.m
//  AddOn
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
    NSInteger maxVal = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"] + 1;
    self = [super init];
    if (self) {
        self.value = (arc4random()%(maxVal)+1);
        self.top = nil;
        self.bottom = nil;
        self.right = nil;
        self.left = nil;
        if(!self.reachableTiles){
            self.reachableTiles = [[NSMutableArray alloc] init];
        }
        self.pointSize = self.contentSizeInPoints;
    }
    return self;
}

- (void)updateValueDisplay {
    _valueLabel.string = [NSString stringWithFormat:@"%d",self.value];
}

-(void) selectTile{
    self.isSelected = true;
    NSInteger theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"theme"];
    if(theme == 0){
        _backgroundNode.color = [CCColor magentaColor];
        _backgroundNode.opacity = .3;
    }
    else if(theme == 1){
        _backgroundNode.color = [CCColor yellowColor];
        _backgroundNode.opacity = .8;
    }
    else if(theme == 2){
        _backgroundNode.color = [CCColor magentaColor];
        _backgroundNode.opacity = .3;
    }
}
-(void) deselectTile{
    self.isSelected = false;
    _backgroundNode.color = [CCColor whiteColor];
    _backgroundNode.opacity = .13;
}
- (void)didLoadFromCCB {
    [self updateValueDisplay];
}

-(BOOL)inArrayListAtTile: (Tile*)t{
    for(int i = 0; i < self.reachableTiles.count; i++){
        Tile *reachedTile = self.reachableTiles[i];
        if((reachedTile.x == t.x) && (reachedTile.y == t.y)){
            return true;
        }
    }
    return false;
}
-(void) addReachableTilesAtX:(int) x Y:(int) y Value:(int) value{
    int flag = 0;
    int gridsize = 0;
    int evenfactor = 0;
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"size"];
    if(size == 0){
        gridsize = 3;
    }
    else if(size == 1){
        gridsize = 4;
    }
    else if(size == 2){
        gridsize = 5;
    }
    //even sized grids (offset by 1)
    if(gridsize%2 == 0){
        evenfactor = -1;
    }
    for(int i = y-2; i <= y+2; i++){
        for(int j = x-2+flag+evenfactor; j <= x+2; j+=2){
            if(j >=0 && i >= 0 && i < gridsize && j < gridsize){
                Tile *tile = (Tile*) [CCBReader load:@"Tile"];
                tile.x = j;
                tile.y = i;
                tile.value = value;
                if([self inArrayListAtTile:tile] == false){
                    //ensure tile isn't too far away
                    if(abs(self.x - j) + abs(self.y - i) < gridsize){
                        [self.reachableTiles addObject:tile];
                    }
                }
            }
        }
        //add 1 to x for every other row
        if(flag == 0){
            flag = 1;
        }else{
            flag = 0;
        }
    }
}

@end
