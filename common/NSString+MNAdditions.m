//
//  NSString+MNAdditions.m
//  MusicNotation
//
//  Created by Scott on 8/9/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
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

#import "NSString+MNAdditions.h"
#import "NSString+Ruby.h"

@implementation NSString (MNAdditions)

- (NSString*)camelCaseToTitleCase
{
    NSString* camelCaseString = self;   // REFStringForMemberInTestType([numType integerValue]);
    NSMutableString* titleCaseString = [NSMutableString string];
    for(NSInteger i = 0; i < camelCaseString.length; i++)
    {
        NSString* ch = [camelCaseString substringWithRange:NSMakeRange(i, 1)];
        if([ch rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound)
        {
            [titleCaseString appendString:@" "];
        }
        [titleCaseString appendString:ch];
    }

    return [NSString stringWithString:titleCaseString];
}

- (BOOL)isNotEqualToString:(NSString*)other
{
    return ![self isEqualToString:other];
}

- (NSString*)removeNewLinesAndExcessWhiteSpace
{
    NSString* original = self;

    NSString* squashed = [original stringByReplacingOccurrencesOfString:@"[ ]+"
                                                             withString:@" "
                                                                options:NSRegularExpressionSearch
                                                                  range:NSMakeRange(0, original.length)];

    NSString* final = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return [final substituteAll:@{ @"\n" : @"|", @"\r" : @"" }];
}

+ (NSString*)oneLineString:(NSArray*)array
{
    NSString *ret = [[array description] removeNewLinesAndExcessWhiteSpace];
    return ret;
}

@end
