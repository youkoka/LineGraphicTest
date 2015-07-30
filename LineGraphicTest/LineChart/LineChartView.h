//
//  LineChartContentView.h
//  LineGraphicTest
//
//  Created by yehengjia on 2015/3/27.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnchorView.h"
#import "ChartBaseView.h"

@interface LineChartView : ChartBaseView<AnchorDelefate>

-(id) initWithFrame:(CGRect)frame;

-(void) setDataSource:(NSArray *) dataSource;

-(void) updateViewWithFrame:(CGRect) frame;

@end
