//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@class KWCaptureSpy;

@protocol KiwiSpyAdditions <NSObject>

- (KWCaptureSpy *)captureArgument:(SEL)selector atIndex:(NSUInteger)index __attribute__((deprecated));
+ (KWCaptureSpy *)captureArgument:(SEL)selector atIndex:(NSUInteger)index __attribute__((deprecated));

@end

@interface NSObject (KiwiSpyAdditions) <KiwiSpyAdditions>

@end
