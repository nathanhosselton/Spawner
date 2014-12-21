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