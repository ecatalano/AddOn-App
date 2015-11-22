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
@property (nonatomic) CGSize pointSize;
@property (nonatomic) BOOL isSelected;


- (void)updateValueDisplay;
- (void)selectTile;
- (void)deselectTile;

@end
