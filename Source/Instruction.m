//
//  Instruction.m
//  AddOn
//
//  Created by Elliot Catalano on 12/4/15.
//  Copyright © 2015 Elliot Catalano. All rights reserved.
//

#import "Instruction.h"

@implementation Instruction

- (void)next1 {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 2"];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)next2 {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 3"];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)next3 {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 4"];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)next4 {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 5"];
    [[CCDirector sharedDirector] pushScene:instructionScene];
}
- (void)prev {
    [[CCDirector sharedDirector] popScene];
}
- (void)done {
    for(int i = 0; i < 5; i++){
        [[CCDirector sharedDirector] popScene];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"instructions"];
}

@end
