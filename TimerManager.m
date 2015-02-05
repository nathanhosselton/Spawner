#import "main.h"


static NSMutableArray *timers;

@implementation TimerManager {
    NSTimer *globalTimer;
    BOOL _shouldValidateTimers;
}

+ (instancetype)defaultManager {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        timers = [NSMutableArray arrayWithCapacity:4];
    });

    return _sharedInstance;
}

- (void)setupTimersForMap:(MapIdentifier)map {
    [timers removeAllObjects];

    for (int i = 0; i <= sizeof(WeaponIdentifier); i++) {
        TimerPackage *package = [TimerPackage packageforMap:map weapon:i];
        if (package) {
            package.delegate = self;
            [timers addObject:package];
        }
    }
    
    [self validateTimers];
}

- (void)validateTimers {
    [timers sortUsingSelector:@selector(comparePackage:)];

    for (TimerPackage *package in self.timers.copy)
        if (package.shouldExpire)
            [timers removeObject:package];

    if (self.shouldValidateTimers)
        [self validateTimers];
}

- (void)newTimersFromExpiredTimer:(TimerPackage *)pack {
    [timers removeObject:pack];

    for (NSNumber *weapon in pack.weapons) {
        TimerPackage *package = [TimerPackage packageforMap:pack.map weapon:weapon.intValue];
        package.delegate = self;
        [timers addObject:package];
    }

    [self validateTimers];
}

- (void)start {
    globalTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(ontime:) userInfo:nil repeats:YES];
}

- (void)stop {
    [globalTimer invalidate];
}

- (NSArray *)timers {
    return timers.copy;
}

- (NSUInteger)count {
    return timers.count;
}

- (void)ontime:(NSTimer *)timer {
    [self.delegate tick];
}

- (void)timerPackageWasMerged:(id)oldPackage intoPackage:(id)package {
    _shouldValidateTimers = YES;
}

- (BOOL)shouldValidateTimers {
    BOOL ret = _shouldValidateTimers;
    _shouldValidateTimers = NO;
    return ret;
}

@end