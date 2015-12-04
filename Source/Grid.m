//
//  Grid.m
//  AddOn
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
    int _greatestPath;
}

static const NSInteger GRID_SIZE = 5;
static const NSInteger START_TILES = 25;
static const NSInteger LINE_SIZE = 5;
static const NSInteger TIME_LIMIT = 15;

int selectedTileSize = 0;
int totalValue = 0;
int lastX = -1;
int lastY = -1;

-(void)playSound{
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    if(selectedTileSize == 1){
        [audio playEffect:@"one.caf"];
    }
    if(selectedTileSize == 2){
        [audio playEffect:@"two.caf"];
    }
    if(selectedTileSize == 3){
        [audio playEffect:@"three.caf"];
    }
    if(selectedTileSize == 4){
        [audio playEffect:@"four.caf"];
    }
    if(selectedTileSize == 5){
        [audio playEffect:@"five.caf"];
    }
}


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
                            [self playSound];
                            lastX = i;
                            lastY = fixedJ;
                            totalValue+=newTile.value;
                            self.currentValue +=newTile.value;
                        }
                        //Start a new "snake" starting with a "Last Tile" at the first tile (i,fixedJ).
                        if(lastX == -1 && lastY == -1){
                            lastX = i;
                            lastY = fixedJ;
                            [newTile selectTile];
                            selectedTileSize++;
                            [self playSound];
                            totalValue+=newTile.value;
                            self.currentValue+=newTile.value;

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
        self.currentValue = 0;
        if(totalValue > 0){
            if(self.endGame!=true){
                if(self.doneLoading == true && totalValue == _greatestPath){
                    self.score += totalValue;
                    [self nextLevel];
                }
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
    int x = row;
    int y = column;
    
    //[4][3]  x = 3, y = 4
    tile.x = x;
    tile.y = y;
    //NSLog(@"Tile at [%d][%d] x:%d, y:%d",column,row, tile.x,tile.y);
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

    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"one.caf"];
    [audio preloadEffect:@"two.caf"];
    [audio preloadEffect:@"three.caf"];
    [audio preloadEffect:@"four.caf"];
    [audio preloadEffect:@"five.caf"];
    [audio preloadEffect:@"win.caf"];
    [audio preloadEffect:@"loss.caf"];
    [audio preloadEffect:@"tick.caf"];

    
    NSInteger currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"];
    if(currentLevel == 0){
        [self stopTimer];
        [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"currenttime"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"currentlevel"];
        CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
        [[CCDirector sharedDirector] replaceScene:mainScene];
    }
    
    self.time = [[NSUserDefaults standardUserDefaults] integerForKey:@"currenttime"];
    self.score = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentscore"];
    
    _greatestPath = 0;
    [self setupBackground];

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
    
    _myTimer = [self createTimer];

    
    [self setPointers];
    
    

    for(int i = 0; i < GRID_SIZE; i++){
        for(int j = 0; j < GRID_SIZE; j++){
            
            Tile *tile = _gridArray[i][j];
            //printf("%d ", tile.value);
            
            if(tile!=nil){
                int temp = [self findGreatestPathAtTile:tile];
                if(temp > _greatestPath){
                    _greatestPath = temp;
                }
            }
            
        }
    }
    [[NSUserDefaults standardUserDefaults] setInteger:_greatestPath forKey:@"greatestpath"];
    
    UIPanGestureRecognizer *panRecognizer= [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                                  action: @selector(onPan:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:panRecognizer];
}

- (void)setupBackground {
    self.level = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentlevel"];

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
        if(self.time <=3){
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            [audio playEffect:@"tick.caf"];
            
        }
    }
    else{
        if(self.endGame!=true){
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            [self gameOver];
            [audio playEffect:@"loss.caf"];
            
        }
    }
}
-(void)stopTimer{
    [_myTimer invalidate];
    _myTimer = nil;
}
-(void)nextLevel{
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];

    [self stopTimer];
    self.level++;
    
    if(self.level > 8){
        self.time = TIME_LIMIT + 5;
    }
    else{
        self.time = TIME_LIMIT;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.time forKey:@"currenttime"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.level forKey:@"currentlevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"currentscore"];
    
    [audio playEffect:@"win.caf"];

    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)gameOver{
    [self stopTimer];
    self.endGame = true;
    self.doneLoading = false;
    self.reachableTilesFilled = false;
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"currentlevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentscore"];
    [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"currenttime"];
    
    
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
-(int) findGreatestPathAtTile:(Tile *)tile{
    int greatest = 0;
    //get coordinates that this tile can reach
    NSMutableArray *coordinates = [tile reachableTiles];
    
    //add appropriate value and pointers to each coordinate (otherwise all coordinates in ArrayList have the same value and null pointers)
    for(int i = 0; i < [coordinates count]; i++){
        Tile *tempTile = coordinates[i];
        Tile *tempTwo = _gridArray[tempTile.y][tempTile.x];
        tempTile.value = tempTwo.value;
        tempTile.left = tempTwo.left;
        tempTile.right = tempTwo.right;
        tempTile.top = tempTwo.top;
        tempTile.bottom = tempTwo.bottom;
    }
    
    //try all paths between each coordinates, return the greatest path
    for(int i = 0; i < [coordinates count]; i++){
        int pathVal = [self greatestPathBetweenTileOne:tile TileTwo:coordinates[i]];
        if(pathVal > greatest){
            greatest = pathVal;
        }
    }
    return greatest;
    
}

//find greatest path between 2 coordinates
-(int) greatestPathBetweenTileOne: (Tile *)t1 TileTwo:(Tile *) t2{
    
    //c2 can't reference any pointers
    int ret = 0;
    int p1 = 0;
    int p2 = 0;
    int p3 = 0;
    int p4 = 0;
    int p5 = 0;
    int p6 = 0;
    
    //test different starting conditions to determine patterns
    if((abs(t2.x-t1.x) == 2) && (abs(t2.y-t1.y) == 2) ){
        p1 = [self pattern1XAtTile:t1 TileTwo:t2];
        p2 = [self pattern1YAtTile:t1 TileTwo:t2];
        p3 = [self pattern2YAtTile:t1 TileTwo:t2];
        p4 = [self pattern2XAtTile:t1 TileTwo:t2];
        p5 = [self patternExceptionOneAtTile:t1 TileTwo:t2];
        p6 = [self patternExceptionTwoAtTile:t1 TileTwo:t2];
    }else if((abs(t2.x-t1.x) > 1) && (abs(t2.y-t1.y) == 1)){
        //changed >= to >
        p1 = [self pattern1XAtTile:t1 TileTwo:t2];
        p2 = [self pattern1YAtTile:t1 TileTwo:t2];
        p3 = [self pattern2YAtTile:t1 TileTwo:t2];
        p4 = [self pattern2YAtTile:t2 TileTwo:t1];
    }else if((abs(t2.x-t1.x) == 1) && (abs(t2.y-t1.y) > 1)){
        p1 = [self pattern1XAtTile:t1 TileTwo:t2];
        p2 = [self pattern1YAtTile:t1 TileTwo:t2];
        p3 = [self pattern2XAtTile:t1 TileTwo:t2];
        p4 = [self pattern2XAtTile:t2 TileTwo:t1];
    }else if((abs(t2.x-t1.x) == 0) && (abs(t2.y-t1.y) == 2)){
        p1 = [self pattern3XLeftAtTile:t1 TileTwo:t2];
        p2 = [self pattern3XRightAtTile:t1 TileTwo:t2];
        p3 = [self pattern4XLeftAtTile:t1 TileTwo:t2];
        p4 = [self pattern4XRightAtTile:t1 TileTwo:t2];
        p5 = [self pattern4XLeftAtTile:t2 TileTwo:t1];
        p6 = [self pattern4XRightAtTile:t2 TileTwo:t1];
    }else if((abs(t2.y-t1.y) == 0) && (abs(t2.x-t1.x) == 2)){
        p1 = [self pattern3YTopAtTile:t1 TileTwo:t2];
        p2 = [self pattern3YBottomAtTile:t1 TileTwo:t2];
        p3 = [self pattern4XTopAtTile:t1 TileTwo:t2];
        p4 = [self pattern4XBottomAtTile:t1 TileTwo:t2];
        p5 = [self pattern4XTopAtTile:t2 TileTwo:t1];
        p6 = [self pattern4XBottomAtTile:t2 TileTwo:t1];
    }else if((abs(t2.x-t1.x) == 1) && (abs(t2.y-t1.y) == 1)){
        p1 = [self pattern5AAtTile:t1 TileTwo:t2];
        self.p5A = false;
        p2 = [self pattern5BAtTile:t1 TileTwo:t2];
        self.p5B = false;
        p3 = [self pattern5AAtTile:t2 TileTwo:t1];
        self.p5A = false;
        p4 = [self pattern5BAtTile:t2 TileTwo:t1];
        self.p5B = false;
    }else{
        p1 = [self pattern1XAtTile:t1 TileTwo:t2];
        p2 = [self pattern1YAtTile:t1 TileTwo:t2];

    }
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:[NSNumber numberWithInt:p1]];
    [arr addObject:[NSNumber numberWithInt:p2]];
    [arr addObject:[NSNumber numberWithInt:p3]];
    [arr addObject:[NSNumber numberWithInt:p4]];
    [arr addObject:[NSNumber numberWithInt:p5]];
    [arr addObject:[NSNumber numberWithInt:p6]];
    
    for(int i = 0; i < [arr count];i++){
        int temp = [[arr objectAtIndex:i] integerValue];
        if(temp > ret){
            ret = temp;
        }
    }
    //NSLog(@"Paths between %d,%d and %d,%d are %d %d %d %d %d %d",t1.x,t1.y,t2.x,t2.y,p1,p2,p3,p4,p5,p6);
    
    return ret;
}
-(int) pattern5BAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    if(t1!=nil && t2!=nil){
        //base case
        if(t1.x == t2.x && t1.y == t2.y){
            return t2.value;
        }
        
        //moves left twice
        if((t1.x > 1)&&(t1.x - t2.x == 1) && !(_p5B)){
            _p5B = true;
            return t1.value + t1.left.value + [self pattern5BAtTile:t1.left.left TileTwo:t2];
        }
        //moves right twice
        if((t1.x < 3)&&(t1.x - t2.x == -1) && !(_p5B)){
            _p5B = true;
            return t1.value + t1.right.value + [self pattern5BAtTile:t1.right.right TileTwo:t2];
        }
    
        //align y
        if((t2.y - t1.y > 0) && (abs(t2.x - t1.x) == 1)){
            return t1.value + [self pattern5BAtTile:t1.bottom TileTwo:t2];
        }
        if((t2.y - t1.y < 0) && (abs(t2.x - t1.x) == 1)){
            return t1.value + [self pattern5BAtTile:t1.top TileTwo:t2];
        }
        //connect
        if((t1.y == t2.y) && (t2.x - t1.x == 1)){
            return t1.value + [self pattern5BAtTile:t1.right TileTwo:t2];
        }
        if((t1.y == t2.y) && (t2.x - t1.x == -1)){
            return t1.value + [self pattern5BAtTile:t1.left TileTwo:t2];
        }
    }
    //NSLog(@"PATTERN 5B NO PATH EXISTS");
    return 0;
}

-(int)pattern5AAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    if(t1!=nil && t2!=nil){
        //base case
        if(t1.x == t2.x && t1.y == t2.y){
            return t2.value;
        }
    
        //moves up twice
        if((t1.y > 1)&&(t1.y - t2.y == 1) && !(_p5A)){
            _p5A = true;
            return t1.value + t1.top.value + [self pattern5AAtTile:t1.top.top TileTwo:t2];
        }
        //moves down twice
        if((t1.y < 3)&&(t1.y - t2.y == -1) && !(_p5A)){
            _p5A = true;
            return t1.value + t1.bottom.value + [self pattern5AAtTile:t1.bottom.bottom TileTwo:t2];
        }
    
        //align x
        if((t2.x - t1.x > 0) && (abs(t2.y - t1.y) == 1)){
            return t1.value + [self pattern5AAtTile:t1.right TileTwo:t2];
        }
        if((t2.x - t1.x < 0) && (abs(t2.y - t1.y) == 1)){
            return t1.value + [self pattern5AAtTile:t1.left TileTwo:t2];
        }
        //connect
        if((t1.x == t2.x) && (t2.y - t1.y == 1)){
            return t1.value + [self pattern5AAtTile:t1.bottom TileTwo:t2];
        }
        if((t1.x == t2.x) && (t2.y - t1.y == -1)){
            return t1.value + [self pattern5AAtTile:t1.top TileTwo:t2];
        }
    }
    //NSLog(@"PATTERN 5A NO PATH EXISTS");
    return 0;
}

-(int)pattern4XBottomAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    if(t1!=nil && t2!=nil){
        //base case
        if(t1.x == t2.x && t1.y == t2.y){
            return t2.value;
        }
        //move 1
        if((t1.y < 4) && (t1.y == t2.y) && (abs(t2.x-t1.x) == 2)){
            return t1.value + [self pattern4XBottomAtTile:t1.bottom TileTwo:t2];
        }
        
        //move 2
        if((t1.x-t2.x == 2)&&(t1.y - t2.y > 0) ){
            return t1.value + [self pattern4XBottomAtTile:t1.left TileTwo:t2];
        }
        if((t1.x-t2.x == -2)&&(t1.y - t2.y > 0) ){
            return t1.value + [self pattern4XBottomAtTile:t1.right TileTwo:t2];
        }
    
        //move 3
        if((abs(t2.y-t1.y) == 1)&&(abs(t2.x-t1.x) == 1)){
            return t1.value + [self pattern4XBottomAtTile:t1.top TileTwo:t2];
        }
    
        //move 4
        if((t1.y == t2.y)&&(t1.x-t2.x == 1)){
            return t1.value + [self pattern4XBottomAtTile:t1.left TileTwo:t2];
        }
        if((t1.y == t2.y)&&(t1.x-t2.x == -1)){
            return t1.value + [self pattern4XBottomAtTile:t1.right TileTwo:t2];
        }
    }
    //NSLog(@"NO BOTTOM PATH EXISTS 4X");
    return 0;
}

-(int)pattern4XTopAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    if(t1!=nil && t2!=nil){
        //base case
        if(t1.x == t2.x && t1.y == t2.y){
            return t2.value;
        }
    
        //move 1
        if((t1.y > 0) && (t1.y == t2.y) && (abs(t2.x-t1.x) == 2)){
            return t1.value + [self pattern4XTopAtTile:t1.top TileTwo:t2];
        }
        //move 2
        if((t1.x-t2.x == 2)&&(t1.y - t2.y < 0) ){
            return t1.value + [self pattern4XTopAtTile:t1.left TileTwo:t2];
        }
        if((t1.x-t2.x == -2)&&(t1.y - t2.y < 0) ){
            return t1.value + [self pattern4XTopAtTile:t1.right TileTwo:t2];
        }
    
        //move 3
        if((abs(t2.y-t1.y) == 1)&&(abs(t2.x-t1.x) == 1)){
            return t1.value + [self pattern4XTopAtTile:t1.bottom TileTwo:t2];
        }
    
        //move 4
        if((t1.y == t2.y)&&(t1.x-t2.x == 1)){
            return t1.value + [self pattern4XTopAtTile:t1.left TileTwo:t2];
        }
        if((t1.y == t2.y)&&(t1.x-t2.x == -1)){
            return t1.value + [self pattern4XTopAtTile:t1.right TileTwo:t2];
        }
    }
    
    //NSLog(@"NO TOP PATH EXISTS 4X");
    return 0;
}

-(int)pattern4XRightAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
        
    //move 1
    if((t1.x < 4) && (t1.x == t2.x) && (abs(t2.y-t1.y) == 2)){
        return t1.value + [self pattern4XRightAtTile:t1.right TileTwo:t2];
    }
    
    //move 2
    if((t1.y-t2.y == 2)&&(t1.x - t2.x > 0) ){
        return t1.value + [self pattern4XRightAtTile:t1.top TileTwo:t2];
    }
    if((t1.y-t2.y == -2)&&(t1.x - t2.x > 0) ){
        return t1.value + [self pattern4XRightAtTile:t1.bottom TileTwo:t2];
    }
    
    //move 3
    if((abs(t2.y-t1.y) == 1)&&(abs(t2.x-t1.x) == 1)){
        return t1.value + [self pattern4XRightAtTile:t1.left TileTwo:t2];
    }
    //move 4
    if((t1.x == t2.x)&&(t1.y-t2.y == 1)){
        return t1.value + [self pattern4XRightAtTile:t1.top TileTwo:t2];
    }
    if((t1.x == t2.x)&&(t1.y-t2.y == -1)){
        return t1.value + [self pattern4XRightAtTile:t1.bottom TileTwo:t2];
    }
    //NSLog(@"NO RIGHT PATH EXISTS 4X");
    return 0;
}

-(int)pattern4XLeftAtTile:(Tile *)t1 TileTwo: (Tile *) t2{

    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
        
    //move 1
    if((t1.x > 0) && (t1.x == t2.x) && (abs(t2.y-t1.y) == 2)){
        return t1.value + [self pattern4XLeftAtTile:t1.left TileTwo:t2];
    }
    
    //move 2
    if((t1.y-t2.y == 2)&&(t1.x - t2.x < 0) ){
        return t1.value + [self pattern4XLeftAtTile:t1.top TileTwo:t2];
    }
    if((t1.y-t2.y == -2)&&(t1.x - t2.x < 0) ){
        return t1.value + [self pattern4XLeftAtTile:t1.bottom TileTwo:t2];
    }
    
    //move 3
    if((abs(t2.y-t1.y) == 1)&&(abs(t2.x-t1.x) == 1)){
        return t1.value + [self pattern4XLeftAtTile:t1.right TileTwo:t2];
    }
    //move 4
    if((t1.x == t2.x)&&(t1.y-t2.y == 1)){
        return t1.value + [self pattern4XLeftAtTile:t1.top TileTwo:t2];
    }
    if((t1.x == t2.x)&&(t1.y-t2.y == -1)){
        return t1.value + [self pattern4XLeftAtTile:t1.bottom TileTwo:t2];
    }
    //NSLog(@"NO LEFT PATH EXISTS 4X");
    
    return 0;
}

//y is aligned

-(int)pattern3YBottomAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
				
    //disalign y (top)
    if((t1.y < 4) && (t1.y == t2.y) && (abs(t2.x-t1.x) == 2)){
        return t1.value + [self pattern3YBottomAtTile:t1.bottom TileTwo:t2];
    }
    
    //align x
    if((abs(t1.y-t2.y) == 1) && (t1.x- t2.x > 0)){
        return t1.value + [self pattern3YBottomAtTile:t1.left TileTwo:t2];
    }
    if((abs(t1.y-t2.y) == 1) && (t1.x- t2.x < 0)){
        return t1.value + [self pattern3YBottomAtTile:t1.right TileTwo:t2];
    }
				
    //align y
    if((t1.x == t2.x) && (t2.y-t1.y == -1)){
        return t1.value + [self pattern3YBottomAtTile:t1.top TileTwo:t2];
    }
    //NSLog(@"NO BOTTOM PATH EXISTS 3Y");
    
    return 0;
}
//y is aligned
-(int)pattern3YTopAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
    //disalign y (top)
    if((t1.y > 0) && (t1.y == t2.y) && (abs(t2.x-t1.x) == 2)){
        return t1.value + [self pattern3YTopAtTile:t1.top TileTwo:t2];
    }
    //align x
    if((abs(t1.y-t2.y) == 1) && (t1.x- t2.x > 0)){
        return t1.value + [self pattern3YTopAtTile:t1.left TileTwo:t2];
    }
    if((abs(t1.y-t2.y) == 1) && (t1.x- t2.x < 0)){
        return t1.value + [self pattern3YTopAtTile:t1.right TileTwo:t2];
    }
    //align y
    if((t1.x == t2.x) && (t2.y-t1.y == 1)){
        return t1.value + [self pattern3YTopAtTile:t1.bottom TileTwo:t2];
    }
    //NSLog(@"NO TOP PATH EXISTS 3Y");
    
    return 0;
}

//x is aligned

-(int)pattern3XLeftAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
    //disalign x (left)
    if((t1.x > 0) && (t1.x == t2.x) && (abs(t2.y-t1.y) == 2)){
        return t1.value + [self pattern3XLeftAtTile:t1.left TileTwo:t2];
    }
    //align y
    if((abs(t1.x-t2.x) == 1) && (t1.y- t2.y > 0)){
        return t1.value + [self pattern3XLeftAtTile:t1.top TileTwo:t2];
    }
    if((abs(t1.x-t2.x) == 1) && (t1.y- t2.y < 0)){
        return t1.value + [self pattern3XLeftAtTile:t1.bottom TileTwo:t2];
    }
    //align x
    if((t1.y == t2.y) && (t2.x-t1.x == 1)){
        return t1.value + [self pattern3XLeftAtTile:t1.right TileTwo:t2];
    }
    
    //NSLog(@"NO LEFT PATH EXISTS 3X");
    
    return 0;
}
//x is aligned
-(int)pattern3XRightAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
    //disalign x (right)
    if((t1.x < 4) && (t1.x == t2.x) && (abs(t2.y-t1.y) == 2)){
        return t1.value + [self pattern3XRightAtTile:t1.right TileTwo:t2];
    }
    //align y
    if((abs(t1.x-t2.x) == 1) && (t1.y- t2.y > 0)){
        return t1.value + [self pattern3XRightAtTile:t1.top TileTwo:t2];
    }
    if((abs(t1.x-t2.x) == 1) && (t1.y- t2.y < 0)){
        return t1.value + [self pattern3XRightAtTile:t1.bottom TileTwo:t2];
    }
    //align x
    if((t1.y == t2.y) && (t2.x-t1.x == -1)){
        return t1.value + [self  pattern3XRightAtTile:t1.left TileTwo:t2];
    }
    //NSLog(@"NO RIGHT PATH EXISTS 3X");
    
    return 0;
}



//alternate between x and y alignment
-(int)pattern2YAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
    
    //if x or y is aligned then finish path directly
    if(t1.x == t2.x || t1.y == t2.y){
        return [self finishDirectIfAlignedAtTile:t1 TileTwo:t2];
    }
    
    //move in x direction first
    if(t2.x - t1.x >= 1 ){
        return t1.value + [self pattern2XAtTile:t1.right TileTwo:t2];
    }
    if(t2.x - t1.x <= -1 ){
        return t1.value + [self pattern2XAtTile:t1.left TileTwo:t2];
    }
    
    NSLog(@"SOMETHING WENT WRONG (pattern2Y)");
    
    return 0;
}

//alternate between x and y alignment
-(int)pattern2XAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
    
    //if x or y is aligned then finish path directly
    if(t1.x == t2.x || t1.y == t2.y){
        return [self finishDirectIfAlignedAtTile:t1 TileTwo:t2];
    }
    
    //move in y direction first
    if(t2.y - t1.y >= 1){
        return t1.value + [self pattern2YAtTile:t1.bottom TileTwo:t2];
    }
    if(t2.y - t1.y <= -1){
        return t1.value + [self pattern2YAtTile:t1.top TileTwo:t2];
    }
    NSLog(@"SOMETHING WENT WRONG (pattern2X)");
    
    return 0;
}




//align x, then align y
-(int)pattern1XAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //c1 changes, c2 is fixed

    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
				
    //move in horizontal direction of c2
    if(t1.x < t2.x){
        return t1.value + [self pattern1XAtTile:t1.right TileTwo:t2];
    }
    if(t1.x > t2.x){
        return t1.value + [self pattern1XAtTile:t1.left TileTwo:t2];
    }
    //move in vertical direction of c2
    if(t1.y < t2.y){
        return t1.value + [self pattern1XAtTile:t1.bottom TileTwo:t2];
    }
    if(t1.y > t2.y){
        return t1.value + [self pattern1XAtTile:t1.top TileTwo:t2];
    }
    NSLog(@"SOMETHING WENT WRONG 1X");
    
    return 0;
}

//align y, then align x
-(int)pattern1YAtTile:(Tile *)t1 TileTwo: (Tile *) t2{
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
    //move in vertical direction of c2
    if(t1.y < t2.y){
        return t1.value + [self pattern1YAtTile:t1.bottom TileTwo:t2];
    }
    if(t1.y > t2.y){
        return t1.value + [self pattern1YAtTile:t1.top TileTwo:t2];
    }
    
    //move in horizontal direction of c2
    if(t1.x < t2.x){
        return t1.value + [self pattern1YAtTile:t1.right TileTwo:t2];
    }
    if(t1.x > t2.x){
        return t1.value + [self pattern1YAtTile:t1.left TileTwo:t2];
    }
    
    NSLog(@"SOMETHING WENT WRONG 1Y");
    
    return 0;
}

-(int)patternExceptionOneAtTile:(Tile *)t1 TileTwo: (Tile *) t2{

    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }

    if( (t2.y - t1.y == 2) && (abs(t1.x - t2.x) == 2) ){
        return t1.value + [self patternExceptionOneAtTile:t1.bottom TileTwo:t2];
    }
    if((t1.y - t2.y == 2) && (abs(t1.x - t2.x) == 2)){
        return t1.value + [self patternExceptionOneAtTile:t1.top TileTwo:t2];
    }
    if((t2.x - t1.x > 0) && (abs(t1.y-t2.y) == 1)){
        return t1.value + [self patternExceptionOneAtTile:t1.right TileTwo:t2];
    }
    if((t2.x - t1.x < 0) && (abs(t1.y-t2.y) == 1)){
        return t1.value + [self patternExceptionOneAtTile:t1.left TileTwo:t2];
    }
    if((t2.y - t1.y == 1)&&(t1.x == t2.x)){
        return t1.value + [self patternExceptionOneAtTile:t1.bottom TileTwo:t2];
    }
    if((t2.y - t1.y == -1)&&(t1.x == t2.x)){
        return t1.value + [self patternExceptionOneAtTile:t1.top TileTwo:t2];
    }
    NSLog(@"SOMETHING WENT WRONG IN PATTERN_2_SINGLE");
    
    return 0;
}
- (int) patternExceptionTwoAtTile:(Tile *) t1 TileTwo:(Tile *)t2{
    
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
    
    if(abs(t2.y - t1.y) == 2 && (t1.x - t2.x == 2) ){
        return t1.value + [self patternExceptionTwoAtTile:t1.left TileTwo:t2];
    }
    if(abs(t2.y - t1.y) == 2 && (t2.x - t1.x == 2) ){
        return t1.value + [self patternExceptionTwoAtTile:t1.right TileTwo:t2];
    }
    if((t2.y - t1.y > 0) && (abs(t1.x-t2.x) == 1)){
        return t1.value + [self patternExceptionTwoAtTile:t1.bottom TileTwo:t2];
    }
    if((t2.y - t1.y < 0) && (abs(t1.x-t2.x) == 1)){
        return t1.value + [self patternExceptionTwoAtTile:t1.top TileTwo:t2];
    }
    if((t2.x - t1.x == 1)&&(t1.y == t2.y)){
        return t1.value + [self patternExceptionTwoAtTile:t1.right TileTwo:t2];
    }
    if((t2.x - t1.x == -1)&&(t1.y == t2.y)){
        return t1.value + [self patternExceptionTwoAtTile:t1.left TileTwo:t2];
    }
    
    NSLog(@"SOMETHING WENT WRONG IN PATTERN_EXCEPTION_2");
    
    return 0;
}

-(int) finishDirectIfAlignedAtTile:(Tile *)t1 TileTwo:(Tile *) t2{
    
    //base case
    if(t1.x == t2.x && t1.y == t2.y){
        return t2.value;
    }
				
    if(t1.y == t2.y && t2.x < t1.x){
        return t1.value+ [self pattern1XAtTile:t1.left TileTwo:t2];
    }
    if(t1.y == t2.y && t2.x > t1.x){
        return t1.value+ [self pattern1XAtTile:t1.right TileTwo:t2];
    }
    if(t1.x == t2.x && t2.y > t1.y){
        return t1.value+ [self pattern1YAtTile:t1.bottom TileTwo:t2];
    }
    if(t1.x == t2.x && t2.y < t1.y){
        return t1.value+ [self pattern1YAtTile:t1.top TileTwo:t2];
    }
    
    NSLog(@"SOMETHING WENT WRONG IN FINISH_ALIGN");
    
    return 0;
}

-(void)setPointers{
    Tile *zerozero = _gridArray[0][0];
    zerozero.right = _gridArray[0][1];
    zerozero.bottom = _gridArray[1][0];
    
    Tile *zeroone = _gridArray[0][1];
    zeroone.right = _gridArray[0][2];
    zeroone.bottom = _gridArray[1][1];
    zeroone.left = _gridArray[0][0];
	
    Tile *zerotwo = _gridArray[0][2];
    zerotwo.right = _gridArray[0][3];
    zerotwo.bottom = _gridArray[1][2];
    zerotwo.left = _gridArray[0][1];
	
    Tile *zerothree = _gridArray[0][3];
    zerothree.right = _gridArray[0][4];
    zerothree.bottom = _gridArray[1][3];
    zerothree.left = _gridArray[0][2];
    
    Tile *zerofour = _gridArray[0][4];
    zerofour.bottom = _gridArray[1][4];
    zerofour.left = _gridArray[0][3];
				
    //row 2
    Tile *onezero = _gridArray[1][0];
    onezero.right = _gridArray[1][1];
    onezero.bottom = _gridArray[2][0];
    onezero.top = _gridArray[0][0];
    
    Tile *oneone = _gridArray[1][1];
    oneone.right = _gridArray[1][2];
    oneone.left = _gridArray[1][0];
    oneone.bottom = _gridArray[2][1];
    oneone.top = _gridArray[0][1];
    
    Tile *onetwo = _gridArray[1][2];
    onetwo.right = _gridArray[1][3];
    onetwo.left = _gridArray[1][1];
    onetwo.bottom = _gridArray[2][2];
    onetwo.top = _gridArray[0][2];
    
    Tile *onethree = _gridArray[1][3];
    onethree.right = _gridArray[1][4];
    onethree.left = _gridArray[1][2];
    onethree.bottom = _gridArray[2][3];
    onethree.top = _gridArray[0][3];
    
    Tile *onefour = _gridArray[1][4];
    onefour.left = _gridArray[1][3];
    onefour.bottom = _gridArray[2][4];
    onefour.top = _gridArray[0][4];
				
    //row 3
    Tile *twozero = _gridArray[2][0];
    twozero.right = _gridArray[2][1];
    twozero.bottom = _gridArray[3][0];
    twozero.top = _gridArray[1][0];
    
    Tile *twoone = _gridArray[2][1];
    twoone.right = _gridArray[2][2];
    twoone.left = _gridArray[2][0];
    twoone.bottom = _gridArray[3][1];
    twoone.top = _gridArray[1][1];
			
    Tile *twotwo = _gridArray[2][2];
    twotwo.right = _gridArray[2][3];
    twotwo.left = _gridArray[2][1];
    twotwo.bottom = _gridArray[3][2];
    twotwo.top = _gridArray[1][2];
	
    Tile *twothree = _gridArray[2][3];
    twothree.right = _gridArray[2][4];
    twothree.left = _gridArray[2][2];
    twothree.bottom = _gridArray[3][3];
    twothree.top = _gridArray[1][3];
	
    Tile *twofour = _gridArray[2][4];
    twofour.left = _gridArray[2][3];
    twofour.bottom = _gridArray[3][4];
    twofour.top = _gridArray[1][4];
				
    //row 4
    Tile *threezero = _gridArray[3][0];
    threezero.right = _gridArray[3][1];
    threezero.bottom = _gridArray[4][0];
    threezero.top = _gridArray[2][0];
    
    Tile *threeone = _gridArray[3][1];
    threeone.right = _gridArray[3][2];
    threeone.left = _gridArray[3][0];
    threeone.bottom = _gridArray[4][1];
    threeone.top = _gridArray[2][1];
    
    Tile *threetwo = _gridArray[3][2];
    threetwo.right = _gridArray[3][3];
    threetwo.left = _gridArray[3][1];
    threetwo.bottom = _gridArray[4][2];
    threetwo.top = _gridArray[2][2];
    
    Tile *threethree = _gridArray[3][3];
    threethree.right = _gridArray[3][4];
    threethree.left = _gridArray[3][2];
    threethree.bottom = _gridArray[4][3];
    threethree.top = _gridArray[2][3];
    
    Tile *threefour = _gridArray[3][4];
    threefour.left = _gridArray[3][3];
    threefour.bottom = _gridArray[4][4];
    threefour.top = _gridArray[2][4];
				
    //row 5
    Tile *fourzero = _gridArray[4][0];
    fourzero.right = _gridArray[4][1];
    fourzero.top = _gridArray[3][0];
    
    Tile *fourone = _gridArray[4][1];
    fourone.right = _gridArray[4][2];
    fourone.top = _gridArray[3][1];
    fourone.left = _gridArray[4][0];
    
    Tile *fourtwo = _gridArray[4][2];
    fourtwo.right = _gridArray[4][3];
    fourtwo.top = _gridArray[3][2];
    fourtwo.left = _gridArray[4][1];
    
    Tile *fourthree = _gridArray[4][3];
    fourthree.right = _gridArray[4][4];
    fourthree.top = _gridArray[3][3];
    fourthree.left = _gridArray[4][2];
    
    Tile *fourfour = _gridArray[4][4];
    fourfour.top = _gridArray[3][4];
    fourfour.left = _gridArray[4][3];
}


@end
