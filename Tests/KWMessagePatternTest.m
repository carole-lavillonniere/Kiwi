//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "NSInvocation+KiwiAdditions.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWMessagePatternTest : SenTestCase

@end

@implementation KWMessagePatternTest

- (void)testItShouldCreateMessagePatternsWithArguments {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(dictionaryWithObjects:forKeys:count:) argumentFilters:@[@"foo", nilValue, [KWValue valueWithUnsignedInt:1]]];
    STAssertEqualObjects((messagePattern.argumentFilters)[0], @"foo", @"expected matching argument");
    STAssertEqualObjects((messagePattern.argumentFilters)[1], [KWNull null], @"expected matching argument");
    STAssertEqualObjects((messagePattern.argumentFilters)[2], [KWValue valueWithUnsignedInt:1], @"expected matching argument");
}

- (void)testItShouldFailCreatingMessagePatternsWithTooFewArguments {
    STAssertThrows([KWMessagePattern messagePatternWithSelector:@selector(dictionaryWithObjects:forKeys:count:) argumentFilters:@[@"foo"]], @"Should have raised an exception");
}

- (void)testItShouldNotFailCreatingMessagePatternsWithNilArguments {
    STAssertNoThrow([KWMessagePattern messagePatternWithSelector:@selector(dictionaryWithObjects:forKeys:count:) argumentFilters:nil], @"Should not have raised an exception");
}

- (void)testItShouldFailCreatingMessagePatternsWithTooManyArguments {
    STAssertThrows(([KWMessagePattern messagePatternWithSelector:@selector(dictionaryWithObjects:forKeys:count:) argumentFilters:@[@"1", @"2", @"3", @"4"]]), @"Should have raised an exception");
}

- (void)testItShouldMatchInvocationsWithNilArguments {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) argumentFilters:@[@"foo", nilValue, [KWValue valueWithUnsignedInt:0], nilValue]];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = nil;
    NSKeyValueObservingOptions options = 0;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArguments {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) argumentFilters:@[@"foo", [KWAny any], [KWAny any], nilValue]];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 1;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithClassArgument {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(isKindOfClass:) argumentFilters:@[[NSObject class]]];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(isKindOfClass:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(isKindOfClass:)];
    Class objectClass = [NSObject class];
    [invocation setMessageArguments:&objectClass];
    STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArgumentsWhenCreatedWithMessagePatternFromInvocation {
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *creationInvocation = [NSInvocation invocationWithMethodSignature:signature];
    id creationInvocationObserver = @"foo";
    id creationInvocationKeyPath = [KWAny any];
    id creationInvocationOptions = [KWAny any];
    void *creationInvocationContext = nil;
    [creationInvocation setMessageArguments:&creationInvocationObserver, &creationInvocationKeyPath, &creationInvocationOptions, &creationInvocationContext];
    [creationInvocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternFromInvocation:creationInvocation];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 1;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArgumentsWhenCreatedWithMessagePatternFromInvocationTwo {
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *creationInvocation = [NSInvocation invocationWithMethodSignature:signature];
    id creationInvocationObserver = @"foo";
    id creationInvocationKeyPath = [KWAny any];
    NSKeyValueObservingOptions creationInvocationOptions = 1;
    void *creationInvocationContext = nil;
    [creationInvocation setMessageArguments:&creationInvocationObserver, &creationInvocationKeyPath, &creationInvocationOptions, &creationInvocationContext];
    [creationInvocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternFromInvocation:creationInvocation];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 1;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArgumentsForBlockParameters {
	NSMethodSignature *signature = [Robot instanceMethodSignatureForSelector:@selector(speak:afterDelay:whenDone:)];
	NSInvocation *creationInvocation = [NSInvocation invocationWithMethodSignature:signature];
	id creationInvocationMessage = @"Hello World";
	NSTimeInterval creationInvocationTimeInterval = 1.0;
	id creationInvocationHandler = [KWAny any];
	[creationInvocation setMessageArguments:&creationInvocationMessage, &creationInvocationTimeInterval, &creationInvocationHandler];
	[creationInvocation setSelector:@selector(speak:afterDelay:whenDone:)];
	KWMessagePattern *messagePattern = [KWMessagePattern messagePatternFromInvocation:creationInvocation];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:@selector(speak:afterDelay:whenDone:)];
	id message = @"Hello World";
	NSTimeInterval timeInterval = 1.0;
	id handler = ^{};
	[invocation setMessageArguments:&message, &timeInterval, &handler];
	STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldNotMatchInvocationsWithAnyArguments {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) argumentFilters:@[@"foo", [KWAny any], [KWValue valueWithUnsignedInt:0], nilValue]];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 1;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue(![messagePattern matchesInvocation:invocation], @"expected non-matching invocation");
}

- (void)testItShouldNotMatchInvocationsWithDifferentArguments {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) argumentFilters:@[@"foo", nilValue, [KWValue valueWithUnsignedInt:0], nilValue]];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 0;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue(![messagePattern matchesInvocation:invocation], @"expected non-matching invocation");
}

- (void)testItShouldCompareMessagePatternsWithNilAndNonNilArgumentFilters {
    KWMessagePattern *messagePattern1 = [KWMessagePattern messagePatternWithSelector:@selector(setYear:)];
    NSArray *argumentFilters = @[[KWValue valueWithUnsignedInt:42]];
    KWMessagePattern *messagePattern2 = [KWMessagePattern messagePatternWithSelector:@selector(setYear:) argumentFilters:argumentFilters];

    STAssertFalse([messagePattern1 isEqual:messagePattern2], @"expected message patterns to compare as not equal");
    STAssertFalse([messagePattern2 isEqual:messagePattern1], @"expected message patterns to compare as not equal");
}

@end

#endif // #if KW_TESTS_ENABLED
