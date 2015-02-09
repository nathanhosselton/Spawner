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

#define WeaponImageViewSize 50.f


@interface RootViewController : UIViewController
@end


@protocol TimerPackageDelegate
- (void)timerPackageWasMerged:(id)oldPackage intoPackage:(id)package;
@end

@interface TimerPackage : NSObject
+ (instancetype)packageforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon;
- (void)announceIfNeeded;
- (void)decrement;
@property NSMutableArray *weapons;
@property MapIdentifier map;
@property NSNumber *time;
@property BOOL shouldExpire;
@property (nonatomic, weak) id<TimerPackageDelegate> delegate;
- (NSNumber *)timeForWeapon:(WeaponIdentifier)weapon;
- (NSComparisonResult)comparePackage:(TimerPackage *)otherPackage;
@end


@protocol TimerManagerDelegate
- (void)tick;
@end

@interface TimerManager : NSObject <TimerPackageDelegate>
@property (nonatomic, weak) id<TimerManagerDelegate> delegate;
+ (instancetype)defaultManager;
- (void)setupTimersForMap:(MapIdentifier)map;
- (void)validateTimers;
- (void)newTimersFromExpiredTimer:(TimerPackage *)package;
- (void)start;
- (void)stop;
- (NSArray *)timers;
- (NSUInteger)count;
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


@interface SPAnnounce : NSObject
+ (void):(NSString *)speech;
+ (void)weapon:(WeaponIdentifier)weapon;
+ (void)count:(NSNumber *)count;
@end