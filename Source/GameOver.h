//
//  GameOver.h
//  2048Tutorial
//
//  Created by Elliot Catalano on 11/7/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameOver : CCNode

- (void)setLevel:(NSInteger)level
             score:(NSInteger)score bestscore:(NSInteger)score
         bestlevel:(NSInteger)level;


@end
