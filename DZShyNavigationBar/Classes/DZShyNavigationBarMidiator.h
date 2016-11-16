//
//  DZShyNavigationBarMidiator.h
//  Pods
//
//  Created by baidu on 2016/11/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DZViewControllerLifeCircleAction/DZViewControllerLifeCircleAction.h>
@class DZShyExtendNavigationAction;
@interface DZShyNavigationBarMidiator : DZViewControllerLifeCircleBaseAction <UIScrollViewDelegate>
@property (nonatomic, weak, readonly) UIScrollView* scrollView;
- (instancetype) initWithScrollView:(UIScrollView*)scrollView;
@end
