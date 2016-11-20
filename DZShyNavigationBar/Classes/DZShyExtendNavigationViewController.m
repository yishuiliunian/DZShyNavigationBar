//
//  DZShyExtendNavigationViewController.m
//  Pods
//
//  Created by baidu on 2016/11/16.
//
//

#import "DZShyExtendNavigationViewController.h"
#import <objc/runtime.h>
#import "DZWeakProxy.h"
#import <DZProgrameDefines.h>
#import "DZInputViewController.h"

@interface UINavigationController ()
- (void) __viewWillLayoutSubviews;
@end

@interface DZShyExtendNavigationViewController ()
@end

static const char* kDZContainterShy = &kDZContainterShy;
static const char* kDZResetContainerView = &kDZResetContainerView;
static const char* kDZLocalResetingFrame = &kDZLocalResetingFrame;

@implementation DZShyExtendNavigationViewController

- (void) setResetContainerView:(UIView *)resetContainerView
{
    objc_setAssociatedObject(self, kDZResetContainerView, [[DZWeakProxy alloc] initWithTarget:resetContainerView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView*) resetContainerView
{
    return objc_getAssociatedObject(self, kDZResetContainerView);
}

- (void) setLocalResetingFrame:(BOOL)localResetingFrame
{
    objc_setAssociatedObject(self, kDZLocalResetingFrame, @(localResetingFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) containsShy
{
    NSNumber* containerShy = objc_getAssociatedObject(self, kDZContainterShy);
    if (!containerShy) {
        return NO;
    }
    return [containerShy boolValue];
}
- (void) __viewWillLayoutSubviews
{
    if (self.resetContainerView) {
        CGRect frame = self.resetContainerView.frame;
        [super __viewWillLayoutSubviews];
        self.resetContainerView.frame = frame;
        [self.resetContainerView forceLayoutSubviews];
    } else {
        [super __viewWillLayoutSubviews];
    }
}

@end
