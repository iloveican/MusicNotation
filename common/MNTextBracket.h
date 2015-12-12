//
//  MNTextBracket.h
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

#import "MNModifier.h"

@class MNFont, MNStaffNote;

/*!
 *  The `MNTextBracket` class implement `TextBrackets` which extend between two notes.
 *  The octave transposition markings (8va, 8vb, 15va, 15vb) can be created
 *  using this class.
 */
@interface MNTextBracket : MNModifier
{
   @private
    BOOL _dashed;
}
#pragma mark - Properties

//@property (assign, nonatomic) BOOL dashed;
@property (assign, nonatomic) float line;
//@property (strong, nonatomic)  MNFont *font;

@property (strong, nonatomic) MNStaffNote* start;
@property (strong, nonatomic) MNStaffNote* stop;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* superscript;
@property (assign, nonatomic) MNTextBracketPosition position;

@property (strong, nonatomic) NSString* fontFamily;
@property (assign, nonatomic) float fontSize;
@property (assign, nonatomic) BOOL fontBold;
@property (assign, nonatomic) BOOL fontItalic;

@property (strong, nonatomic) NSArray* dash;

@property (assign, nonatomic) float lineWidth;
@property (assign, nonatomic) BOOL showBracket;
@property (assign, nonatomic) float bracketHeight;
@property (assign, nonatomic) BOOL underlineSuperscript;
#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (id)setDashed:(BOOL)dashed;

- (instancetype)initWithStart:(MNStaffNote*)start
                         stop:(MNStaffNote*)stop
                         text:(NSString*)text
                  superscript:(NSString*)superscript
                     position:(MNTextBracketPosition)position;

@end