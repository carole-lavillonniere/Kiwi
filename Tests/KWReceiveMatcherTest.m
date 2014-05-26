//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWReceiveMatcherTest : SenTestCase

@end

@implementation KWReceiveMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    id matcherStrings = [KWReceiveMatcher matcherStrings];
    id expectedStrings = @[
            @"receive:",
            @"receive:withCount:",
            @"receive:withCountAtLeast:",
            @"receive:withCountAtMost:",
            @"receive:capturedArguments:",
            @"receive:andReturn:",
            @"receive:andReturn:withCount:",
            @"receive:andReturn:withCountAtLeast:",
            @"receive:andReturn:withCountAtMost:",
            @"receive:andReturn:capturedArguments:",
            @"receiveMessagePattern:countType:count:capturedArguments:",
            @"receiveMessagePattern:andReturn:countType:count:capturedArguments:",
            @"receiveUnspecifiedCountOfMessagePattern:",
            @"receiveUnspecifiedCountOfMessagePattern:andReturn:"
    ];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchReceivedMessagesForReceive {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [subject raiseShields];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchMultipleReceivedMessagesForReceiveWhenAttachedToNegativeVerifier {
    id subject = [Cruiser cruiser];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    matcher.willEvaluateAgainstNegativeExpectation = YES;
    [matcher receive:@selector(raiseShields)];
    [subject raiseShields];
    [subject raiseShields];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMultipleReceivedMessagesForReceiveWhenNotAttachedToNegativeVerifier {
    id subject = [Cruiser cruiser];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [matcher receive:@selector(raiseShields)];
    [subject raiseShields];
    [subject raiseShields];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceive {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [subject fighters];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchReceivedMessagesForReceiveWithCount {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCount:2];
    [subject raiseShields];
    [subject raiseShields];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceiveWithCount {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCount:2];
    [subject fighters];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchReceivedMessagesForReceiveWithCountAtLeast {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCountAtLeast:2];
    [subject raiseShields];
    [subject raiseShields];
    [subject raiseShields];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceiveWithCountAtLeast {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCountAtLeast:2];
    [subject fighters];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldStubForReceive {
    id subject  = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement)];
    NSUInteger value = [subject crewComplement];
    STAssertTrue(value == 0, @"expected method to be stubbed");
}

- (void)testItShouldNotOverrideExistingStub {
    id subject  = [Cruiser cruiser];
    [subject stub:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:333]];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement)];
    NSUInteger value = [subject crewComplement];
    STAssertTrue(value == 333, @"expected receive not to override existing stub");
}

- (void)testItShouldStubForReceiveAndReturn {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42]];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldMatchMultipleReceivedMessagesForReceiveAndReturnWhenAttachedToNegativeVerifier {
    id subject = [Cruiser cruiser];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    matcher.willEvaluateAgainstNegativeExpectation = YES;
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithBool:123]];
    [subject crewComplement];
    [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMultipleReceivedMessagesForReceiveAndReturnWhenNotAttachedToNegativeVerifier {
    id subject = [Cruiser cruiser];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithBool:123]];
    [subject crewComplement];
    [subject crewComplement];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldStubForReceiveAndReturnWithCount {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCount:2];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldStubForReceiveAndReturnWithCountAtLeast {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCountAtLeast:2];
    [subject crewComplement];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldStubForReceiveAndReturnWithCountAtMost {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCountAtMost:2];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldCaptureTheArguments {
    id subject = [Robot robot];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    NSArray *capturedArguments = nil;
    [matcher receive:@selector(speak:ofType:) capturedArguments:&capturedArguments];
    [subject speak:@"Hello" ofType:[NSString class]];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(capturedArguments.count == 2, @"expected 2 captured arguments");
    STAssertEqualObjects(capturedArguments[0], @"Hello", @"Unexpected argument #1: %@", capturedArguments[0]);
    STAssertEqualObjects(capturedArguments[1], [NSString class], @"Unexpected argument #2: %@", capturedArguments[1]);
}

- (void)testItShouldCaptureNoArguments {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    NSArray *capturedArguments = nil;
    [matcher receive:@selector(crewComplement) capturedArguments:&capturedArguments];
    [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(capturedArguments.count == 0, @"expected 0 captured arguments");
}

- (void)testItShouldCaptureTheArgumentsAndReturn {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    NSArray *capturedArguments = nil;
    [matcher receive:@selector(orbitPeriodForMass:) andReturn:theValue(2) capturedArguments:&capturedArguments];
    float value = [subject orbitPeriodForMass:5.5];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(capturedArguments.count == 1, @"expected 1 captured argument");
    STAssertEquals([capturedArguments[0] floatValue], 5.5f, @"Unexpected argument #1: %@", capturedArguments[0]);
    STAssertTrue(value == 2, @"expected stubbed value");
}

- (void)testItShouldFailWhenMethodCalledMoreThanOnceWithArgsCapture {
    id subject = [Robot robot];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    NSArray *capturedArguments = nil;
    [matcher receive:@selector(speak:ofType:) capturedArguments:&capturedArguments];

    [subject speak:@"Hello" ofType:[NSString class]];
    [subject speak:@"Goodbye" ofType:[NSString class]];

    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldWorkWithAMock {
    id subject = [Robot mock];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(speak:ofType:)];
    [subject speak:@"Hello" ofType:[NSString class]];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

@end

#endif // #if KW_TESTS_ENABLED
