#import "KWMessageSpying.h"

__attribute__ ((deprecated))

@interface KWCaptureSpy : NSObject<KWMessageSpying>

@property (nonatomic, strong, readonly) id argument;

- (id)initWithArgumentIndex:(NSUInteger)index;

@end
