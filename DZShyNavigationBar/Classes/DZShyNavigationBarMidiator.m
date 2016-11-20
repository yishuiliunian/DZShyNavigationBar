//
//  DZShyNavigationBarMidiator.m
//  Pods
//
//  Created by baidu on 2016/11/16.
//
//

#import "DZShyNavigationBarMidiator.h"
#import <DZGeometryTools.h>
#import "DZShyExtendNavigationViewController.h"
#import "MRLogicInjection.h"

@interface UIViewController (DZShyContainer)
@property (nonatomic, strong, readonly) UIViewController* __containerViewController;
@end

@implementation UIViewController (DZShyContainer)

- (UIViewController*) __containerViewController
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return self;
    } else if (self.parentViewController) {
        return self.parentViewController.__containerViewController;
    } else {
        return nil;
    }
}

@end

@interface DZShyNavigationBarMidiator()
{
    CGFloat _previousOffSetY;
}
@property (nonatomic, assign, readonly) BOOL appearing;
@property (nonatomic, weak, readonly) UIViewController* hostViewController;
@property (nonatomic, weak, readonly) UINavigationController* currentNavigationController;
@property (nonatomic, weak, readonly) UIViewController* containerViewController;
@end
@implementation DZShyNavigationBarMidiator

- (void) dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    self.identifier = @"shy-navigation-bar";
    return self;
}
- (instancetype) initWithScrollView:(UIScrollView *)scrollView
{
    self = [self init];
    if (!self) {
        return self;
    }
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _previousOffSetY = NAN;
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == _scrollView && ([keyPath isEqualToString:@"contentSize"] || [keyPath isEqualToString:@"contentOffset"])) {
        if (self.appearing) {
            [self handleOffsetChanged];
        }
    }
}


- (void) handleOffsetChanged
{
    if (self.scrollView.contentOffset.y < 0) {
        return;
    }
    if (self.scrollView.contentOffset.y + CGRectGetHeight(self.scrollView.frame) > self.scrollView.contentSize.height) {
        return;
    }
    if (isnan(_previousOffSetY)) {
        _previousOffSetY = self.scrollView.contentOffset.y;
        return;
    }
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    CGFloat delta =_previousOffSetY - currentOffsetY;
    if (ABS(delta) < 0.00001) {
        return;
    }
    UINavigationBar* bar = self.currentNavigationController.navigationBar;
    CGFloat height = MAX(20, CGRectGetHeight(bar.frame)+delta);
    height = MIN(64, height);
    
    CGRect barRect;
    CGRect contentRect;
    
    CGRectDivide(self.currentNavigationController.view.bounds, &barRect, &contentRect, height, CGRectMinYEdge);
    bar.frame = barRect;
    self.containerViewController.view.frame = contentRect;
    _previousOffSetY = currentOffsetY;
}




#pragma View Controller Action
- (UIViewController*) containerViewController
{
    return _hostViewController.__containerViewController;
}
- (void) hostController:(UIViewController *)vc viewWillAppear:(BOOL)animated
{
    [super hostController:vc viewWillAppear:animated];
    _currentNavigationController = vc.navigationController;
    _hostViewController = vc;
    DZShyExtendNavigationViewController* controller = MRExtendInstanceLogicWithKey(self.currentNavigationController,@"shy-bar" ,@[DZShyExtendNavigationViewController.class]);
    controller.resetContainerView = self.containerViewController.view;
}
- (void) hostController:(UIViewController *)vc viewDidAppear:(BOOL)animated
{
    [super hostController:vc viewDidAppear:animated];
    _currentNavigationController = vc.navigationController;
    _hostViewController = vc;
    _appearing = YES;
    
}

- (void) hostController:(UIViewController *)vc viewWillDisappear:(BOOL)animated
{
    [super hostController:vc viewWillDisappear:animated];
    _currentNavigationController = vc.navigationController;
    _hostViewController = vc;
//    MRRemoveExtendSpecialLogic(self.currentNavigationController, @"shy-bar");
}

- (void) hostController:(UIViewController *)vc viewDidDisappear:(BOOL)animated
{
    [super hostController:vc viewDidDisappear:animated];
    _currentNavigationController = vc.navigationController;
    _hostViewController = vc;
    _appearing = NO;
    
}

@end
