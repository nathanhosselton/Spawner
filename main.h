@import UIKit.UIViewController;

@interface RootViewController : UIViewController
@end

typedef enum {
    BattleCreek,
    ChillOut,
    Damnation,
    Derelict,
    HangEmHigh,
    Longest,
    Prisoner,
    RatRace,
    Wizard
} MapIdentifier;

typedef enum {
    Rockets,
    Sniper,
    Overshield,
    Naked
} WeaponIdentifier;

@interface TimeCalc : NSObject
+ (NSTimeInterval)timeforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon;
@end

@implementation TimeCalc

+ (NSTimeInterval)timeforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon {
    if (weapon == Rockets) {
        switch (map) {
            case Derelict:
                return 30;
            case BattleCreek:
            case ChillOut:
            case Damnation:
            case HangEmHigh:
            case Prisoner:
                return 120;
            case Longest:
            case RatRace:
            case Wizard:
                return 0;
        }
    } else if (weapon == Sniper) {
        switch (map) {
            case BattleCreek:
            case Damnation:
            case Derelict:
            case HangEmHigh:
            case Prisoner:
                return 30;
            case ChillOut:
                return 60;
            case Longest:
            case RatRace:
            case Wizard:
                return 0;
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
                return 60;
            case HangEmHigh:
                return 180;
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
                return 60;
            case RatRace:
                return 90;
            case ChillOut:
                return 120;
        }
    }
    return 0;
}

@end