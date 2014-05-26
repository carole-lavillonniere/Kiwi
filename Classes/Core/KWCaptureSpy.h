#import "KWMessageSpying.h"

DEPRECATED_ATTRIBUTE

@interface KWCaptureSpy : NSObject<KWMessageSpying>

@property (nonatomic, strong, readonly) id argument;

- (id)initWithArgumentIndex:(NSUInteger)index;

@end
