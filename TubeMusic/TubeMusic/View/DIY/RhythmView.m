//
//  RhythmView.m
//  SoundCloud
//
//  Created by Tracy on 15/4/15.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

#import "RhythmView.h"

@interface RhythmLine : UIView
@property (nonatomic) float rate;
@end
@implementation RhythmLine
@end




#define kTimeInterval 0.2

@interface RhythmView () {
    int _numberOfLines;
    NSMutableArray *_lines;
    NSTimer *_timer;
}

@end

@implementation RhythmView

- (id)initWithNumberOfLines:(int)number
{
    self = [super init];
    if (self) {
        assert(number > 0);
        
        _numberOfLines = number;
        
        _lineSpacing = 5;
        _defaultLineHeight = 5;
        
        _lines = [NSMutableArray array];
        for (int i=0; i<number; i++) {
            RhythmLine *line = [[RhythmLine alloc] init];
            line.backgroundColor = [UIColor redColor];
            line.rate = 0.01;
            [_lines addObject:line];
            [self addSubview:line];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_timer == nil) {
        [self layoutAnimatedly:NO];
    }
}

- (void)layoutAnimatedly:(BOOL)animatedly
{
    float lineWidth = (self.bounds.size.width - (_lines.count-1)*_lineSpacing) / _lines.count;
    
    [UIView animateWithDuration:(animatedly?kTimeInterval:0) animations:^{
        int index = 0;
        for (RhythmLine *line in _lines) {
            float lineHeight = (_timer == nil ? _defaultLineHeight : self.bounds.size.height * line.rate);
            line.frame = CGRectMake(index*_lineSpacing + (index+1)*lineWidth,
                                    self.bounds.size.height - lineHeight,
                                    lineWidth,
                                    lineHeight);
            index++;
        }
    }];
}

#pragma mark - Private
- (void)timerHandler:(NSTimer*)timer
{
    for (RhythmLine *line in _lines) {
        line.rate = (arc4random() % 91 + 10) / 100.0;
    }
    [self layoutAnimatedly:YES];
}

#pragma mark - Public
- (void)setLineTintColor:(UIColor *)lineTintColor
{
    _lineTintColor = lineTintColor;
    for (UIView *line in _lines) {
        line.backgroundColor = lineTintColor;
    }
}

- (void)setLineSpacing:(float)lineSpacing
{
    _lineSpacing = lineSpacing;
    [self layoutAnimatedly:NO];
}

- (void)setDefaultLineHeight:(float)defaultLineHeight
{
    _defaultLineHeight = defaultLineHeight;
    [self layoutAnimatedly:NO];
}

- (void)startAnimating
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:(id)self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}

- (void)stopAnimating
{
    [_timer invalidate];
    _timer = nil;
    [self layoutAnimatedly:YES];
}

@end
