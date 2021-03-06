//
//  MNTimeSignatureTests.m
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

#import "MNTimeSignatureTests.h"

@implementation MNTimeSignatureTests

- (void)start
{
    [super start];
    //    [self runTest:@"Time Signature Parser" func:@selector(parser)];
    [self runTest:@"Basic Time Signatures" func:@selector(basic:) frame:CGRectMake(10, 10, 600, 150)];
    [self runTest:@"Big Signature Test" func:@selector(big:) frame:CGRectMake(10, 10, 600, 150)];
    [self runTest:@"Time Signature multiple staffs alignment test"
             func:@selector(multiStaff:)
            frame:CGRectMake(10, 10, 600, 350)];
    [self runTest:@"Time Signature Change Test" func:@selector(timeSigNote:) frame:CGRectMake(10, 10, 900, 350)];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)catchError:(NSString*)spec
{
    /*
    Vex.Flow.Test.TimeSignature.catchError = function(ts, spec) {
        try {
            [MNTimeSignature parseTimeSpec:spec);
        } catch (e) {
            equal(e.code, "BadTimeSignature", e.message);
        }
    }
     */
    MNLogNotYetImlemented();
    abort();
}

- (void)parser
{
    expect(@"6");

    //    // Invalid time signatures
    //    [[self class] catchError:@"asdf"];
    //    [[self class] catchError:@"123/"];
    //    [[self class] catchError:@"/10"];
    //    [[self class] catchError:@"/"];
    //    [[self class] catchError:@"4567"];
    //    [[self class] catchError:@"C+"];

    //    [MNTimeSignature parseTimeSpec:@"4/4"];
    //    [MNTimeSignature parseTimeSpec:@"10/12"];
    //    [MNTimeSignature parseTimeSpec:@"1/8"];
    //    [MNTimeSignature parseTimeSpec:@"1234567890/1234567890"];
    //    [MNTimeSignature parseTimeSpec:@"C"];
    //    [MNTimeSignature parseTimeSpec:@"C|"];

    ok(YES, @"all pass");
}

- (MNTestBlockStruct*)basic:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 500, 0)];
    void (^endSpace)(float) = ^(float w) {
      [staff addEndGlyph:[staff makeSpacer:w]];
    };

    [staff addTimeSignatureWithName:@"2/2"];
    [staff addTimeSignatureWithName:@"3/4"];
    [staff addTimeSignatureWithName:@"4/4"];
    [staff addTimeSignatureWithName:@"6/8"];
    [staff addClefWithName:@"treble"];
    [staff addTimeSignatureWithName:@"C"];
    [staff addTimeSignatureWithName:@"C|"];

    float w = 6;

    [staff addEndTimeSignatureWithName:@"2/2"];
    endSpace(w);
    [staff addEndTimeSignatureWithName:@"3/4"];
    endSpace(w);
    [staff addEndTimeSignatureWithName:@"4/4"];
    endSpace(w);
    [staff addEndClefWithName:@"treble"];
    endSpace(w);
    [staff addEndTimeSignatureWithName:@"6/8"];
    endSpace(w);
    [staff addEndTimeSignatureWithName:@"C"];
    endSpace(w);
    [staff addEndTimeSignatureWithName:@"C|"];
    endSpace(w);

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)big:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 400, 0)];

      [staff addTimeSignatureWithName:@"12/8"];
      [staff addTimeSignatureWithName:@"7/16"];
      [staff addTimeSignatureWithName:@"1234567/890"];
      [staff addTimeSignatureWithName:@"987/654321"];

      [staff draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)multiStaff:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(45, 0, 300, 0)];

      for(NSUInteger i = 0; i < 5; i++)
      {
          if(i == 2)
              continue;
          [staff setConfigForLine:i withConfig:@{ @"visible" : @(NO) }];
      }

      [staff addClefWithName:@"percussion"];
      // passing the custom padding as second parameter (in pixels)
      [staff addTimeSignatureWithName:@"4/4" padding:15];
      [staff draw:ctx];

      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(45, 110, 300, 0)];
      [staff2 addClefWithName:@"treble"];
      [staff2 addTimeSignatureWithName:@"4/4"];
      [staff2 draw:ctx];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorSingle];
      [connector draw:ctx];

      MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(45, 220, 300, 0)];
      [staff3 addClefWithName:@"bass"];
      [staff3 addTimeSignatureWithName:@"4/4"];
      [staff3 draw:ctx];

      MNStaffConnector* connector2 = [MNStaffConnector staffConnectorWithTopStaff:staff2 andBottomStaff:staff3];
      [connector2 setType:MNStaffConnectorSingle];
      [connector2 draw:ctx];

      MNStaffConnector* connector3 = [MNStaffConnector staffConnectorWithTopStaff:staff2 andBottomStaff:staff3];
      [connector3 setType:MNStaffConnectorBrace];
      [connector3 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)timeSigNote:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 800, 0)];

    NSArray* notes = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4" ],
            @"duration" : @"q",
            @"clefName" : @"treble"
        }],

        [MNTimeSigNote timeSigNoteWithTimeType:MNTime3_4],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"d/4" ],
            @"duration" : @"q",
            @"clefName" : @"alto"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"b/3" ],
            @"duration" : @"qr",
            @"clefName" : @"alto"
        }],

        [MNTimeSigNote timeSigNoteWithTimeType:MNTimeC],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/3", @"e/3", @"g/3" ],
            @"duration" : @"q",
            @"clefName" : @"bass"
        }],

        [MNTimeSigNote timeSigNoteWithTimeType:MNTime9_8],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4" ],
            @"duration" : @"q",
            @"clefName" : @"treble"
        }]
    ];

    MNVoice* voice = [MNVoice voiceWithNumBeats:4 beatValue:4 resolution:kRESOLUTION];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:500];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [[[staff addClefWithName:@"treble"] addTimeSignatureWithName:@"C|"] draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      ok(YES, @"all pass");
    };
    return ret;
}

@end
