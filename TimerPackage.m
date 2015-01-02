#import "main.h"

@implementation TimerPackage

+ (instancetype)packageforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon {
    TimerPackage *package = [TimerPackage new];
    package.weapons = [NSMutableArray arrayWithObject:@(weapon)];
    package.map = map;
    package.time = @0;

    if (weapon == Rockets) {
        switch (map) {
            case Derelict:
                package.time = @30;
                break;
            case BattleCreek:
            case ChillOut:
            case Damnation:
            case HangEmHigh:
            case Prisoner:
                package.time = @120;
                break;
            case Longest:
            case RatRace:
            case Wizard:
                package.time = @0;
                break;
        }
    } else if (weapon == Sniper) {
        switch (map) {
            case BattleCreek:
            case Damnation:
            case Derelict:
            case HangEmHigh:
            case Prisoner:
                package.time = @30;
                break;
            case ChillOut:
                package.time = @60;
                break;
            case Longest:
            case RatRace:
            case Wizard:
                package.time = @0;
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
                package.time = @60;
                break;
            case HangEmHigh:
                package.time = @180;
                break;
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
                package.time = @60;
                break;
            case RatRace:
                package.time = @90;
                break;
            case ChillOut:
                package.time = @120;
                break;
        }
    }

    return package;
}

- (NSComparisonResult)comparePackage:(TimerPackage *)otherPackage {
    return [self.time compare:otherPackage.time];
}

@end