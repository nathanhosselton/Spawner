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
        _sharedInstance = [TimerManager new];
        timers = [NSMutableArray new];
    });

    return _sharedInstance;
}

- (void)setupTimersForMap:(MapIdentifier)map {
    [timers removeAllObjects];

    int maxWeapons = [TimerPackage weaponCountForMap:map];
    int time = SPARespawnInterval;
    TimerPackage *lastPack;

    do {
        TimerPackage *package = [TimerPackage packageforMap:map atTime:@(time)];
        if (package) {
            package.delegate = self;
            package.relativeTime = package.absoluteTime - lastPack.absoluteTime;
            package.time = @(package.relativeTime);
            [timers addObject:package];
            lastPack = package;
        }
        time += SPARespawnInterval;
    } while (lastPack.weapons.count < maxWeapons);

    self.activePackage = timers.firstObject;
    lastMap = map;
}
- (void)start {
    [self.activePackage announceIfNeeded];
    globalTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(ontime:) userInfo:nil repeats:YES];
    self.running = YES;
}

- (void)ontime:(NSTimer *)timer {
    [self.activePackage decrement];
    [self.activePackage announceIfNeeded];
    
    [self.delegate tick:self.activePackage]; //Use case for KVO?
}

- (void)stop {
    [globalTimer invalidate];
    self.activePackage = nil;
    self.running = NO;

    [self setupTimersForMap:lastMap];
}

- (void)timerDidReachZero:(TimerPackage *)oldPackage {
    NSUInteger newIndex = [timers indexOfObject:oldPackage] + 1;
    self.activePackage = [timers objectAtIndex:newIndex < timers.count ? newIndex : 0];

    [self.delegate timersDidCycleToPackage:self.activePackage];

//    [self.activePackage announceIfNeeded];

    oldPackage.time = @(oldPackage.relativeTime);
}

- (NSArray *)timers {
    return timers.copy;
}

- (NSUInteger)count {
    return timers.count;
}

- (void)setRunning:(BOOL)running {
    _running = running;
    [[UIApplication sharedApplication] setIdleTimerDisabled:running];
}

@end