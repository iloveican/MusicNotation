//
//  MNStemmableNote.h
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

#import "MNNote.h"
#import "MNEnum.h"
#import "MNRenderOptions.h"

@class MNStem, MNBeam, MNExtentStruct, MNTableGlyphStruct;

/*!
 *  The `MNStemmableNote`  is an abstract interface for notes with optional stems.
 *  Examples of stemmable notes are `MNStaffNote` and `MNTabNote` and `ghostnote`
 */
@interface MNStemmableNote : MNNote
{
   @private
    // NSDictionary* _stemMinimumLengthsDictionary;

   @protected
    __weak MNBeam* _beam;
    MNStemDirectionType _stemDirection;
    MNStem* _stem;
    float _stem_extension_override;
}

#pragma mark - Properties
@property (assign, nonatomic) BOOL hasStem;
@property (assign, nonatomic) BOOL drawStem;
//@property (weak, nonatomic) MNBeam* beam;
@property (assign, nonatomic) float stem_extension_override;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

/*!
 *  gets the stem
 *  @return stem
 */
- (MNStem*)stem;

/*!
 *  sets the stem
 *  @param stem the stem of this note
 *  @return this object
 */
- (id)setStem:(MNStem*)stem;

/*!
 *  Builds and sets a new stem
 */
- (void)buildStem;

/*!
 *  Get the full length of stem
 *  @return length of stem in pixels
 */
- (float)stemLength;

/*!
 *  Get the count of beams for this duration
 *  @return number of beams
 */
- (NSUInteger)beamCount;

/*!
 *  Get the minimum length of stem
 *  @return length in pixels
 */
- (float)stemMinLength;

/*!
 *  Get the direction of the stem
 *  @return +1 is up -1 is down 0 is undecided
 */
- (MNStemDirectionType)stemDirection;

/*!
 *  Set the direction of the stem
 *  @param stemDirection +1 is up -1 is down 0 is undecided
 */
- (void)setStemDirection:(MNStemDirectionType)stemDirection;

/*!
 *  Get the `x` coordinate of the stem
 *  @return x pixel coord
 */
- (float)stemX;

/*!
 *  Get the `x` coordinate for the center of the glyph.
 *  Used for `MNTabNote` stems and stemlets over rests
 *  @return the center of the x coordinate glyph in global pixels
 */
- (float)centerGlyphX;

/*!
 *  Get the stem extension for the current duration
 *  @return extension of stem in pixels
 */
- (float)stemExtension;

/*!
 *  Set the stem length to a specific. Will override the default length.
 *  @param height stem height in pixels
 */
- (void)setStemLength:(float)height;

/*!
 *  Get the top and bottom `y` values of the stem.
 *  @return pixels struct
 */
- (MNExtentStruct*)stemExtents;

/*!
 *  Sets the current note's beam
 *  @param beam the beam for this note
 *  @return this object
 */
- (id)setBeam:(MNBeam*)beam;
- (MNBeam*)beam;

/*!
 *  Get the `y` value for the top modifiers at a specific `text_line`
 *  @param textLine line number on staff for text
 *  @return y position on canvas
 */
- (float)getYForTopTextWithLine:(float)textLine;

/*!
 *  Get the `y` value for the bottom modifiers at a specific `text_line`
 *  @param textLine line number on staff for text
 *  @return y position on canvas
 */
- (float)yForBottomText:(float)textLine;

/*!
 *  Render the stem onto the canvas
 *  @param ctx  the core graphics opaque type drawing environment
 *  @param stem stem object to draw
 */
- (void)drawStem:(CGContextRef)ctx withStem:(MNStem*)stem;

@end
