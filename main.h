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
- (void)timerPackage:(id)oldPackage shouldMergeIntoPackage:(id)package;
- (void)timerDidReachZero:(id)pack;
@end

@interface TimerPackage : NSObject
@property NSMutableArray *weapons;
@property MapIdentifier map;
@property NSNumber *time;
@property (getter=isMerged) BOOL merged;
@property (nonatomic, weak) id<TimerPackageDelegate> delegate;
+ (instancetype)packageforMap:(MapIdentifier)map weapon:(WeaponIdentifier)weapon;
- (void)announceIfNeeded;
- (void)decrement;
- (NSComparisonResult)comparePackage:(TimerPackage *)otherPackage;
@end


@protocol TimerManagerDelegate
- (void)tick;
- (void)timersDidRefreshAtIndex:(NSUInteger)index withCountDifference:(NSInteger)dif;
@end

@interface TimerManager : NSObject <TimerPackageDelegate>
@property (getter=isRunning) BOOL running;
@property (nonatomic, weak) id<TimerManagerDelegate> delegate;
+ (instancetype)defaultManager;
- (void)setupTimersForMap:(MapIdentifier)map;
- (void)start;
- (void)stop;
- (NSArray *)timers;
- (NSUInteger)count;
@end


@interface TimerCell : UITableViewCell
@property TimerPackage *package;
@property UILabel *timerLabel;
@property UIImageView *primWpnImgView;
@property UIImageView *subWpnImgView;
- (void)decrementTimer;
@end


@interface SPAnnounce : NSObject
+ (void):(NSString *)speech;
+ (void)weapon:(WeaponIdentifier)weapon;
+ (void)count:(NSNumber *)count;
@end