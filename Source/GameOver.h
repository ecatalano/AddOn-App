//
//  GameOver.h
//  AddOn
//
//  Created by Elliot Catalano on 11/7/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <iAd/iAd.h>


@interface GameOver : CCNode <ADBannerViewDelegate>

- (void)setLevel:(NSInteger)level
             score:(NSInteger)score bestscore:(NSInteger)score
         bestlevel:(NSInteger)level;

@end
