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

@protocol TimerCellDelegate
- (void)timerDidReachZero:(id)cell;
@end

@interface TimerCell : UITableViewCell
@property NSNumber *time;
@property UILabel *timerLabel;
@property UIImageView *primWpnImgView;
@property UIImageView *subWpnImgView;
@property (nonatomic, weak) id<TimerCellDelegate> delegate;
- (void)decrementTimer;
@end


@interface TimeCalc : NSObject
+ (NSNumber *)timeforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon;
@end