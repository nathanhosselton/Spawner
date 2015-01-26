#import <Foundation/Foundation.h>
#import <YOLO.h>
#import "main.h"
@import UIKit.UITableView;
@import UIKit.UIButton;
@import UIKit.UIScreen;
@import UIKit.UITapGestureRecognizer;

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, TimerCellDelegate>
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
    CGFloat lx = (UIScreenWidth - mapLabelWidth)/2;
    mapLabelFrame = CGRectMake(lx, mapLabelHeight, mapLabelWidth, mapLabelHeight);

////// button
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setFrame:CGRectMake(0, mapLabelHeight*3, 100.f, 50.f)];
    [start setCenter:CGPointMake(self.view.center.x, start.center.y)];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start setTitle:@"Stop" forState:UIControlStateSelected];
    [start addTarget:self action:@selector(onstart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];

////// table
    CGFloat ty = mapLabelHeight*5;
    CGRect trect = CGRectMake(0, ty, UIScreenWidth, UIScreenHeight-ty);
    tv = [[UITableView alloc] initWithFrame:trect style:UITableViewStylePlain];
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

    [[TimerManager shared] setupTimersForMap:self.currentMap];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [TimerManager shared].timers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TimerCell.class) forIndexPath:indexPath];

    cell.package = [[TimerManager shared].timers objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.backgroundView = nil;
    cell.backgroundColor = [self colorForMapIndex:self.currentMap];
    //TODO: Create weapon images
    [cell layoutSubviews];

    return cell;
}

- (void)timerDidReachZero:(TimerCell *)cell {
    [tv beginUpdates];

    NSUInteger oldcount = [TimerManager shared].timers.count;

    [[TimerManager shared] newTimersFromExpiredTimer:cell.package];

    NSUInteger newcount = [TimerManager shared].timers.count;

    [tv deleteRowsAtIndexPaths:@[[tv indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationLeft];

    if (newcount >= oldcount) {
        NSUInteger dif = newcount - oldcount;
        for (NSUInteger i = 0; i < dif+1; i++) {
            NSUInteger row = [tv indexPathForCell:cell].row + i;
            id path = [NSIndexPath indexPathForRow:row inSection:0];
            [tv insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
        }
    }

    [tv endUpdates];
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
        timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(ontime:) userInfo:nil repeats:YES];
        for (UILabel *label in maps)
            label.userInteractionEnabled = NO;
        [button setSelected:YES];
    } else if (button.state == (UIControlStateHighlighted | UIControlStateSelected)) {
        [timer invalidate];
        [[TimerManager shared] setupTimersForMap:self.currentMap];
        for (UILabel *label in maps)
            label.userInteractionEnabled = YES;
        [button setSelected:NO];
    }
}

- (void)ontime:(NSTimer *)time {
    for (TimerCell *cell in [tv visibleCells].reverse)
        [cell decrementTimer];
}

- (void)ontap:(UITapGestureRecognizer *)tap {
//    NSLog(@"%@ tapped", ((UILabel *)tap.view).text);
    if (self.mapListIsExpanded) {
        [self.view bringSubviewToFront:tap.view];
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *label in maps)
                label.frame = mapLabelFrame;
        }];
        currentLabel = (UILabel *)tap.view;
        [[TimerManager shared] setupTimersForMap:self.currentMap];
        [tv reloadData];
    } else {
        __block CGFloat y;
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *label in maps) {
                y = (label.frame.size.height*1.1)*(label.tag+1);
                label.center = CGPointMake(label.center.x, y);
            }
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
