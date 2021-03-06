//
//  MNBeamConfig.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
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

#import "MNBeamConfig.h"
#import "MNRational.h"

@implementation MNBeamConfig

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"stem_direction" : @"stemDirection",
        @"beam_rests" : @"beamRests",
        @"beam_middle_only" : @"beamMiddleOnly",
        @"show_stemlets" : @"showStemlets",
        @"maintain_stem_directions" : @"maintainStemDirections",
    }];
    return propertiesEntriesMapping;
}

- (NSMutableDictionary*)classesForArrayEntries
{
    NSMutableDictionary* classesForArrayEntries = [super classesForArrayEntries];
    [classesForArrayEntries addEntriesFromDictionaryWithoutReplacing:@{
        @"groups" : NSStringFromClass([MNRational class])
    }];
    return classesForArrayEntries;
}

- (void)setValuesForKeyPathsWithDictionary:(NSDictionary*)keyedValues
{
    for(NSString* key_keyPath in keyedValues.allKeys)
    {
        id object = [keyedValues objectForKey:key_keyPath];
        if([key_keyPath isEqualToString:@"groups"])
        {
            [self.groups addObjectsFromArray:object];
            continue;
        }
        else
        {
            [self setValue:object forKey:key_keyPath];
        }
    }
}

- (NSMutableArray*)groups
{
    if(!_groups)
    {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

@end
