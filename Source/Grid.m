//
//  Grid.m
//  2048Tutorial
//
//  Created by Elliot Catalano on 10/17/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import "Grid.h"
#import "Tile.h"
#import "GameOver.h"

@implementation Grid{
    CGFloat _columnWidth;
    CGFloat _columnHeight;
    CGFloat _tileMarginVertical;
    CGFloat _tileMarginHorizontal;
    NSMutableArray *_gridArray;
    NSMutableArray *_fixedArray;
    NSNull *_noTile;
    int _largestPath;
}

static const NSInteger GRID_SIZE = 5;
static const NSInteger START_TILES = 25;
static const NSInteger LINE_SIZE = 5;
static const NSInteger TIME_LIMIT = 15;

int selectedTileSize = 0;
int totalValue = 0;
int lastX = -1;
int lastY = -1;

- (void)onPan:(UIPanGestureRecognizer *) pan {
    CGPoint location = [pan locationInView:[pan view]];
    CGPoint fixedLocation = location;
    location.x = location.x - 10;
    location.y = location.y - 140;
    fixedLocation.x = fixedLocation.x - 10;
    fixedLocation.y = [self mirrorY:fixedLocation.y];

    for(int i = 0; i < GRID_SIZE; i++){
        for(int j = 0; j < GRID_SIZE; j++){
            int fixedJ = [self mirrorTile:j];
            Tile *tile = _fixedArray[i][j];
            Tile *newTile = _gridArray [i][fixedJ];

            
            if(CGRectContainsPoint([tile boundingBox], location)){
                    if(newTile.isSelected==false && selectedTileSize < LINE_SIZE){
                        //if the next tile is adjacent to last tile, continue the "snake"
                        if([self isAdjacentx:lastX y:lastY x2:i y2:fixedJ]){
                            [newTile selectTile];
                            selectedTileSize++;
                            lastX = i;
                            lastY = fixedJ;
                            totalValue+=newTile.value;
                        }
                        //Start a new "snake" starting with a "Last Tile" at the first tile (i,fixedJ).
                        if(lastX == -1 && lastY == -1){
                            lastX = i;
                            lastY = fixedJ;
                            [newTile selectTile];
                            selectedTileSize++;
                            totalValue+=newTile.value;

                        }
                    }
                }
            }
        }
    // "eats" the translation if you've handled the
    // UI changes, otherwise the translation will keep accumulating
    // across multiple calls to this method
    [pan setTranslation:CGPointZero inView:[pan view]];
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        [self removeAll];
        selectedTileSize = 0;
        if(totalValue > 0){
            
            if(self.doneLoading == true && totalValue < 10){
                self.score += totalValue;
                [self gameOver];
            }
            
            if(self.endGame!=true){
                self.score += totalValue;
            }
        }
        if(totalValue > 0){
            if(self.endGame!=true){
                [self nextLevel];
            }
        }
        totalValue = 0;
        lastX = -1;
        lastY = -1;
    }
}
-(BOOL)isAdjacentx:(NSInteger)x1  y:(NSInteger)y1 x2:(NSInteger)x2 y2:(NSInteger)y2  {
    BOOL adj = false;
    if((labs(x1-x2)<=1 && labs(y1-y2)==0) || (labs(y1-y2)<=1 && labs(x1-x2)==0)){
        adj = true;
    }
    return adj;
}

-(void)removeAll{
    for(int i = 0; i < GRID_SIZE; i++){
        for(int j = 0; j < GRID_SIZE; j++){
            Tile *tile = _gridArray[i][j];
            [tile deselectTile];
        }
    }
}
-(int)mirrorTile:(int)val{
    return GRID_SIZE - (val + 1);
}
-(int)mirrorY:(int)val{
    int newVal;
    int remainder;
    if(val > 290){
        remainder = 435 - val;
        newVal = 145 + val;
    }
    else{
        remainder = val - 145;
        newVal = 435 - val;
    }
    return newVal;
}


- (CGPoint)positionForColumn:(NSInteger)column row:(NSInteger)row {
    NSInteger x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _columnWidth);
    NSInteger y = _tileMarginVertical + row * (_tileMarginVertical + _columnHeight);
    return CGPointMake(x,y);
}

- (void)spawnStartTiles {
    for (int i = 0; i < START_TILES; i++) {
        [self spawnRandomTile];
    }
}


- (void)spawnRandomTile {
    BOOL spawned = FALSE;
    while (!spawned) {
        NSInteger randomRow = arc4random() % GRID_SIZE;
        NSInteger randomColumn = arc4random() % GRID_SIZE;
        BOOL positionFree = (_gridArray[randomColumn][randomRow] == _noTile);
        if (positionFree) {
            [self addTileAtColumn:randomColumn row:randomRow];
            spawned = TRUE;
        }
    }
}

- (void)addTileAtColumn:(NSInteger)column row:(NSInteger)row{
    Tile *tile = (Tile*) [CCBReader load:@"Tile"];
    int x = column;
    int y = [self mirrorTile:row];
    
    tile.x = x;
    tile.y = y;
    _gridArray[column][row] = tile;
    _fixedArray [column][row] = tile;
    tile.scale = 0.f;
    [self addChild:tile];
    tile.position = [self positionForColumn:column row:row];

    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
    CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.2f scale:1.f];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
    [tile runAction:sequence];
}

- (void)didLoadFromCCB {
    _myTimer = [self createTimer];
    [self setupBackground];
    self.level = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"];
    self.score = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentscore"];

    _noTile = [NSNull null];
    _gridArray = [NSMutableArray array];
    _fixedArray = [NSMutableArray array];
    for (int i = 0; i < GRID_SIZE; i++) {
        _gridArray[i] = [NSMutableArray array];
        _fixedArray[i] = [NSMutableArray array];
        for (int j = 0; j < GRID_SIZE; j++) {
            _gridArray[i][j] = _noTile;
            _fixedArray[i][j] = _noTile;
        }
    }
    [self spawnStartTiles];
    
    if(self.reachableTilesFilled==false){
        [self fillReachableTiles];
        self.reachableTilesFilled = true;
    }

    
    // listen for dragging
    UIPanGestureRecognizer *panRecognizer= [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                                  action: @selector(onPan:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:panRecognizer];
    //Tile *tile = _fixedArray[0][[self mirrorTile:0]];
    //NSLog(@"Tile 0,0 value: %d" , tile.value);
}

- (void)setupBackground {
    self.time = TIME_LIMIT;

    // load one tile to read the dimensions
    CCNode *tile = [CCBReader load:@"Tile"];
    _columnWidth = tile.contentSize.width;
    _columnHeight = tile.contentSize.height;
    
    // calculate the margin by subtracting the tile sizes from the grid size
    _tileMarginHorizontal = (self.contentSize.width - (GRID_SIZE * _columnWidth)) / (GRID_SIZE+1);
    _tileMarginVertical = (self.contentSize.height - (GRID_SIZE * _columnHeight)) / (GRID_SIZE+1);
    
    // set up initial x and y positions
    float x = _tileMarginHorizontal;
    float y = _tileMarginVertical;
    
    for (int i = 0; i < GRID_SIZE; i++) {
        // iterate through each row
        x = _tileMarginHorizontal;
        
        for (int j = 0; j < GRID_SIZE; j++) {
            // iterate through each column in the current row
            CCNodeColor *backgroundTile = [CCNodeColor nodeWithColor:[CCColor clearColor]];
            backgroundTile.contentSize = CGSizeMake(_columnWidth, _columnHeight);
            backgroundTile.position = ccp(x, y);
            [self addChild:backgroundTile];
            
            x+= _columnWidth + _tileMarginHorizontal;
        }
        
        y += _columnHeight + _tileMarginVertical;
    }
    self.doneLoading = true;

}
-(void) removeGrid{
    for(int i = 0; i < GRID_SIZE; i++){
        for(int j = 0; j < GRID_SIZE; j++){
            _gridArray[i][j]= _noTile;
        }
    }
}

- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)timerTicked:(NSTimer *)timer {
    if(self.time > 0){
        self.time--;
    }
    else{
        [self gameOver];
    }
}
-(void)stopTimer{
    [_myTimer invalidate];
}
-(void)nextLevel{
    self.level++;
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.level forKey:@"currentlevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"currentscore"];
    

    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)gameOver{
    self.endGame = true;
    self.doneLoading = false;
    self.reachableTilesFilled = false;
    
    [self stopTimer];
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"currentlevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentscore"];

    
    NSInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestscore"];
    NSInteger bestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestlevel"];

    
    GameOver *gameOverPopover = (GameOver *)[CCBReader load:@"GameOver"];
    gameOverPopover.positionType = CCPositionTypeNormalized;
    gameOverPopover.position = ccp(0.5, 0.5);
    gameOverPopover.zOrder = INT_MAX;
    [gameOverPopover setLevel:self.level score:self.score bestscore:bestScore bestlevel:bestLevel];
    [self addChild:gameOverPopover];
}

-(void) fillReachableTiles{
    for(int i = 0; i < GRID_SIZE; i++){
        for(int j = 0; j < GRID_SIZE; j++){
            //might need to switch to
            Tile *tile = _gridArray[i][j];
            
            [tile addReachableTilesAtX:tile.x Y:tile.y Value:tile.value];
            //shift right-up
            [tile addReachableTilesAtX:tile.x+1 Y:tile.y-1 Value:tile.value];
            [tile addReachableTilesAtX:tile.x+2 Y:tile.y-2 Value:tile.value];
            //shift down-left
            [tile addReachableTilesAtX:tile.x-1 Y:tile.y+1 Value:tile.value];
            [tile addReachableTilesAtX:tile.x-2 Y:tile.y+2 Value:tile.value];
        }
    }
}


@end
