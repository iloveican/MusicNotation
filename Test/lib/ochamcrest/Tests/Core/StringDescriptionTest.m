//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2014 hamcrest.org. See LICENSE.txt

    // Class under test
#import "HCStringDescription.h"

    // Collaborators
#import "HCSelfDescribing.h"

    // Test support
#import "SenTestingKit.h"


@interface FakeSelfDescribing : NSObject <HCSelfDescribing>
@end

@implementation FakeSelfDescribing

- (void)describeTo:(id<HCDescription>)description
{
    [description appendText:@"DESCRIPTION"];
}

@end


@interface ObjectDescriptionWithLessThan : NSObject
@end

@implementation ObjectDescriptionWithLessThan

- (NSString *)description
{
    return @"< is less than";
}

@end


@interface ObjectWithNilDescription : NSObject
@end

@implementation ObjectWithNilDescription

- (NSString *)description
{
    return nil;
}

@end


@interface ProxyObjectSuchAsMock : NSProxy
@property (readonly, nonatomic, copy) NSString *descriptionText;
@end

@implementation ProxyObjectSuchAsMock

- (instancetype)initWithDescription:(NSString *)description
{
    _descriptionText = [description copy];
    return self;
}

- (NSString *)description
{
    return self.descriptionText;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [[NSObject class] methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
}

@end


@interface StringDescriptionTest : SenTestCase
@end

@implementation StringDescriptionTest
{
    HCStringDescription *description;
}

- (void)setUp
{
    [super setUp];
    description = [[HCStringDescription alloc] init];
}

- (void)tearDown
{
    description = nil;
    [super tearDown];
}

- (void)testDescribesNil
{
    [description appendDescriptionOf:nil];

    STAssertEqualObjects([description description], @"nil", nil);
}

- (void)testLetsSelfDescribingObjectDescribeItself
{
    [description appendDescriptionOf:[[FakeSelfDescribing alloc] init]];

    STAssertEqualObjects([description description], @"DESCRIPTION", nil);
}

- (void)testDescribesStringInQuotes
{
    [description appendDescriptionOf:@"FOO"];

    STAssertEqualObjects([description description], @"\"FOO\"", nil);
}

- (void)testDescriptionOfStringWithQuotesShouldExpandToCSyntax
{
    [description appendDescriptionOf:@"a\"b"];

    STAssertEqualObjects([description description], @"\"a\\\"b\"", nil);
}

- (void)testDescriptionOfStringWithNewlineShouldExpandToCSyntax
{
    [description appendDescriptionOf:@"a\nb"];

    STAssertEqualObjects([description description], @"\"a\\nb\"", nil);
}

- (void)testDescriptionOfStringWithCarriageReturnShouldExpandToCSyntax
{
    [description appendDescriptionOf:@"a\rb"];

    STAssertEqualObjects([description description], @"\"a\\rb\"", nil);
}

- (void)testDescriptionOfStringWithTabShouldExpandToCSyntax
{
    [description appendDescriptionOf:@"a\tb"];

    STAssertEqualObjects([description description], @"\"a\\tb\"", nil);
}

- (void)testWrapsNonSelfDescribingObjectInAngleBrackets
{
    [description appendDescriptionOf:@42];

    STAssertEqualObjects([description description], @"<42>", nil);
}

- (void)testShouldNotAddAngleBracketsIfObjectDescriptionAlreadyHasThem
{
    [description appendDescriptionOf:[[NSObject alloc] init]];
    NSPredicate *expected = [NSPredicate predicateWithFormat:
                             @"SELF MATCHES '<NSObject: 0x[0-9a-fA-F]+>'"];
    STAssertTrue([expected evaluateWithObject:[description description]], nil);
}

- (void)testWrapsNonSelfDescribingObjectInAngleBracketsIfItDoesNotEndInClosingBracket
{
    ObjectDescriptionWithLessThan *lessThanDescription = [[ObjectDescriptionWithLessThan alloc] init];
    [description appendDescriptionOf:lessThanDescription];

    STAssertEqualObjects([description description], @"<< is less than>", nil);
}

- (void)testCanDescribeObjectWithNilDescription
{
    [description appendDescriptionOf:[[ObjectWithNilDescription alloc] init]];
    NSPredicate *expected = [NSPredicate predicateWithFormat:
                             @"SELF MATCHES '<ObjectWithNilDescription: 0x[0-9a-fA-F]+>'"];
    STAssertTrue([expected evaluateWithObject:[description description]], nil);
}

- (void)testAppendListWithEmptyListShouldHaveStartAndEndOnly
{
    [description appendList:@[]
                      start:@"["
                  separator:@","
                        end:@"]"];

    STAssertEqualObjects([description description], @"[]", nil);
}

- (void)testAppendListWithOneItemShouldHaveStartItemAndEnd
{
    [description appendList:@[@"a"]
                      start:@"["
                  separator:@","
                        end:@"]"];

    STAssertEqualObjects([description description], @"[\"a\"]", nil);
}

- (void)testAppendListWithTwoItemsShouldHaveItemsWithSeparator
{
    [description appendList:@[@"a", @"b"]
                      start:@"["
                  separator:@","
                        end:@"]"];

    STAssertEqualObjects([description description], @"[\"a\",\"b\"]", nil);
}

- (void)testAbleToDescribeProxyObject
{
    id proxy = [[ProxyObjectSuchAsMock alloc] initWithDescription:@"DESCRIPTION"];

    [description appendDescriptionOf:proxy];

    STAssertEqualObjects([description description], @"<DESCRIPTION>", nil);
}

@end
