#import "main.h"
@import UIKit.UIImageView;

@implementation TimerCell

- (void)layoutSubviews {
////// image views
    _primWpnImgView.frame = CGRectMake(0, 0, WeaponImageViewSize, WeaponImageViewSize);
    _primWpnImgView.center = CGPointMake(_primWpnImgView.center.x, self.superview.center.y);

    _subWpnImgView.frame = CGRectMake(WeaponImageViewSize+2, 0, WeaponImageViewSize, WeaponImageViewSize);
    _subWpnImgView.center = CGPointMake(_subWpnImgView.center.x, self.superview.center.y);

////// timer
    _timerLabel.frame = CGRectMake(UIScreenWidth-100.f, 0, 100.f, 50.f);
    _timerLabel.center = CGPointMake(_timerLabel.center.x, self.superview.center.y);
}

@end