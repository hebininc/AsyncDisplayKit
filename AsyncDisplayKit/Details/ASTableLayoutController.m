//
//  ASTableLayoutController.m
//  AsyncDisplayKit
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import <AsyncDisplayKit/ASTableLayoutController.h>

#import <UIKit/UIKit.h>

#import <AsyncDisplayKit/ASAssert.h>

@interface ASTableLayoutController()
@end

@implementation ASTableLayoutController

- (instancetype)initWithTableView:(UITableView *)tableView
{
  if (!(self = [super init])) {
    return nil;
  }
  _tableView = tableView;
  return self;
}

#pragma mark - Visible Indices

/**
 * IndexPath array for the element in the working range.
 */
- (void)indexPathsForScrolling:(ASScrollDirection)scrollDirection rangeMode:(ASLayoutRangeMode)rangeMode visibleIndexPaths:(out NSSet<NSIndexPath *> *__autoreleasing  _Nullable *)outVisible displayIndexPaths:(out NSSet<NSIndexPath *> *__autoreleasing  _Nullable *)outDisplay preloadIndexPaths:(out NSSet<NSIndexPath *> *__autoreleasing  _Nullable *)outPreload
{
  *outDisplay = [self indexPathsForScrolling:scrollDirection rangeMode:rangeMode rangeType:ASLayoutRangeTypeDisplay];
  *outVisible = [self indexPathsForScrolling:scrollDirection rangeMode:rangeMode rangeType:ASLayoutRangeTypeVisible];
  *outPreload = [self indexPathsForScrolling:scrollDirection rangeMode:rangeMode rangeType:ASLayoutRangeTypePreload];
#if ASDISPLAYNODE_ASSERTIONS_ENABLED
  for (NSIndexPath *indexPath in *outVisible) {
    ASDisplayNodeAssertNotNil([_tableView cellForRowAtIndexPath:indexPath], @"Cell should be visible but isn't.");
  }
#endif
}

- (NSSet *)indexPathsForScrolling:(ASScrollDirection)scrollDirection rangeMode:(ASLayoutRangeMode)rangeMode rangeType:(ASLayoutRangeType)rangeType
{
  ASDisplayNodeAssertMainThread();

  CGRect visibleRect = self.tableView.bounds;
  ASRangeTuningParameters params = [self tuningParametersForRangeMode:rangeMode rangeType:rangeType];
  CGRect rangeBounds = CGRectExpandToRangeWithScrollableDirections(visibleRect, params, ASScrollDirectionVerticalDirections, scrollDirection);
  return [NSSet setWithArray:[_tableView indexPathsForRowsInRect:rangeBounds]];
}

@end
