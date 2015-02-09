#import "main.h"


static NSMutableArray *timers;

@implementation TimerManager {
    NSTimer *globalTimer;
    MapIdentifier lastMap;
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

    lastMap = map;
    [self validateTimers];
}

- (void)validateTimers {
    [timers sortUsingSelector:@selector(comparePackage:)];

    for (TimerPackage *package in self.timers.copy)
        if (package.isMerged)
            [timers removeObject:package];

    if (self.shouldValidateTimers)
        [self validateTimers];
}

- (void)newTimersFromExpiredTimer:(TimerPackage *)pack {
    [timers removeObject:pack];

    for (NSNumber *weapon in pack.weapons) {
        TimerPackage *package = [TimerPackage packageforMap:pack.map weapon:weapon.intValue];
        package.delegate = self;
        package.new = YES;
        [timers addObject:package];
    }

    [self validateTimers];
}

- (void)timerPackage:(TimerPackage *)oldPackage shouldMergeIntoPackage:(TimerPackage *)package {
    for (NSNumber *weapon in oldPackage.weapons) {
        if (![package.weapons containsObject:weapon])
            [package.weapons addObject:weapon];
    }

    oldPackage.merged = YES;
    _shouldValidateTimers = YES;
}

- (void)start {
    for (TimerPackage *pack in timers)
        [pack announceIfNeeded];

    globalTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(ontime:) userInfo:nil repeats:YES];
    self.running = YES;
}

- (void)ontime:(NSTimer *)timer {
    for (int i = (int)timers.count - 1; i >= 0; i--) {
        TimerPackage *pack = [timers objectAtIndex:i];
        [pack decrement];
    }

    [[timers firstObject] announceIfNeeded]; //Only works while weapon spawns are multiples of 30

    [self.delegate tick];
}

- (void)stop {
    [globalTimer invalidate];
    self.running = NO;

    [self setupTimersForMap:lastMap];
}

- (void)timerDidReachZero:(TimerPackage *)pack {
    NSUInteger index = [timers indexOfObject:pack];

    [self newTimersFromExpiredTimer:pack];

    [self.delegate timersDidRefreshAtIndex:index];

    [[timers firstObject] announceIfNeeded];
}

- (NSArray *)timers {
    return timers.copy;
}

- (NSUInteger)count {
    return timers.count;
}

- (BOOL)shouldValidateTimers {
    BOOL ret = _shouldValidateTimers;
    _shouldValidateTimers = NO;
    return ret;
}

@end