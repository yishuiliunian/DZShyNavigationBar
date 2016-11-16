//
//  DZShyExtendScrollView.m
//  Pods
//
//  Created by baidu on 2016/11/16.
//
//

#import "DZShyExtendScrollView.h"
#import "DZDelegateMiddleProxy.h"
#import <objc/runtime.h>
#import "DZShyNavigationBarMidiator.h"
#import "MRLogicInjection.h"
#import "DZShyNavigationBarMidiator.h"

@interface DZShyExtendScrollView ()
@property (nonatomic, strong) DZDelegateMiddleProxy * dz_delegateProxy;
@property (nonatomic, strong) DZShyNavigationBarMidiator* shyMidiator;
@end

@implementation DZShyExtendScrollView

static const char* DZShyExtendDelegate = &DZShyExtendDelegate;

- (void) setDz_delegateProxy:(DZDelegateMiddleProxy *)dz_delegateProxy
{
    objc_setAssociatedObject(self, DZShyExtendDelegate, dz_delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DZDelegateMiddleProxy*) dz_delegateProxy
{
    return objc_getAssociatedObject(self, DZShyExtendDelegate);
}

static const char* DZShyExtendMidiator = &DZShyExtendMidiator;

- (void) setShyMidiator:(DZShyNavigationBarMidiator *)shyMidiator
{
    objc_setAssociatedObject(self, DZShyExtendMidiator, shyMidiator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DZShyNavigationBarMidiator*) shyMidiator
{
    return objc_getAssociatedObject(self, DZShyExtendMidiator);

}

- (void) setDelegate:(id<UIScrollViewDelegate>)delegate
{
    DZDelegateMiddleProxy* proxy = [[DZDelegateMiddleProxy alloc] initWithMiddleMan:self.shyMidiator];
    self.dz_delegateProxy = proxy;
    proxy.originalDelegate = delegate;
    [super setDelegate:proxy];
}


@end


DZShyExtendScrollView* DZExtendShyNavigationBar(UIScrollView* scroolView, UIViewController* vc)
{
    DZShyExtendScrollView* shyScrollView =  MRExtendInstanceLogicWithKey(scroolView, @"ShyNavigationBar", @[[DZShyExtendScrollView class]]);
    if (shyScrollView.delegate) {
        shyScrollView.delegate = shyScrollView.delegate;
    }

    DZShyNavigationBarMidiator* action = [[DZShyNavigationBarMidiator alloc] initWithScrollView:scroolView];
    action = [vc registerLifeCircleAction:action];
    [vc registerLifeCircleAction:action];
    shyScrollView.shyMidiator = action;
    return shyScrollView;
}

