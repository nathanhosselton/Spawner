#import <Foundation/Foundation.h>
#import "main.h"
@import UIKit.UITableView;
@import UIKit.UIButton;
@import UIKit.UIScreen;
@import UIKit.UITapGestureRecognizer;

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation RootViewController {
    UILabel *mapNameLabel;
    UIButton *start;
    UITableView *tv;
    NSMutableArray *timers;
    NSMutableArray *labels;
    CGFloat mapLabelHeight;
    CGFloat mapLabelWidth;
    CGRect mapLabelFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//////
    mapLabelHeight = 50.f;
    mapLabelWidth = UIScreenWidth*(2.f/3.f);
    CGFloat lx = (UIScreenWidth - mapLabelWidth)/2;
    mapLabelFrame = CGRectMake(lx, mapLabelHeight, mapLabelWidth, mapLabelHeight);

////// button
    [self.view addSubview:start = [UIButton buttonWithType:UIButtonTypeCustom]];
    [start setFrame:CGRectMake(0, mapLabelHeight*3, 100.f, 50.f)];
    [start setCenter:CGPointMake(self.view.center.x, start.center.y)];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start setTitle:@"Stop" forState:UIControlStateSelected];
    [start addTarget:self action:@selector(onstart:) forControlEvents:UIControlEventTouchUpInside];

////// map picker
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap:)];
    NSArray *mapNames = [NSArray arrayWithObjects: @"Battle Creek",
                                                   @"Chill Out",
                                                   @"Damnation",
                                                   @"Derelict",
                                                   @"Hang 'Em High",
                                                   @"Longest",
                                                   @"Prisoner",
                                                   @"Rat Race",
                                                   @"Wizard", nil];
    labels = [NSMutableArray arrayWithCapacity:mapNames.count];
    for (NSString *map in mapNames) {
        UILabel *label = [[UILabel alloc] initWithFrame:mapLabelFrame];
        [label setCenter:CGPointMake(self.view.center.x, label.center.y)];
        label.text = map;
        label.tag = [mapNames indexOfObject:map];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[self colorForMapIndex:label.tag]];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];

        [self.view addSubview:label];
        [labels addObject:label];
    }
    self.currentMap = ((UILabel *)labels.firstObject).tag;

////// table
    CGFloat ty = mapLabelHeight*5;
    CGRect trect = CGRectMake(0, ty, UIScreenWidth, UIScreenHeight-ty);
    tv = [[UITableView alloc] initWithFrame:trect style:UITableViewStylePlain];
    [tv setBackgroundView:nil];
    [tv setBackgroundColor:[UIColor clearColor]];
    [tv registerClass:[TimerCell class] forCellReuseIdentifier:NSStringFromClass(TimerCell.class)];
    [self.view addSubview:tv];
    tv.delegate = self;
    tv.dataSource = self;

//////
    timers = [NSMutableArray arrayWithCapacity:4];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return timers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TimerCell.class) forIndexPath:indexPath];

    cell.thetimer = [timers objectAtIndex:indexPath.row];
    [cell setBackgroundView:nil];
    [cell setBackgroundColor:[self colorForMapIndex:_currentMap]];
    //TODO: Create weapon images
    [cell layoutSubviews];

    return cell;
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
    NSLog(@"%u", button.state);
    if (button.state == UIControlStateNormal) {
        // Start timers

        [button setSelected:YES];
    } else if (button.state == UIControlStateSelected) {
        // Stop timers

        [button setSelected:NO];
    }
}

- (void)ontap:(UILabel *)label {
    NSLog(@"Tapped");
}

@end
