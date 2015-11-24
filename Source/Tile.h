//
//  Tile.h
//  2048Tutorial
//
//  Created by Elliot Catalano on 10/17/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tile : CCNode

@property (nonatomic, assign) int value;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic) Tile* top;
@property (nonatomic) Tile* bottom;
@property (nonatomic) Tile* left;
@property (nonatomic) Tile* right;
@property (nonatomic, strong) NSMutableArray *reachableTiles;


@property (nonatomic) CGSize pointSize;
@property (nonatomic) BOOL isSelected;

- (void)updateValueDisplay;
- (void)selectTile;
- (void)deselectTile;
- (void)addReachableTilesAtX:(int)x Y:(int)y Value:(int)value;


@end
