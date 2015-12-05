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
    CCTransition *slide = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft duration:.2];
    [[CCDirector sharedDirector] pushScene:instructionScene withTransition:slide];
}
- (void)next2 {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 3"];
    CCTransition *slide = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft duration:.2];
    [[CCDirector sharedDirector] pushScene:instructionScene withTransition:slide];
}
- (void)next3 {
    CCScene *instructionScene = [CCBReader loadAsScene:@"Instruction 4"];
    CCTransition *slide = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft duration:.2];
    [[CCDirector sharedDirector] pushScene:instructionScene withTransition:slide];
}
- (void)prev {
    CCTransition *slide = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionRight duration:.2];
    [[CCDirector sharedDirector] popSceneWithTransition:slide];
}
- (void)done {
    [[CCDirector sharedDirector] popToRootSceneWithTransition:CCTransitionDirectionUp];

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"instructions"];
}

@end
