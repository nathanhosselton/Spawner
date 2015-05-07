#import <sym0.h>
@import UIKit.UIScreen;
@import UIKit.UIImageView;
@import UIKit.UIImage;
@import UIKit.UILabel;

@implementation SPATimerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.rockets = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rockets.jpg"]];
    self.sniper = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sniper.jpg"]];
    self.overshield = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Overshield"]];
    self.naked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Naked"]];

    self.time = [UILabel new];

    return self;
}

- (void)layoutSubviews {
    self.overshield.frame = CGRectMake(UIScreenWidth - 50.f, 0.f, 50.f, 50.f);
    self.naked.frame = CGRectMake(UIScreenWidth - 50.f, 50.f, 50.f, 50.f);
    self.rockets.frame = CGRectMake(0.f, 0.f, UIScreenWidth - 50.f, 50.f);
    self.sniper.frame = CGRectMake(0.f, 50.f, UIScreenWidth - 50.f, 50.f);

    self.time.frame = CGRectMake(0.f, 100.f, UIScreenWidth, 50.f);
    self.time.textAlignment = NSTextAlignmentCenter;
    self.time.textColor = [UIColor whiteColor];
    self.time.font = [UIFont systemFontOfSize:20.f];

    [self addSubview:self.rockets];
    [self addSubview:self.sniper];
    [self addSubview:self.overshield];
    [self addSubview:self.naked];
    [self addSubview:self.time];
}

- (void)configureWithTimerPackage:(TimerPackage *)package {
    self.time.text = package.time.stringValue;

    self.rockets.hidden = ![package.weapons containsObject:@0];
    self.sniper.hidden = ![package.weapons containsObject:@1];
    self.overshield.hidden = ![package.weapons containsObject:@2];
    self.naked.hidden = ![package.weapons containsObject:@3];
}

- (void)tick:(TimerPackage *)package {
    self.time.text = package.time.stringValue;
}

- (void)timersDidCycleToPackage:(TimerPackage *)package {
    [self configureWithTimerPackage:package];
}

@end