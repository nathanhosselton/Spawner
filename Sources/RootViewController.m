#import <sym0.h>
@import UIKit.UIScreen;
@import UIKit.UITapGestureRecognizer;
@import UIKit.UIButton;
@import UIKit.UILabel;

@interface RootViewController ()
@end

@implementation RootViewController {
    UILabel *currentLabel;
    SPATimerView *timerView;
    NSMutableArray *maps;
    CGRect mapLabelOrigin;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.view setPortalImage:[UIImage imageNamed:[self mapname:self.currentMap]]];

    CGFloat mapLabelHeight = 50.f;
    CGFloat mapLabelWidth = UIScreenWidth*(2.f/3.f);
    mapLabelOrigin = CGRectMake((UIScreenWidth - mapLabelWidth)/2, mapLabelHeight, mapLabelWidth, mapLabelHeight);

////// start button
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setFrame:CGRectMake(0, mapLabelHeight*3, 100.f, 50.f)];
    [start setCenter:CGPointMake(self.view.center.x, start.center.y)];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start setTitle:@"Stop" forState:UIControlStateSelected];
    [start addTarget:self action:@selector(onstart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];

////// timerview
    timerView = [[SPATimerView alloc] initWithFrame:CGRectMake(0.f, UIScreenHeight - 150.f, UIScreenWidth, 150.f)];
    [timerView layoutSubviews];
    [self.view addSubview:timerView];

////// map picker
    NSArray *mapNames = [NSArray arrayWithObjects: @"Battle Creek",
                                                   @"Chill Out",
                                                   @"Damnation",
                                                   @"Derelict",
                                                   @"Hang 'em High",
                                                   @"Longest",
                                                   @"Prisoner",
                                                   @"Rat Race",
                                                   @"Wizard", nil];
    maps = [NSMutableArray arrayWithCapacity:mapNames.count];
    UILabel *lastLabel;
    for (NSString *map in mapNames) {
        UILabel *label = [[UILabel alloc] initWithFrame:mapLabelOrigin];
        label.text = map;
        label.tag = [mapNames indexOfObject:map];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [self colorForMapIndex:(MapIdentifier)label.tag];
        label.userInteractionEnabled = YES;
//        [label setPortalImage:[UIImage imageNamed:[self mapname:(MapIdentifier)label.tag]]];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap:)];
        [label addGestureRecognizer:tap];

        [self.view insertSubview:label belowSubview:lastLabel ? lastLabel : self.view];
        [maps addObject:label];
        lastLabel = label;
    }
    currentLabel = maps.firstObject;

    [TimerManager defaultManager].delegate = timerView;
    [[TimerManager defaultManager] setupTimersForMap:self.currentMap];
    [timerView configureWithTimerPackage:[TimerManager defaultManager].activePackage];
}

- (UIColor *)colorForMapIndex:(MapIdentifier)mapIndex {
    switch (mapIndex) {
        case BattleCreek:
        case ChillOut:
        case Damnation:
        case Derelict:
        case HangEmHigh:
        case Longest:
        case Prisoner:
        case RatRace:
        case Wizard: return [UIColor colorWithRed:0.576 green:0.392 blue:1.000 alpha:1.000];
    }
    return [UIColor clearColor];
}

- (void)onstart:(UIButton *)button {
    if (button.state == UIControlStateHighlighted) {
        [[TimerManager defaultManager] start];

        [button setSelected:YES];
    } else if (button.state == (UIControlStateHighlighted | UIControlStateSelected)) {
        [[TimerManager defaultManager] stop];

        [timerView configureWithTimerPackage:[TimerManager defaultManager].activePackage];
        [button setSelected:NO];
    }
}

- (void)ontap:(UITapGestureRecognizer *)tap {
//    NSLog(@"%@ tapped", ((UILabel *)tap.view).text);
    if ([TimerManager defaultManager].isRunning)
        return;

    if (self.mapListIsExpanded) {
        currentLabel = (UILabel *)tap.view;

        [self.view bringSubviewToFront:tap.view];

        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *label in maps)
                label.frame = mapLabelOrigin;
        }];

        [[TimerManager defaultManager] setupTimersForMap:self.currentMap];
        [timerView configureWithTimerPackage:[TimerManager defaultManager].activePackage];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *label in maps)
                label.center = CGPointMake(label.center.x, (label.frame.size.height * 1.1) * (label.tag + 1));
        }];
    }
}

- (MapIdentifier)currentMap {
    if (currentLabel)
        return (MapIdentifier)currentLabel.tag;

    return 0;
}

//- (NSString *)mapname:(MapIdentifier)map {
//#define macro(x) case x: return @#x;
//
//    switch (map) {
//            macro(BattleCreek)
//            macro(ChillOut)
//            macro(Damnation)
//            macro(Derelict)
//            macro(HangEmHigh)
//            macro(Longest)
//            macro(Prisoner)
//            macro(RatRace)
//            macro(Wizard)
//    }
//    return nil;
//}

- (BOOL)mapListIsExpanded {
    return !CGRectEqualToRect(currentLabel.frame, mapLabelOrigin);
}

@end