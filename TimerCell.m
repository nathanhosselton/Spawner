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

    if (count == 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [self.delegate timerDidReachZero:self];
        });
        return;
    }
}

@end