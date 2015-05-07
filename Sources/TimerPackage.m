@interface TimerPackage ()
@property (readwrite) NSMutableArray *weapons;
@end

@implementation TimerPackage

+ (instancetype)packageforMap:(MapIdentifier)map atTime:(NSNumber *)time {
    TimerPackage *package = [TimerPackage new];
    package.weapons = [NSMutableArray arrayWithCapacity:4];
    package.map = map;
    package.absoluteTime = time.integerValue;

    for (int i = 0; i < sizeof(WeaponIdentifier); i++) {
        int weapontime = [TimerPackage timeForWeapon:i onMap:map].intValue;
        if (weapontime)
            if (time.intValue % weapontime == 0)
                [package.weapons addObject:@(i)];
    }

    return package.weapons.count ? package : nil;
}

+ (int)weaponCountForMap:(MapIdentifier)map {
    int cnt = 0;
    for (int i = 0; i <= sizeof(WeaponIdentifier); i++)
        if ([TimerPackage timeForWeapon:i onMap:map])
            cnt++;
    return cnt;
}

- (void)announceIfNeeded {
    int time = self.time.intValue;

    switch (time) {
        case 30:
            for (NSNumber *weapon in self.weapons)
                [SPAAnnounce weapon:weapon.intValue];
            [SPAAnnounce:[NSString stringWithFormat:@"in %d seconds", time]];
            break;
        case 20:
        case 10:
        case 9:
        case 8:
        case 7:
        case 6:
        case 5:
        case 4:
        case 3:
        case 2:
        case 1:
            [SPAAnnounce count:@(time)];
            break;
//        case 0:
//            [self.delegate timerDidReachZero:self];
//            break;

        default:
            break;
    }
}

- (void)decrement {
    self.time = @(self.time.integerValue - 1);

    if (!self.time.integerValue)
        [self.delegate timerDidReachZero:self];
}

//TODO: MCC uses PC spawn times?
+ (NSNumber *)timeForWeapon:(WeaponIdentifier)weapon onMap:(MapIdentifier)map {
    if (weapon == Rockets) {
        switch (map) {
            case Derelict:
                return @30;
            case BattleCreek:
            case ChillOut:
            case Damnation:
            case HangEmHigh:
            case Prisoner:
                return @120;
            case Longest:
            case RatRace:
            case Wizard:
                break;
        }
    } else if (weapon == Sniper) {
        switch (map) {
            case BattleCreek:
            case Damnation:
            case Derelict:
            case HangEmHigh:
            case Prisoner:
                return @30;
            case ChillOut:
                return @60;
            case Longest:
            case RatRace:
            case Wizard:
                break;
        }
    } else if (weapon == Overshield) {
        switch (map) {
            case BattleCreek:
            case ChillOut:
            case Damnation:
            case Derelict:
            case Longest:
            case Prisoner:
            case RatRace:
            case Wizard:
                return @60;
            case HangEmHigh:
                return @180;
        }
    } else if (weapon == Naked) {
        switch (map) {
            case BattleCreek:
            case Damnation:
            case Derelict:
            case HangEmHigh:
            case Longest:
            case Prisoner:
            case Wizard:
                return @60;
            case RatRace:
                return @90;
            case ChillOut:
                return @120;
        }
    }
    return nil;
}

@end