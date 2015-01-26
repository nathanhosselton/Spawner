#import "main.h"

@implementation TimerPackage

+ (instancetype)packageforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon {
    TimerPackage *package = [TimerPackage new];
    package.weapons = [NSMutableArray arrayWithObject:@(weapon)];
    package.map = map;
    package.time = [package timeForWeapon:weapon];

    return package.time ? package : nil;
}

- (NSComparisonResult)comparePackage:(TimerPackage *)otherPackage {
    NSLog(@"current pack: %@ other pack: %@", self.time, otherPackage.time);
    NSComparisonResult result = [self.time compare:otherPackage.time];
    if (result == NSOrderedSame) {
        for (NSNumber *weapon in otherPackage.weapons) {
            if (![self.weapons containsObject:weapon])
                [self.weapons addObject:weapon];
        }
//        [self.weapons sortUsingSelector:@selector(compare:)]; // Untested
        self.shouldExpire = NO;
        otherPackage.shouldExpire = YES;
        [self.delegate timerPackageWasMerged:otherPackage intoPackage:self];
    }
    return result;
}
//TODO: MCC uses PC spawn times
- (NSNumber *)timeForWeapon:(WeaponIdentifier)weapon {
    if (weapon == Rockets) {
        switch (self.map) {
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
        switch (self.map) {
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
        switch (self.map) {
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
        switch (self.map) {
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

- (BOOL)isEqualToTimerPackage:(TimerPackage *)pack {
    if (!pack)
        return NO;

    BOOL haveSameWeapons = (!self.weapons && !pack.weapons) || [self.weapons isEqualToArray:pack.weapons];
    BOOL haveEqualTime = (!self.time && !pack.time) || [self.time isEqualToNumber:pack.time];

    return haveSameWeapons && haveEqualTime;
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:[TimerPackage class]])
        return NO;

    return [self isEqualToTimerPackage:(TimerPackage *)object];
}

- (NSUInteger)hash {
    return [self.weapons hash] ^ [self.time hash];
}

@end