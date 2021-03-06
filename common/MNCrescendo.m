//
//  MNCrescendo.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNCrescendo.h"
#import "MNUtils.h"
#import "MNBezierPath.h"
#import "MNTickContext.h"
#import "MNNote.h"
#import "MNStaff.h"

@implementation MNCrescendo

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        _decrescendo = NO;
        _height = 15;   // The height at the open end of the cresc/decresc

        // Extensions to the length of the crescendo on either side
        //        self.extend_left = 0;
        //        self.extend_right = 0;
        //        self.y_shift = 0; // Vertical shift

        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  Set the full height at the open end
 *  @param height open end height
 *  @return this object
 */
- (id)setHeight:(float)height
{
    _height = height;
    return self;
}

/*!
 *  Should be a crescendo or decrescendo
 *  @param decres YES is decrescendo, NO is crescendo
 *  @return this object
 */
- (id)setDescrescendo:(BOOL)decres
{
    _decrescendo = decres;
    return self;
}

- (BOOL)preFormat
{
    self.preFormatted = YES;
    return YES;
}

/*!
 *  Draw the hairpin
 *  @param ctx the core graphics opaque type drawing environment
 *  @param beginX  left x position
 *  @param endX    right x position
 *  @param y       center height
 *  @param height  opening height
 *  @param reverse left or right
 */
+ (void)renderHairpin:(CGContextRef)ctx
               beginX:(float)beginX
                 endX:(float)endX
                  atY:(float)y
           withHeight:(float)height
              reverse:(BOOL)reverse
{
    float begin_x = beginX;
    float end_x = endX;
    float half_height = height / 2;

    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    if(reverse)
    {
        CGContextMoveToPoint(ctx, begin_x, y - half_height);
        CGContextAddLineToPoint(ctx, end_x, y);
        CGContextAddLineToPoint(ctx, begin_x, y + half_height);
    }
    else
    {
        CGContextMoveToPoint(ctx, end_x, y - half_height);
        CGContextAddLineToPoint(ctx, begin_x, y);
        CGContextAddLineToPoint(ctx, end_x, y + half_height);
    }
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
}

/*!
 *  Render the Crescendo object onto the canvas
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    MNTickContext* tick_context = self.tickContext;
    MNTickContext* next_context = [MNTickContext getNextContext:tick_context];
    float begin_x = self.absoluteX;
    float end_x;
    if(next_context != nil)
    {
        end_x = next_context.x;
    }
    else
    {
        end_x = self.staff.x + self.staff.width;
    }

    float y = [self.staff getYForLine:(_line + (-3)) + 1];

    NSString* type = _decrescendo ? @"decrescendo " : @"crescendo ";
    MNLogDebug(@"%@", [NSString stringWithFormat:@"Drawing %@ %f %@ %f", type, _height, @"x", begin_x - end_x]);

    [[self class] renderHairpin:ctx beginX:begin_x endX:end_x atY:y withHeight:_height reverse:_decrescendo];
}
@end
