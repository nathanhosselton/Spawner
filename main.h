@import UIKit.UIViewController;

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

@interface RootViewController : UIViewController
@property MapIdentifier currentMap;
@end

@interface MapPickerViewController : UIViewController
@property NSArray const *mapNames;
@end

@interface TimeCalc : NSObject
+ (NSTimeInterval)timeforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon;
@end