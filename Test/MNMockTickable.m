//
//  MNMocks.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MNMockTickable.h"

@implementation MockTickable

@synthesize width = _width;
@synthesize x = _x;
@synthesize centerAlign = _centerAlign;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _ignore_ticks = NO;
    }
    return self;
}

- (instancetype)initWithTimeType:(MNTimeType)timeType
{
    self = [super init];
    if(self)
    {
        //         MNLogNotYetImlemented();
        //        abort();
    }
    return self;
}

+ (MockTickable*)mockTickableWithTimeType:(MNTimeType)timeType
{
    return [[MockTickable alloc] initWithTimeType:timeType];
}

- (float)getX
{
    return self.tickContext.x;
}

- (MNRational*)getIntrinsicTicks
{
    return _ticks;
}

- (MNRational*)getTicks
{
    return _ticks;
}

- (id)setTicks:(MNRational*)ticks
{
    _ticks = ticks;
    return self;
}

- (BOOL)getIgnoreTicks
{
    return _ignore_ticks;
}

- (id)setIgnoreTicks:(BOOL)ignoreTicks
{
    _ignore_ticks = ignoreTicks;
    return self;
}

- (MNTickableMetrics*)metrics
{
    MNTickableMetrics* ret = [[MNTickableMetrics alloc] init];
    ret.width = self.width;
    ret.noteWidth = self.width;
    ret.modLeftPx = 0;
    ret.modRightPx = 0;
    ret.extraLeftPx = 0;
    ret.extraRightPx = 0;
    return ret;
}

- (void)setVoice:(MNVoice*)v
{
    _voice = v;
}

- (void)setstaff:(MNStaff*)staff
{
    _staff = staff;
}

- (void)setTickContext:(MNTickContext*)tc
{
    _tickContext = tc;
}

- (BOOL)shouldIgnoreTicks
{
    return _ignore_ticks;
}

- (BOOL)preFormat
{
    return YES;
}

- (MockTickable*)setCustomTicks:(MNRational*)t
{
    MNLogNotYetImlemented();
    abort();
}

- (float)getWidth
{
    return _width;
}

- (id)setWidth:(float)w
{
    _width = w;
    return self;
}

- (id)setXShift:(float)xShift
{
    MNLogNotYetImlemented();
    abort();
}

- (float)xShift
{
    MNLogNotYetImlemented();
    abort();
}

- (MockTickable*)setCustomWidth:(float)w
{
    MNLogNotYetImlemented();
    abort();
}

- (MNRational*)ticks
{
    return _ticks;
}

- (void)addToModifierContext:(MNModifierContext*)mc
{
    MNLogNotYetImlemented();
    abort();
}

- (id)addModifier:(MNModifier*)modifier
{
    MNLogNotYetImlemented();
    abort();
}

- (BOOL)postFormat
{
    MNLogNotYetImlemented();
    abort();
}

- (void)applyTickMultiplier:(NSUInteger)numerator denominator:(NSUInteger)denominator
{
    MNLogNotYetImlemented();
    abort();
}

- (void)setTickDuration:(MNRational*)duration
{
    MNLogNotYetImlemented();
    abort();
}

@end
