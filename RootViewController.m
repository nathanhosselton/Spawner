#import <Foundation/Foundation.h>
#import "main.h"
@import UIKit.UITableView;
@import UIKit.UIButton;
@import UIKit.UIScreen;
@import UIKit.UITapGestureRecognizer;

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, TimerManagerDelegate>
@end

@implementation RootViewController {
    UILabel *currentLabel;
    UITableView *tv;
    NSTimer *timer;
    NSMutableArray *maps;
    CGRect mapLabelFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat mapLabelHeight = 50.f;
    CGFloat mapLabelWidth = UIScreenWidth*(2.f/3.f);
    mapLabelFrame = CGRectMake((UIScreenWidth - mapLabelWidth)/2, mapLabelHeight, mapLabelWidth, mapLabelHeight);

////// start button
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setFrame:CGRectMake(0, mapLabelHeight*3, 100.f, 50.f)];
    [start setCenter:CGPointMake(self.view.center.x, start.center.y)];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start setTitle:@"Stop" forState:UIControlStateSelected];
    [start addTarget:self action:@selector(onstart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];

////// tableview
    CGFloat y = mapLabelHeight*5;
    CGRect rect = CGRectMake(0, y, UIScreenWidth, UIScreenHeight-y);
    tv = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    [tv setBackgroundView:nil];
    [tv setBackgroundColor:[UIColor clearColor]];
    [tv setSeparatorColor:[UIColor colorWithWhite:0.100 alpha:1.000]];
    [tv setUserInteractionEnabled:NO];
    [tv registerClass:[TimerCell class] forCellReuseIdentifier:NSStringFromClass(TimerCell.class)];
    [self.view addSubview:tv];
    tv.delegate = self;
    tv.dataSource = self;

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
        UILabel *label = [[UILabel alloc] initWithFrame:mapLabelFrame];
        label.text = map;
        label.tag = [mapNames indexOfObject:map];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [self colorForMapIndex:(MapIdentifier)label.tag];
        label.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap:)];
        [label addGestureRecognizer:tap];

        [self.view insertSubview:label belowSubview:lastLabel ? lastLabel : self.view];
        [maps addObject:label];
        lastLabel = label;
    }
    currentLabel = maps.firstObject;

    [TimerManager defaultManager].delegate = self;
    [[TimerManager defaultManager] setupTimersForMap:self.currentMap];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [TimerManager defaultManager].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TimerCell.class) forIndexPath:indexPath];

    cell.package = [[TimerManager defaultManager].timers objectAtIndex:indexPath.row];
    cell.backgroundView = nil;
    cell.backgroundColor = [self colorForMapIndex:self.currentMap];
    //TODO: Create weapon images
    [cell layoutSubviews];

    return cell;
}

- (void)timersDidRefreshAtIndex:(NSUInteger)index {
    id oldPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSArray *timers = [TimerManager defaultManager].timers;
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:4];

    for (TimerPackage *pack in timers)
        if (pack.isNew)
            [paths addObject:[NSIndexPath indexPathForRow:[timers indexOfObject:pack] inSection:0]];

    [tv beginUpdates];
    [tv deleteRowsAtIndexPaths:@[oldPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tv insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationRight];
    [tv endUpdates];
}

- (void)tick {
    for (TimerCell *cell in [tv visibleCells])
        [cell decrementTimer];
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
        case Wizard: return [UIColor colorWithRed:0.895 green:0.903 blue:0.657 alpha:1.000];
    }
    return [UIColor clearColor];
}

- (void)onstart:(UIButton *)button {
    if (button.state == UIControlStateHighlighted) {
        [[TimerManager defaultManager] start];

        [button setSelected:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else if (button.state == (UIControlStateHighlighted | UIControlStateSelected)) {
        [[TimerManager defaultManager] stop];

        [tv reloadData];
        [button setSelected:NO];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
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
                label.frame = mapLabelFrame;
        }];

        [[TimerManager defaultManager] setupTimersForMap:self.currentMap];
        [tv reloadData];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *label in maps)
                label.center = CGPointMake(label.center.x, (label.frame.size.height * 1.1) * (label.tag + 1));
        }];
    }
}

- (MapIdentifier)currentMap {
    return (MapIdentifier)currentLabel.tag;
}

- (BOOL)mapListIsExpanded {
    return !CGRectEqualToRect(currentLabel.frame, mapLabelFrame);
}

@end