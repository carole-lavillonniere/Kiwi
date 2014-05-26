//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@class KWCaptureSpy;

@protocol KiwiSpyAdditions <NSObject>

- (KWCaptureSpy *)captureArgument:(SEL)selector atIndex:(NSUInteger)index DEPRECATED_ATTRIBUTE;
+ (KWCaptureSpy *)captureArgument:(SEL)selector atIndex:(NSUInteger)index DEPRECATED_ATTRIBUTE;

@end

@interface NSObject (KiwiSpyAdditions) <KiwiSpyAdditions>

@end
