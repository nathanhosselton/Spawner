#import <Foundation/Foundation.h>
#import "main.h"
@import UIKit.UITableView;
@import UIKit.UIButton;
@import UIKit.UIScreen;
@import UIKit.UITapGestureRecognizer;

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, TimerCellDelegate, TimerPackageDelegate>
@property BOOL shouldValidateTimers;
@end

@implementation RootViewController {
    UILabel *currentLabel;
    UITableView *tv;
    NSTimer *timer;
    NSMutableArray *timers;
    NSMutableArray *labels;
    CGRect mapLabelFrame;
}

@synthesize shouldValidateTimers = _shouldValidateTimers;

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
    labels = [NSMutableArray arrayWithCapacity:mapNames.count];
    UILabel *lastLabel;
    for (NSString *map in mapNames) {
        UILabel *label = [[UILabel alloc] initWithFrame:mapLabelFrame];
        label.center = CGPointMake(self.view.center.x, label.center.y);
        label.text = map;
        label.tag = [mapNames indexOfObject:map];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [self colorForMapIndex:(MapIdentifier)label.tag];
        label.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap:)];
        [label addGestureRecognizer:tap];

        [self.view insertSubview:label belowSubview:lastLabel ? lastLabel : self.view];
        [labels addObject:label];
        lastLabel = label;
    }
    self.currentMap = (MapIdentifier)((UILabel *)labels.firstObject).tag;
    currentLabel = labels.firstObject;

//////
    timers = [NSMutableArray arrayWithCapacity:4];
    [self setupTimers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return timers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TimerCell.class) forIndexPath:indexPath];

    cell.package = [timers objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.backgroundView = nil;
    cell.backgroundColor = [self colorForMapIndex:_currentMap];
    //TODO: Create weapon images
    [cell layoutSubviews];

    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return tableView.frame.size.height/timers.count;
//}

- (void)timerDidReachZero:(TimerCell *)cell {
    [tv beginUpdates];
    int oldcount = (int)timers.count;
    [timers removeObject:cell.package];

    for (NSNumber *weapon in cell.package.weapons) {
        TimerPackage *package = [TimerPackage packageforMap:self.currentMap weapon:weapon.intValue];
        package.delegate = self;
        [timers addObject:package];
    }
    [self validateTimers];

    if (timers.count > oldcount) {
        int dif = (int)timers.count - oldcount;
        for (int i = 0; i < dif; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:[tv indexPathForCell:cell].row+i inSection:[tv indexPathForCell:cell].section];
            [tv insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } else if (timers.count < oldcount)
        [tv deleteRowsAtIndexPaths:@[[tv indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationLeft];

    [tv reloadData];
    [tv endUpdates];}

- (void)timerPackageWasMerged:(TimerPackage *)oldPackage intoPackage:(TimerPackage *)package {
    self.shouldValidateTimers = YES;
}

- (void)setupTimers {
    [timers removeAllObjects];
    for (int i = 0; i <= sizeof(WeaponIdentifier); i++) {
        TimerPackage *package = [TimerPackage packageforMap:self.currentMap weapon:i];
        if (package) {
            package.delegate = self;
            [timers addObject:package];
        }
    }
    [self validateTimers];
    [tv reloadData];
}

- (void)validateTimers {
    [timers sortUsingSelector:@selector(comparePackage:)];
    for (TimerPackage *package in timers.copy)
        if (package.shouldExpire)
            [timers removeObject:package];
    if (self.shouldValidateTimers)
        [self validateTimers];
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
        for (UILabel *label in labels)
            label.userInteractionEnabled = NO;
        [button setSelected:YES];
    } else if (button.state == (UIControlStateHighlighted | UIControlStateSelected)) {
        [timer invalidate];
        [self setupTimers];
        for (UILabel *label in labels)
            label.userInteractionEnabled = YES;
        [button setSelected:NO];
    }
}

- (void)ontime:(NSTimer *)timer {
    for (TimerCell *cell in [tv visibleCells])
        [cell decrementTimer];
}

- (void)ontap:(UITapGestureRecognizer *)tap {
//    NSLog(@"%@ tapped", ((UILabel *)tap.view).text);
    if (self.mapListIsExpanded) {
        [self.view bringSubviewToFront:tap.view];
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *label in labels)
                label.frame = mapLabelFrame;
        }];
        self.currentMap = (MapIdentifier)tap.view.tag;
        currentLabel = (UILabel *)tap.view;
        [self setupTimers];
    } else {
        __block CGFloat y;
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *label in labels) {
                y = (label.frame.size.height*1.1)*(label.tag+1);
                label.center = CGPointMake(label.center.x, y);
            }
        }];
    }
}

- (BOOL)mapListIsExpanded {
    return !(CGRectEqualToRect(currentLabel.frame, mapLabelFrame));
}

- (BOOL)shouldValidateTimers {
    BOOL ret = _shouldValidateTimers;
    _shouldValidateTimers = NO;
    return ret;
}

- (void)setShouldValidateTimers:(BOOL)shouldValidateTimers {
    _shouldValidateTimers = shouldValidateTimers;
}

@end
