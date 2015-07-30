//
//  LineChartContentView.m
//  LineGraphicTest
//
//  Created by yehengjia on 2015/3/27.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import "LineChartView.h"
#import "ChartCommon.h"
#import "Constants.h"

@interface LineChartView()

@property (nonatomic, strong) NSMutableArray *anchorAry;

@property (nonatomic, strong) NSMutableArray *xArray;
@property (nonatomic, strong) NSMutableArray *y1Array;
@property (nonatomic, strong) NSMutableArray *y2Array;

//! 產生 X/Y軸刻度
-(void) buildAxisStepByDataSource;

@end

@implementation LineChartView

#if !__has_feature(objc_arc)
-(void) dealloc
{
    OBJC_RELEASE(self.anchorAry);
    OBJC_RELEASE(self.xArray);
    OBJC_RELEASE(self.y1Array);
    OBJC_RELEASE(self.y2Array);
    
    [super dealloc];
}
#endif

-(id) initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) ) {
        
        [self setBackgroundColor:[UIColor greenColor]];
        
        self.anchorAry = [NSMutableArray array];
        self.xArray = [NSMutableArray array];
        self.y1Array = [NSMutableArray array];
        self.y2Array = [NSMutableArray array];
    }
    
    return self;
}

-(void) setDataSource:(NSArray *) dataSource
{
    self.dataSourceAry = dataSource;
    
    [self updateAndRestViewWithFrame:self.frame];
    
    [self buildAxisStepByDataSource];
}

-(void) updateViewWithFrame:(CGRect) frame
{
    self.frame = frame;
    
    [self updateAndRestViewWithFrame:self.frame];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    CGContextRef context = UIGraphicsGetCurrentContext();
    
#pragma mark 畫點, 連接線, 指示線
    
    CGPoint startAnchorPoint1 = self.originPoint;
    CGPoint endAnchorPoint1 = self.originPoint;
    
    CGPoint startAnchorPoint2 = self.originPoint;
    CGPoint endAnchorPoint2 = self.originPoint;
    
    NSInteger anchorRadius = 3;

    if (self.anchorAry != nil) {
        
        for (AnchorView *anchor in self.anchorAry) {
            
            if ([anchor isKindOfClass:[UIView class]]) {
                
                [anchor removeFromSuperview];
            }
        }
        
        [self.anchorAry removeAllObjects];
    }

    
    for (int i = 0; i != [self.dataSourceAry count]; i++) {
        
        AnchorItem *startItem = [self.dataSourceAry objectAtIndex:i];
        
        float xPerStepVal = [[self.xArray objectAtIndex:0] floatValue];
        float y1PerStepVal = [[self.y1Array objectAtIndex:0] floatValue];

        startAnchorPoint1.x = self.originPoint.x + ((self.xPerStepWidth * startItem.xValue) / xPerStepVal) + self.contentScroll.x;
        startAnchorPoint1.y = self.originPoint.y + fabs(((self.yPerStepHeight * startItem.y1Value) / y1PerStepVal)) + self.contentScroll.y;
        
        //! 畫點, 範圍區塊內才畫
        if ((startAnchorPoint1.x >= self.originPoint.x && startAnchorPoint1.x <= self.rightBottomPoint.x) &&
            (startAnchorPoint1.y >= self.originPoint.y && startAnchorPoint1.y <= self.rightTopPoint.y)) {
        
            AnchorView *anchor = nil;
            
#if !__has_feature(objc_arc)
            anchor = [[[AnchorView alloc] initWithFrame:CGRectMake(0, 0, anchorRadius * 2, anchorRadius * 2)] autorelease];
#else
            anchor = [[AnchorView alloc] initWithFrame:CGRectMake(0, 0, anchorRadius * 2, anchorRadius * 2)];
#endif
            if (anchor != nil) {
            
                anchor.center = CGPointMake(startAnchorPoint1.x, startAnchorPoint1.y);
                anchor.anchorDelegate = self;
                anchor.dicDataSource = startItem.dicDataSource;
                anchor.anchorColor = [UIColor redColor];
                [self.anchorAry addObject:anchor];
                
                [self addSubview:anchor];
            }
        }
        
        float y2PerStepVal = [[self.y2Array objectAtIndex:0] floatValue];
        
        startAnchorPoint2.x = self.originPoint.x + ((self.xPerStepWidth * startItem.xValue) / xPerStepVal) + self.contentScroll.x;
        startAnchorPoint2.y = self.originPoint.y + fabs(((self.yPerStepHeight * startItem.y2Value) / y2PerStepVal)) + self.contentScroll.y;

        //! 畫點, 範圍區塊內才畫
        if ((startAnchorPoint2.x >= self.originPoint.x && startAnchorPoint2.x <= self.rightBottomPoint.x) &&
            (startAnchorPoint2.y >= self.originPoint.y && startAnchorPoint2.y <= self.rightTopPoint.y)) {
            
            AnchorView *anchor = nil;
            
#if !__has_feature(objc_arc)
            anchor = [[[AnchorView alloc] initWithFrame:CGRectMake(0, 0, anchorRadius * 2, anchorRadius * 2)] autorelease];
#else
            anchor = [[AnchorView alloc] initWithFrame:CGRectMake(0, 0, anchorRadius * 2, anchorRadius * 2)];
#endif
            if (anchor != nil) {
                
                anchor.center = CGPointMake(startAnchorPoint2.x, startAnchorPoint2.y);
                anchor.anchorDelegate = self;
                anchor.dicDataSource = startItem.dicDataSource;
                anchor.anchorColor = [UIColor orangeColor];
                [self.anchorAry addObject:anchor];
                
                [self addSubview:anchor];
            }
        }
        
        //! 畫點對點連接線及指示線
        if (i + 1 < [self.dataSourceAry count]) {
            
            AnchorItem *endItem = [self.dataSourceAry objectAtIndex:i + 1];
            
            float xPerStepVal = [[self.xArray objectAtIndex:0] floatValue];
            float xPosition = self.originPoint.x + ((self.xPerStepWidth * endItem.xValue) / xPerStepVal) + self.contentScroll.x;
            
            float y1PerStepVal = [[self.y1Array objectAtIndex:0] floatValue];
            float y1Position = self.originPoint.y + fabs(((self.yPerStepHeight * endItem.y1Value) / y1PerStepVal)) + self.contentScroll.y;
            
            float y2PerStepVal = [[self.y2Array objectAtIndex:0] floatValue];
            float y2Position = self.originPoint.y + fabs(((self.yPerStepHeight * endItem.y2Value) / y2PerStepVal)) + self.contentScroll.y;
            
            endAnchorPoint1.x = xPosition;
            endAnchorPoint1.y = y1Position;
            
            endAnchorPoint2.x = xPosition;
            endAnchorPoint2.y = y2Position;
            
            //! 範圍區塊內才畫
            if ((endAnchorPoint1.x >= self.originPoint.x && endAnchorPoint1.x <= self.rightBottomPoint.x) &&
                (endAnchorPoint1.y >= self.originPoint.y && endAnchorPoint1.y <= self.rightTopPoint.y)) {

                CGFloat yPattern[1]= {1};
                CGContextSetLineDash(context, 0.0, yPattern, 0);
                
                [ChartCommon drawLine:context
                           startPoint:startAnchorPoint1
                             endPoint:endAnchorPoint1
                            lineColor:[UIColor orangeColor] width:1.0f];
            }
            
            //! 範圍區塊內才畫
            if ((endAnchorPoint2.x >= self.originPoint.x && endAnchorPoint2.x <= self.rightBottomPoint.x) &&
                (endAnchorPoint2.y >= self.originPoint.y && endAnchorPoint2.y <= self.rightTopPoint.y)) {
                
                CGFloat yPattern[1]= {1};
                CGContextSetLineDash(context, 0.0, yPattern, 0);
                
                [ChartCommon drawLine:context
                           startPoint:startAnchorPoint2
                             endPoint:endAnchorPoint2
                            lineColor:[UIColor redColor] width:1.0f];
            }
/*
            if(self.isShowTipLine == YES) {
                
                CGPoint tipPoint = CGPointMake(0, 0);
                
                //! 指示線
                if (startAnchorPoint.x <= self.tapLocation.x && endAnchorPoint.x >= self.tapLocation.x) {
                    
                    if (fabs(startAnchorPoint.x - self.tapLocation.x) <= fabs(endAnchorPoint.x - self.tapLocation.x) ) {
                        
                        tipPoint = startAnchorPoint;
                    }
                    else {
                    
                        tipPoint = endAnchorPoint;
                    }
                    
                    CGFloat yPattern[1]= {1};
                    CGContextSetLineDash(context, 0.0, yPattern, 0);
                    
                    //! 橫線
                    [ChartCommon drawLine:context
                               startPoint:CGPointMake(self.originPoint.x, tipPoint.y)
                                 endPoint:CGPointMake(self.rightBottomPoint.x, tipPoint.y)
                                lineColor:[UIColor whiteColor] width:2.0f];
                    
                    //! 豎線
                    [ChartCommon drawLine:context
                               startPoint:CGPointMake(tipPoint.x, tipPoint.y)
                                 endPoint:CGPointMake(tipPoint.x, self.originPoint.y)
                                lineColor:[UIColor whiteColor] width:2.0f];
                }
            }
 */
        }
    }

#pragma mark rectangle(超出軸線部分用方塊蓋掉)
    
    [ChartCommon drawRect:context rect:CGRectMake(0, 0, self.originPoint.x, self.originPoint.y) lineColor:[UIColor clearColor] fillColor:[UIColor greenColor]];

    [ChartCommon drawRect:context rect:CGRectMake(self.originPoint.x, self.originPoint.y, self.rightBottomPoint.x, self.rightBottomPoint.y) lineColor:[UIColor clearColor] fillColor:[UIColor greenColor]];
    
 
    //! 畫虛線
#pragma mark 畫 Y 軸上 X 軸(虛)線
    
    
    if (self.drawLineTypeOfX == LineDrawTypeDashLine ||
        self.drawLineTypeOfX == LineDrawTypeNone) {
        
        CGFloat xPattern[1]= {1};
        CGContextSetLineDash(context, 0.0, xPattern, 0);
    }
    else if(self.drawLineTypeOfX == LineDrawTypeDottedLine) {
        
        CGFloat xPattern[2]= {6.0, 5};
        CGContextSetLineDash(context, 0.0, xPattern, 2);
    }
    
    NSInteger count = 0;
    
    for (NSInteger i = 0; i < [self.y1Array count]; i++) {
        
        CGFloat yPosition = self.originPoint.y + (i + 1) * self.yPerStepHeight + self.contentScroll.y;
        
        //! 範圍區塊內才畫
        if (yPosition > self.originPoint.y && ABS(yPosition - self.originPoint.y) <= self.frame.size.height) {
            
            count++;
            if (self.drawLineTypeOfX == LineDrawTypeNone) {
            
                //! 劃線
                [ChartCommon drawLine:context
                           startPoint:CGPointMake(self.originPoint.x, yPosition)
                             endPoint:CGPointMake(self.originPoint.x + 5, yPosition)
                            lineColor:[UIColor blackColor] width:0.1f];
                
            }
            
            else {
                //! 劃線
                [ChartCommon drawLine:context
                           startPoint:CGPointMake(self.originPoint.x, yPosition)
                             endPoint:CGPointMake(self.rightBottomPoint.x, yPosition)
                            lineColor:[UIColor blackColor] width:0.1f];
            }
            
            
            //! 顯示文字
            NSString *valStr = [NSString stringWithFormat:@"%.2lf", [self.y1Array[i] floatValue]];
            CGSize size = [valStr sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [[UIColor colorWithCGColor:[UIColor blackColor].CGColor] set];
            CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
            const char *str = [valStr cStringUsingEncoding:NSUTF8StringEncoding];
            CGContextShowTextAtPoint(context, 5, yPosition - (size.height / 2 - size.height / 4), str, strlen(str));
        }
    }
    NSLog(@"count = %ld", count);
    
#pragma mark 畫 X 軸上 Y 軸(虛)線數量

    for (NSInteger i = 0; i < [self.xArray count]; i++) {
        
        CGFloat xPosition = self.originPoint.x + (i + 1) * self.xPerStepWidth + self.contentScroll.x;
        
        //! 範圍區塊內才畫
        if (xPosition > self.originPoint.x && ABS(xPosition - self.originPoint.x) <= self.frame.size.width) {
            
            if (self.drawLineTypeOfY == LineDrawTypeNone) {
                
                [ChartCommon drawLine:context
                           startPoint:CGPointMake(xPosition, self.originPoint.y)
                             endPoint:CGPointMake(xPosition, self.originPoint.y - 5)
                            lineColor:[UIColor blackColor] width:0.1f];
            }
            else {
                
                [ChartCommon drawLine:context
                           startPoint:CGPointMake(xPosition, self.originPoint.y)
                             endPoint:CGPointMake(xPosition, self.leftTopPoint.y)
                            lineColor:[UIColor blackColor] width:0.1f];
            }
            //! 顯示文字
            NSString *valStr = [NSString stringWithFormat:@"%.0lf", [self.xArray[i] floatValue]]; //四舍五入保留2位
            CGSize size = [valStr sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [[UIColor colorWithCGColor:[UIColor blackColor].CGColor] set];
            CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
            const char *str = [valStr cStringUsingEncoding:NSUTF8StringEncoding];
            CGContextShowTextAtPoint(context, xPosition - (size.width / 2 - size.width / 4), self.originPoint.y - 15, str, strlen(str));
        }
    }
    
#pragma mark 畫 X, Y軸
    
    CGFloat normal[1]={1};
    CGContextSetLineDash(context,0,normal,0); //! 畫實線

    //! X軸
    [ChartCommon drawLine:context startPoint:self.originPoint endPoint:self.rightBottomPoint lineColor:[UIColor blackColor] width:0.5f];

    //! 左Y軸
    [ChartCommon drawLine:context startPoint:self.originPoint endPoint:self.leftTopPoint lineColor:[UIColor blackColor] width:0.5f];
    
    /*
    if (self.isMultipleY == YES) {
        
        CGPoint rightYBottomPoint;
        CGPoint rightYTopPoint;
        
        if (self.rightBottomPoint.x > self.maxWidth) {
            
            rightYBottomPoint = CGPointMake(self.maxWidth, self.rightBottomPoint.y);
            rightYTopPoint = CGPointMake(self.maxWidth, 0);
        }
        else {
            
            rightYBottomPoint = CGPointMake(self.rightBottomPoint.x - 5, self.rightBottomPoint.y);
            rightYTopPoint = CGPointMake(self.rightBottomPoint.x - 5, 0);
        }
        //! 右Y軸
        [ChartCommon drawLine:context startPoint:rightYBottomPoint endPoint:rightYTopPoint lineColor:[UIColor blackColor] width:0.5f];
    }
     */
}

#pragma mark - Custom methods

//! 產生 X/Y軸刻度
-(void) buildAxisStepByDataSource
{
    if (self.dataSourceAry.count >= 2) {
 
        float xMin, xMax, y1Min, y1Max, y2Min, y2Max;
        float yMin, yMax;
        
        AnchorItem *item = [self.dataSourceAry objectAtIndex:0];
        xMin = item.xValue; xMax = item.xValue;
        y1Min = item.y1Value; yMax = item.y1Value;
        y2Min = item.y2Value; yMax = item.y2Value;
        
        for (NSInteger i = 1; i < self.dataSourceAry.count; i++) {
            
            AnchorItem *item = [self.dataSourceAry objectAtIndex:i];
            
            if (item.xValue < xMin) {
            
                xMin = item.xValue;
            }
            else if (item.xValue > xMax) {
            
                xMax = item.xValue;
            }
            
            if (item.y1Value < y1Min) {
            
                y1Min = item.y1Value;
            }
            else if (item.y1Value > yMax) {
            
                yMax = item.y1Value;
            }
            
            if (item.y2Value < y2Min) {
            
                y2Min = item.y2Value;
            }
            else if (item.y2Value > yMax) {
            
                yMax = item.y2Value;
            }
        }
        
        //! x 軸刻度
        if (!self.xArray) {
        
            self.xArray = [NSMutableArray array];
        }
        else {
        
            [self.xArray removeAllObjects];
        }
        
        self.xPreStepValue = xMax / self.xLineCount;
        
        for (int i = 0; i != self.xLineCount; i++) {
            
            [self.xArray addObject:[NSNumber numberWithFloat: (self.xPreStepValue + i * self.xPreStepValue)]];
        }
        
        //! y1軸刻度
        if (!self.y1Array) {
        
            self.y1Array = [NSMutableArray array];
        }
        else {
        
            [self.y1Array removeAllObjects];
        }
        
        self.y1PreStepValue = yMax / self.yLineCount;
        
        for (int i = 0; i != self.yLineCount; i++) {
            
            [self.y1Array addObject:[NSNumber numberWithFloat: (self.y1PreStepValue + i * self.y1PreStepValue)]];
        }
        
        //! y2軸刻度
        if (!self.y2Array) {
            
            self.y2Array = [NSMutableArray array];
        }
        else {
            
            [self.y2Array removeAllObjects];
        }
        
        self.y2PreStepValue = yMax / self.yLineCount;
        
        for (int i = 0; i != self.yLineCount; i++) {
            
            [self.y2Array addObject:[NSNumber numberWithFloat: (self.y2PreStepValue + i * self.y2PreStepValue)]];
        }
    }
}


#pragma mark - anchor event

-(void) didSelectAnchorPoint:(NSDictionary *)dicDataSource
{
    NSLog(@"%@", [dicDataSource valueForKey:@"value"]);
}

@end
