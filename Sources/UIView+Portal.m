@import ObjectiveC.runtime;
@import UIKit.UIImageView;

@interface PortalManager : NSObject
+ (instancetype)defaultManager;
- (void)addViewToAnimate:(UIImageView *)view;
- (BOOL)isAnimatingView:(UIImageView *)view;
@end


@implementation UIView (Portal)

@dynamic portalImageView;
static void *AssociativeKey;

- (UIImageView *)portalImageView {
    return objc_getAssociatedObject(self, AssociativeKey);
}

- (void)setPortalImageView:(UIImageView *)portalImageView {
    objc_setAssociatedObject(self, AssociativeKey, portalImageView, OBJC_ASSOCIATION_RETAIN);
}

- (void)setPortalImage:(UIImage *)image {
    if (!self.portalImageView) {
        self.portalImageView = [[UIImageView alloc] initWithImage:image];
        self.portalImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self insertSubview:self.portalImageView atIndex:self.subviews.count];
    } else
        self.portalImageView.image = image;

//    if (![[PortalManager defaultManager] isAnimatingView:self.portalImageView])
//        [[PortalManager defaultManager] addViewToAnimate:self.portalImageView];
}

@end


@implementation PortalManager

static NSMutableArray *portals;

+ (instancetype)defaultManager {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        portals = [NSMutableArray new];
    });

    return _sharedInstance;
}

- (void)addViewToAnimate:(UIImageView *)view {
    [portals addObject:view];
}

- (BOOL)isAnimatingView:(UIImageView *)view {
    return [portals containsObject:view];
}

- (void)animate {
    for (UIImageView *view in portals) {
        [UIView animateWithDuration:10.f delay:0 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
            view.frame = CGRectMake(view.frame.size.width/2, 0, view.frame.size.width, view.frame.size.height);
        } completion:nil];
    }
}

@end