#import "main.h"

@interface TimerManager () <TimerPackageDelegate>
@property (readwrite) NSMutableArray *timers;
@end

@implementation TimerManager {
    BOOL _shouldValidateTimers;
}

+ (instancetype)shared {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];

    self.timers = [NSMutableArray arrayWithCapacity:4];

    return self;
}

- (void)setupTimersForMap:(MapIdentifier)map {
    [self.timers removeAllObjects];
    for (int i = 0; i <= sizeof(WeaponIdentifier); i++) {
        TimerPackage *package = [TimerPackage packageforMap:map weapon:i];
        if (package) {
            package.delegate = self;
            [self.timers addObject:package];
        }
    }
    [self validateTimers];
}

- (void)validateTimers {
    [self.timers sortUsingSelector:@selector(comparePackage:)];
    for (TimerPackage *package in self.timers.copy)
        if (package.shouldExpire)
            [self.timers removeObject:package];
    if (self.shouldValidateTimers)
        [self validateTimers];
}

- (void)newTimersFromExpiredTimer:(TimerPackage *)pack {
    [self.timers removeObject:pack];

    for (NSNumber *weapon in pack.weapons) {
        TimerPackage *package = [TimerPackage packageforMap:pack.map weapon:weapon.intValue];
        package.delegate = self;
        [self.timers addObject:package];
    }

    [self validateTimers];
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