//
//  ViewController.m
//  LineGraphicTest
//
//  Created by yehengjia on 2015/3/27.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import "ViewController.h"

#import "LineChartView.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataSourceAry;

@property (nonatomic, strong) LineChartView *lineChartView;

@end

@implementation ViewController

#if !__has_feature(objc_arc)

-(void) dealloc
{
    OBJC_RELEASE(self.lineChartView);
    
    [super dealloc];
    
}

#endif
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSourceAry = [NSMutableArray array];
    
    for (int i = 0; i != 10; i++) {
        
        AnchorItem *item = [[AnchorItem alloc] init];
        item.xValue = 1 + i;
        item.y1Value = 31 + (rand() % 100) * 0.01;
        item.y2Value = 30 + (rand() % 100) * 0.01;
        [self.dataSourceAry addObject:item];
    }

    CGRect rect = CGRectMake(5, 40,
                             self.view.frame.size.width - 5 - 5,
                             300);
    
    NSArray *labelAry = [NSArray arrayWithObjects:@"1/1", @"2/1", @"3/1", @"4/1", @"5/1", nil];
    
    self.lineChartView = [[[LineChartView alloc] initWithFrame:rect] autorelease];
    self.lineChartView.drawLineTypeOfY = LineDrawTypeNone;
    self.lineChartView.drawLineTypeOfX = LineDrawTypeDottedLine;
    self.lineChartView.isEnableUserAction = YES;
    self.lineChartView.isScaleToView = YES;
    self.lineChartView.isShowTipLine = YES;
    self.lineChartView.isShowAnchorPoint = YES;
    self.lineChartView.xLineCount = 10;
    self.lineChartView.yLineCount = 10;
    self.lineChartView.backgroundColor = [UIColor blackColor];
    self.lineChartView.tipLineColor = [UIColor whiteColor];
    self.lineChartView.tipTextColor = [UIColor whiteColor];
    self.lineChartView.xAxisLineColor = [UIColor whiteColor];
    self.lineChartView.yAxisLineColor = [UIColor whiteColor];
    self.lineChartView.xLineColor = [UIColor whiteColor];
    self.lineChartView.yLineColor = [UIColor whiteColor];
    self.lineChartView.xTextColor = [UIColor whiteColor];
    self.lineChartView.yTextColor = [UIColor whiteColor];
    
//    self.lineChartView.lineLabelAry = labelAry;
    [self.lineChartView setDataSource:self.dataSourceAry];
    [self.view addSubview:self.lineChartView];
    
}

-(BOOL) shouldAutorotate
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect rect;
    
    switch (orientation) {
            
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            rect = CGRectMake(5, 40,
                              self.view.frame.size.width - 5 - 5,
                              300);
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            rect = CGRectMake(5, 10,
                              self.view.frame.size.width - 5 - 5,
                              300);
        }
            break;
        default:
            break;
    }
    
    [self.lineChartView resetViewByOrientationWithFrame:rect];

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
