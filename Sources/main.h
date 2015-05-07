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

#define SPARespawnInterval 30


@interface RootViewController : UIViewController
- (MapIdentifier)currentMap;
@end


@interface UIView (Portal)
@property UIImageView *portalImageView;
- (void)setPortalImage:(UIImage *)image;
@end


@protocol TimerPackageDelegate
- (void)timerDidReachZero:(id)pack;
@end

@interface TimerPackage : NSObject
@property (readonly) NSMutableArray *weapons;
@property MapIdentifier map;
@property NSNumber *time;
@property NSTimeInterval absoluteTime;
@property NSTimeInterval relativeTime;
@property (nonatomic, weak) id<TimerPackageDelegate> delegate;
+ (instancetype)packageforMap:(MapIdentifier)map atTime:(NSNumber *)time;
+ (int)weaponCountForMap:(MapIdentifier)map;
- (void)announceIfNeeded;
- (void)decrement;
@end


@protocol TimerManagerDelegate
- (void)tick:(TimerPackage *)package;
- (void)timersDidCycleToPackage:(TimerPackage *)package;
@end

@interface TimerManager : NSObject <TimerPackageDelegate>
@property TimerPackage *activePackage;
@property (nonatomic, getter=isRunning) BOOL running;
@property (nonatomic, weak) id<TimerManagerDelegate> delegate;
+ (instancetype)defaultManager;
- (void)setupTimersForMap:(MapIdentifier)map;
- (void)start;
- (void)stop;
- (NSArray *)timers;
- (NSUInteger)count;
@end


@interface SPATimerView : UIView <TimerManagerDelegate>
@property UIImageView *rockets;
@property UIImageView *sniper;
@property UIImageView *overshield;
@property UIImageView *naked;
@property UILabel *time;
- (void)configureWithTimerPackage:(TimerPackage *)package;
@end


@interface SPAAnnounce : NSObject
+ (void):(NSString *)speech;
+ (void)weapon:(WeaponIdentifier)weapon;
+ (void)count:(NSNumber *)count;
@end