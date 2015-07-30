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
    
    for (int i = 0; i != 3; i++) {
        
        AnchorItem *item = [[AnchorItem alloc] init];
        item.xValue = i + 1;
        item.y1Value = 1 + rand() % 5 + 10;
        item.y2Value = 1 + rand() % 5;
        item.dicDataSource = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f,%f", item.xValue, item.y1Value] forKey:@"value"];
        [self.dataSourceAry addObject:item];
    }
    
    CGRect rect = CGRectMake(5, 40,
                             self.view.frame.size.width - 5 - 5,
                             300);
    
    self.lineChartView = [[LineChartView alloc] initWithFrame:rect];
    self.lineChartView.isEnableUserAction = YES;
    self.lineChartView.isScaleToView = NO;
    self.lineChartView.isShowTipLine = NO;
    self.lineChartView.xLineCount = 10;
    self.lineChartView.yLineCount = 10;
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
    
    [self.lineChartView updateViewWithFrame:rect];

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
