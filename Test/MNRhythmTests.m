//
//  MNRhy.hmTests.m
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

#import "MNRhythmTests.h"
#import "MNStaffNoteTests.h"

@implementation MNRhythmTests

static NSUInteger _testFontSize;

- (void)start
{
    [super start];
    _testFontSize = 12;   // TODO: determine a reasonable value for this
    [self runTest:@"Rhythm Draw - slash notes" func:@selector(drawBasic:) frame:CGRectMake(10, 10, 700, 150)];
    [self runTest:@"Rhythm Draw - beamed slash notes"
             func:@selector(drawBeamedSlashNotes:)
            frame:CGRectMake(10, 10, 700, 150)];
    [self runTest:@"Rhythm Draw - beamed slash notes, some rests"
             func:@selector(drawSlashAndBeamAndRests:)
            frame:CGRectMake(10, 10, 700, 150)];
    [self runTest:@"Rhythm Draw - 16th note rhythm with scratches"
             func:@selector(drawSixteenthWithScratches:)
            frame:CGRectMake(10, 10, 700, 150)];
    [self runTest:@"Rhythm Draw - 32nd note rhythm with scratches"
             func:@selector(drawThirtySecondWithScratches:)
            frame:CGRectMake(10, 10, 700, 200)];
}

- (void)tearDown
{
    [super tearDown];
}

// TODO: "drawSlash:" not being tested
- (MNTestBlockStruct*)drawSlash:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];
      [staff draw:ctx];

      NSArray* notes = @[
          @{ @"keys" : @[ @"b/4" ],
             @"duration" : @"ws",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"b/4" ],
             @"duration" : @"hs",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"b/4" ],
             @"duration" : @"qs",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"b/4" ],
             @"duration" : @"8s",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"b/4" ],
             @"duration" : @"16s",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"b/4" ],
             @"duration" : @"32s",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"b/4" ],
             @"duration" : @"64s",
             @"stem_direction" : @(-1) },
      ];

      expect(@"%tu", notes.count * 2);

      [notes oct_foreach:^(NSDictionary* note, NSUInteger i, BOOL* stop) {

        MNStaffNote* staffNote = [[self class] showNote:note onStaff:staff withContext:ctx atX:(((float)i) + 1.f) * 25];

        BOOL success = staffNote.x > 0;
        NSString* message = [NSString stringWithFormat:@"Note %tu has X value", i];
        ok(success, message);
        success = staffNote.ys.count > 0;
        message = [NSString stringWithFormat:@"Note %tu has Y values", i];
        ok(success, message);
      }];
    };
    return ret;
}

- (MNTestBlockStruct*)drawBasic:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 10, 150, 0)];
      [staffBar1 setBegBarType:MNBarLineDouble];
      [staffBar1 setEndBarType:MNBarLineSingle];
      [staffBar1 addClefWithName:@"treble"];
      [staffBar1 addTimeSignatureWithName:@"4/4"];
      [staffBar1 addKeySignature:@"C"];
      [staffBar1 draw:ctx];

      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"1s",
              @"stem_direction" : @(-1)
          }]
      ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      // bar 2 - juxtaposing second bar next to first bar
      MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 120, 0)];
      [staffBar2 setBegBarType:MNBarLineSingle];
      [staffBar2 setEndBarType:MNBarLineSingle];
      [staffBar2 draw:ctx];

      // bar 2
      NSArray* notesBar2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"2s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"2s",
              @"stem_direction" : @(-1)
          }]
      ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];

      // bar 3 - juxtaposing second bar next to first bar
      MNStaff* staffBar3 = [MNStaff staffWithRect:CGRectMake(staffBar2.width + staffBar2.x, staffBar2.y, 170, 0)];
      [staffBar3 draw:ctx];

      // bar 3
      NSArray* notesBar3 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"4s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"4s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"4s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"4s",
              @"stem_direction" : @(-1)
          }],
      ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar3 withNotes:notesBar3];

      // bar 4 - juxtaposing second bar next to first bar
      MNStaff* staffBar4 = [MNStaff staffWithRect:CGRectMake(staffBar3.width + staffBar3.x, staffBar3.y, 200, 0)];
      [staffBar4 draw:ctx];

      // bar 4
      NSArray* notesBar4 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],

      ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar4 withNotes:notesBar4];
      expect(@"%d ", 0);
    };
    return ret;
}

- (MNTestBlockStruct*)drawBeamedSlashNotes:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 300, 0)];
      [staffBar1 setBegBarType:MNBarLineDouble];
      [staffBar1 setEndBarType:MNBarLineSingle];
      [staffBar1 addClefWithName:@"treble"];
      [staffBar1 addTimeSignatureWithName:@"4/4"];
      [staffBar1 addKeySignature:@"C"];
      [staffBar1 draw:ctx];

      // bar 4
      NSArray* notesBar1_part1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }]
      ];

      NSArray* notesBar1_part2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],

      ];

      // create the beams for 8th notes in 2nd measure
      MNBeam* beam1 = [[MNBeam alloc] initWithNotes:notesBar1_part1];
      MNBeam* beam2 = [[MNBeam alloc] initWithNotes:notesBar1_part2];
      NSArray* notesBar1 = [notesBar1_part1 arrayByAddingObjectsFromArray:notesBar1_part2];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      // Render beams
      [beam1 draw:ctx];
      [beam2 draw:ctx];

      expect(@"%d ", 0);
    };
    return ret;
}

- (MNTestBlockStruct*)drawSlashAndBeamAndRests:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 300, 0)];
      [staffBar1 setBegBarType:MNBarLineDouble];
      [staffBar1 setEndBarType:MNBarLineSingle];
      [staffBar1 addClefWithName:@"treble"];
      [staffBar1 addTimeSignatureWithName:@"4/4"];
      [staffBar1 addKeySignature:@"F"];
      [staffBar1 draw:ctx];

      // bar 1
      NSArray* notesBar1_part1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }]
      ];

      [notesBar1_part1[0]
          addModifier:[[MNAnnotation annotationWithText:@"C7"] setFontName:@"Times" withSize:_testFontSize + 2]
              atIndex:0];

      NSArray* notesBar1_part2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8r",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8r",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8r",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"8s",
              @"stem_direction" : @(-1)
          }]

      ];

      // create the beams for 8th notes in 2nd measure
      MNBeam* beam1 = [[MNBeam alloc] initWithNotes:notesBar1_part1];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staffBar1
                                  withNotes:[notesBar1_part1 arrayByAddingObjectsFromArray:notesBar1_part2]];

      // Render beams
      [beam1 draw:ctx];

      // bar 2 - juxtaposing second bar next to first bar
      MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 220, 0)];
      [staffBar2 draw:ctx];

      NSArray* notesBar2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"1s",
              @"stem_direction" : @(-1)
          }]
      ];

      [notesBar2[0] addModifier:[[MNAnnotation annotationWithText:@"F"] setFontName:@"Times" withSize:_testFontSize + 2]
                        atIndex:0];
      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];

      expect(@"%d ", 0);
    };
    return ret;
}

- (MNTestBlockStruct*)drawSixteenthWithScratches:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 300, 0)];
      [staffBar1 setBegBarType:MNBarLineDouble];
      [staffBar1 setEndBarType:MNBarLineSingle];
      [staffBar1 addClefWithName:@"treble"];
      [staffBar1 addTimeSignatureWithName:@"4/4"];
      [staffBar1 addKeySignature:@"F"];
      [staffBar1 draw:ctx];

      // bar 1
      NSArray* notesBar1_part1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16m",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16s",
              @"stem_direction" : @(-1)
          }]
      ];

      NSArray* notesBar1_part2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16m",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16s",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16r",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16s",
              @"stem_direction" : @(-1)
          }]

      ];

      [notesBar1_part1[0]
          addModifier:[[MNAnnotation annotationWithText:@"C7"] setFontName:@"Times" withSize:_testFontSize + 3]
              atIndex:0];

      // create the beams for 8th notes in 2nd measure
      MNBeam* beam1 = [[MNBeam alloc] initWithNotes:notesBar1_part1];
      MNBeam* beam2 = [[MNBeam alloc] initWithNotes:notesBar1_part2];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staffBar1
                                  withNotes:[notesBar1_part1 arrayByAddingObjectsFromArray:notesBar1_part2]];

      // Render beams
      [beam1 draw:ctx];
      [beam2 draw:ctx];

      expect(@"%d ", 0);
    };
    return ret;
}

- (MNTestBlockStruct*)drawThirtySecondWithScratches:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // bar 1
    MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 80, 300, 0)];
    [staffBar1 setBegBarType:MNBarLineDouble];
    [staffBar1 setEndBarType:MNBarLineSingle];
    [staffBar1 addClefWithName:@"treble"];
    [staffBar1 addTimeSignatureWithName:@"4/4"];
    [staffBar1 addKeySignature:@"F"];

    // bar 1
    NSArray* notesBar1_part1 = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32s",
            @"stem_direction" : @(1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32s",
            @"stem_direction" : @(1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32m",
            @"stem_direction" : @(1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32s",
            @"stem_direction" : @(1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32m",
            @"stem_direction" : @(1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32s",
            @"stem_direction" : @(1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32r",
            @"stem_direction" : @(1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"32s",
            @"stem_direction" : @(1)
        }]

    ];

    [notesBar1_part1[0]
        addModifier:[[MNAnnotation annotationWithText:@"C7"] setFontName:@"Verdana" withSize:_testFontSize + 3]
            atIndex:0];
    // create the beams for 8th notes in 2nd measure
    MNBeam* beam1 = [[MNBeam alloc] initWithNotes:notesBar1_part1];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staffBar1 draw:ctx];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1_part1];

      // Render beams
      [beam1 draw:ctx];

      expect(@"%d ", 0);
    };
    return ret;
}

@end
