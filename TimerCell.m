#import "main.h"
@import UIKit.UIImageView;

@implementation TimerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:_primWpnImgView = [UIImageView new]];
        [self addSubview:_subWpnImgView = [UIImageView new]];
        [self addSubview:_timerLabel = [TimerLabel new]];
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
    _timerLabel.text = self.time.stringValue;
}

@end