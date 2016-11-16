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

@interface UINavigationController ()
- (void) __viewWillLayoutSubviews;
@end

@interface DZShyExtendNavigationViewController ()
@property (nonatomic, assign) BOOL localResetingFrame;
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

- (BOOL) localResetingFrame
{
    return [objc_getAssociatedObject(self, kDZLocalResetingFrame) boolValue];
}
- (void) setContainsShy:(BOOL)containsShy
{
    objc_setAssociatedObject(self, kDZContainterShy, @(containsShy), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        if (!self.localResetingFrame) {
            [super __viewWillLayoutSubviews];
            self.localResetingFrame = YES;
        }
        self.resetContainerView.frame = frame;
        self.localResetingFrame  = NO;
    } else {
        [super __viewWillLayoutSubviews];
    }
}

@end
