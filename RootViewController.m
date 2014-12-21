#import <Foundation/Foundation.h>
#import "main.h"
@import UIKit.UITableView;
@import UIKit.UITableViewCell;
@import UIKit.UILabel;
@import UIKit.UIButton;

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation RootViewController {
    UILabel *mapNameLabel;
    UIButton *start;
    UITableView *tableView;
    NSMutableArray *timers;
    MapPickerViewController *mv;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:start = [UIButton buttonWithType:UIButtonTypeCustom]];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start setTitle:@"Stop" forState:UIControlStateSelected];
    [start addTarget:self action:@selector(onstart:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:tableView = [UITableView new]];

    mv = [MapPickerViewController new];
    mv.mapNames = [NSArray arrayWithObjects: @"Battle Creek",
                   @"Chill Out",
                   @"Damnation",
                   @"Derelict",
                   @"Hang 'Em High",
                   @"Longest",
                   @"Prisoner",
                   @"Rat Race",
                   @"Wizard", nil];

    [self.view addSubview:mapNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.f)]];
    mapNameLabel.text = mv.mapNames.firstObject;
    mapNameLabel.userInteractionEnabled = YES;

    timers = [NSMutableArray arrayWithCapacity:4];
}

- (void)onstart:(UIButton *)button {
    if (button.state == UIControlStateNormal) {
        // Start timers

        [button setSelected:YES];
    } else if (button.state == UIControlStateSelected) {
        // Stop timers

        [button setSelected:NO];
    }
}

@end

@implementation MapPickerViewController {
    NSMutableArray *labels;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    labels = [NSMutableArray arrayWithCapacity:self.mapNames.count];
    for (NSString *map in self.mapNames)
        [labels addObject:[UILabel new].text = map];
}

@end
