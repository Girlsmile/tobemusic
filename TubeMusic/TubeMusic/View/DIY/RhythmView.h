//
//  RhythmView.h
//  SoundCloud
//
//  Created by Tracy on 15/4/15.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RhythmView : UIView

@property (nonatomic, strong) UIColor *lineTintColor;
@property (nonatomic) float lineSpacing;
@property (nonatomic) float defaultLineHeight;

- (id)initWithNumberOfLines:(int)number;
- (void)startAnimating;
- (void)stopAnimating;

@end
