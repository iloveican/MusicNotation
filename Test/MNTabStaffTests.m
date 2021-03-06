//
//  MNTabStaffTests.m
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

#import "MNTabStaffTests.h"

@implementation MNTabStaffTests

- (void)start
{
    [super start];
    [self runTest:@"TabStaff Draw Test" func:@selector(draw:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Vertical Bar Test" func:@selector(drawVerticalBar:) frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}


- (MNTestBlockStruct*)draw:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    /*
    Vex.Flow.Test.TabStaff.draw = function(options, contextBuilder) {
        var ctx = new contextBuilder(options.canvas_sel,
                                     400, 160);

         MNStaff *staff = new Vex.Flow.TabStaff(10, 10, 300);
        staff.setNumLines(6);

        [staff draw:ctx];

        equal(staff.getYForNote(0), 127, "getYForNote(0)");
        equal(staff.getYForLine(5), 126, "getYForLine(5)");
        equal(staff.getYForLine(0), 61, "getYForLine(0) - Top Line");
        equal(staff.getYForLine(4), 113, "getYForLine(4) - Bottom Line");

        ok(YES, @"all pass");
    }
     */

    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 10, 300, 0)];
    staff.numberOfLines = 6;

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      ok(YES, @"all pass");

    };

    return ret;
}

- (MNTestBlockStruct*)drawVerticalBar:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 10, 300, 0)];
    staff.numberOfLines = 6;

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff drawVerticalBar:ctx x:50];
      [staff drawVerticalBar:ctx x:100];
      [staff drawVerticalBar:ctx x:150];

      [staff setEndBarType:MNBarLineEnd];

      [staff draw:ctx];

      ok(YES, @"all pass");
    };

    return ret;
}

@end
