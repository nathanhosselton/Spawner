#import "main.h"
@import UIKit.UIImageView;

@implementation TimerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:_primWpnImgView = [UIImageView new]];
        [self addSubview:_subWpnImgView = [UIImageView new]];
        [self addSubview:_timerLabel = [UILabel new]];
    }
    return self;
}

- (void)layoutSubviews {
////// image views
    _primWpnImgView.frame = CGRectMake(0, 0, WeaponImageViewSize, WeaponImageViewSize);
//    _primWpnImgView.center = CGPointMake(_primWpnImgView.center.x, self.superview.center.y);

    _subWpnImgView.frame = CGRectMake(WeaponImageViewSize+2, 0, WeaponImageViewSize, WeaponImageViewSize);
//    _subWpnImgView.center = CGPointMake(_subWpnImgView.center.x, self.superview.center.y);

////// timer
    _timerLabel.frame = CGRectMake(UIScreenWidth-50.f, 0, 50.f, 20.f);
//    _timerLabel.center = CGPointMake(_timerLabel.center.x, self.center.y);
    _timerLabel.text = self.package.time.stringValue;
}

- (void)decrementTimer {
    int count = _timerLabel.text.intValue-1;
    self.package.time = @(count);
    _timerLabel.text = [NSString stringWithFormat:@"%d", count];

    switch (count) {
        case 30:
            for (NSNumber *weapon in self.package.weapons)
                [SPAnnounce weapon:weapon.intValue];
            [SPAnnounce:[NSString stringWithFormat:@"in %d seconds", count]];
            break;
        case 20:
        case 10:
        case 9:
        case 8:
        case 7:
        case 6:
        case 5:
        case 4:
        case 3:
        case 2:
        case 1:
            [SPAnnounce count:@(count)];
            break;
        case 0:
            [self.delegate timerDidReachZero:self];
            break;

        default:
            break;
    }
}

@end