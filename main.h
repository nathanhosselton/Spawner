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

@protocol TimerPackageDelegate
- (void)timerPackageWasMerged:(id)oldPackage intoPackage:(id)package;
@end

@interface TimerPackage : NSObject
+ (instancetype)packageforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon;
@property NSMutableArray *weapons;
@property MapIdentifier map;
@property NSNumber *time;
@property BOOL shouldExpire;
@property (nonatomic, weak) id<TimerPackageDelegate> delegate;
- (NSNumber *)timeForWeapon:(WeaponIdentifier)weapon;
- (NSComparisonResult)comparePackage:(TimerPackage *)otherPackage;
@end

@protocol TimerCellDelegate
- (void)timerDidReachZero:(id)cell;
@end

@interface TimerCell : UITableViewCell
@property TimerPackage *package;
@property UILabel *timerLabel;
@property UIImageView *primWpnImgView;
@property UIImageView *subWpnImgView;
@property (nonatomic, weak) id<TimerCellDelegate> delegate;
- (void)decrementTimer;
@end