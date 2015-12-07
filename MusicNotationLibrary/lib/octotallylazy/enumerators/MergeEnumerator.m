#import "MergeEnumerator.h"
#import "Pair.h"

@implementation MergeEnumerator
{
    NSEnumerator* left;
    NSEnumerator* right;
}

- (MergeEnumerator*)initWith:(NSEnumerator*)leftEnumerator toMerge:(NSEnumerator*)rightEnumerator
{
    self = [super init];
    left = leftEnumerator;
    right = rightEnumerator;
    return self;
}

- (id)nextObject
{
    id leftItem = [Option oct_option:[left nextObject]];
    id rightItem = [Option oct_option:[right nextObject]];
    if([leftItem oct_isEmpty] && [rightItem oct_isEmpty])
    {
        return nil;
    }
    return [sequence(leftItem, rightItem, nil) oct_flatten];
}

+ (MergeEnumerator*)oct_with:(NSEnumerator*)leftEnumerator toMerge:(NSEnumerator*)rightEnumerator
{
    return [[MergeEnumerator alloc] initWith:leftEnumerator toMerge:rightEnumerator];
}

@end