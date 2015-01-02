#import "main.h"

@implementation TimerLabel

- (void)decrementTimer {
    int count = self.text.intValue;
    self.text = [NSString stringWithFormat:@"%d", --count];

    if (count == 0) {
        // Send notification
        NSLog(@"timedout");
    }
}

@end