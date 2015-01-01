#import <sym0.h>
@import UIKit.UIScreen;
@import UIKit.UIViewController;
@import UIKit.UITableViewCell;
@import UIKit.UILabel;

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

#define WeaponImageViewSize 50.f

@interface TimerCell : UITableViewCell
@property NSTimer *timer;
@property UILabel *timerLabel;
@property UIImageView *primWpnImgView;
@property UIImageView *subWpnImgView;
@end

@interface TimeCalc : NSObject
+ (NSTimeInterval)timeforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon;
@end