//
//  ChartBaseView.m
//  LineGraphicTest
//
//  Created by yehengjia on 2015/7/23.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import "ChartBaseView.h"
#import "TipLineView.h"
#import "CommentView.h"

@interface ChartBaseView()

@property (nonatomic, strong) TipLineView *tipLineView;

//! 設定提示線參數
-(void) setTipLineViewConfigure;

//! 壓住不放事件
-(void) handleLongTap:(UIGestureRecognizer *) recongizer;

//! 移動事件
-(void) handlePan:(UIPanGestureRecognizer *)recognizer;

//! 縮放事件
-(void) handlePinch:(UIPinchGestureRecognizer*) recognizer;

@end

@implementation ChartBaseView

-(void) dealloc
{
    OBJC_RELEASE(self.dataSourceAry);
    OBJC_RELEASE(self.lineLabelAry);
    OBJC_RELEASE(self.tipLineView);
    OBJC_RELEASE(self.xArray);
    OBJC_RELEASE(self.y1Array);
    OBJC_RELEASE(self.y2Array);
    
    [super dealloc];
}

-(id) initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) ) {
        
        //! 將圓點設為左下角
        [self setTransform:CGAffineTransformMakeScale(1, -1)];
        
        //! (上, 左, 下, 右)
        _edgeInset = UIEdgeInsetsMake(40, 40, 20, 20);
        
        self.tipTextColor = [UIColor blackColor];
        self.tipLineColor = [UIColor grayColor];
        
        //! default value
        self.drawLineTypeOfX = LineDrawTypeDottedLine;
        self.drawLineTypeOfY = LineDrawTypeDottedLine;
        self.isMultipleY = NO;
        self.isShowTipLine = NO;
        self.isEnableUserAction = NO;
        self.isScaleToView = NO;
        self.isShowAnchorPoint = NO;
        
        self.xLineCount = 5;
        self.yLineCount = 5;
        
        self.zoomScale = 1;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.dataSourceAry = [NSArray array];
        self.lineLabelAry = [NSArray array];
        
        self.xArray = [NSMutableArray array];
        self.y1Array = [NSMutableArray array];
        self.y2Array = [NSMutableArray array];

        self.tipLineView = [[[TipLineView alloc] init] autorelease];
        self.tipLineView.tipLineColor = self.tipLineColor;
        self.tipLineView.tipTextColor = self.tipTextColor;
        
        [self addSubview:self.tipLineView];

        //! 壓住不放事件
        UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
        [self addGestureRecognizer:longGestureRecognizer];
        [longGestureRecognizer release];
        
        //! 移動事件
        UIPanGestureRecognizer *panGestureRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGestureRecongnizer];
        [UIPanGestureRecognizer release];
        
        //! 縮放事件
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
        [pinchGestureRecognizer release];
    }
    
    return self;
}

//! 依據畫面大小更新相關點的資訊
-(void) updateViewWithFrame:(CGRect)frame
{
    self.frame = frame;
    _contentScroll = CGPointMake(0, 0);
    
    _originPoint = CGPointMake(_edgeInset.left, _edgeInset.bottom);
    _leftTopPoint = CGPointMake(_edgeInset.left, self.frame.size.height - _edgeInset.top);
    _rightBottomPoint = CGPointMake(self.frame.size.width - _edgeInset.right, _edgeInset.bottom);
    _rightTopPoint = CGPointMake(self.frame.size.width - _edgeInset.right, self.frame.size.height - _edgeInset.top);
    
    self.drawOriginContentWidth = self.frame.size.width - (_edgeInset.left + _edgeInset.right);
    self.drawOriginContentHeight = self.frame.size.height - (_edgeInset.bottom + _edgeInset.top);
    
    //! 僅縮放x軸
    self.drawContentWidth = self.drawOriginContentWidth * self.zoomScale;
    self.drawContentHeight = self.drawOriginContentHeight;
    
    //! +1 : 最右/上多一格
    self.xDrawLineCount = self.xLineCount; //+ 1;
    self.yDrawLineCount = self.yLineCount; //+ 1;
    
    _xPerStepWidth = self.drawContentWidth / self.xDrawLineCount;
    _yPerStepHeight = self.drawContentHeight / self.yDrawLineCount;
    
    [self setTipLineViewConfigure];
    
    [self setNeedsDisplay];
}

//! 依據畫面大小重設相關點的資訊
-(void) resetViewWithFrame:(CGRect)frame
{
    self.frame = frame;
    
    self.zoomScale = 1;
    _contentScroll = CGPointMake(0, 0);
    
    _originPoint = CGPointMake(_edgeInset.left, _edgeInset.bottom);
    _leftTopPoint = CGPointMake(_edgeInset.left, self.frame.size.height - _edgeInset.top);
    _rightBottomPoint = CGPointMake(self.frame.size.width - _edgeInset.right, _edgeInset.bottom);
    _rightTopPoint = CGPointMake(self.frame.size.width - _edgeInset.right, self.frame.size.height - _edgeInset.top);
    
    self.drawOriginContentWidth = self.frame.size.width - (_edgeInset.left + _edgeInset.right);
    self.drawOriginContentHeight = self.frame.size.height - (_edgeInset.bottom + _edgeInset.top);
    
    //! 僅縮放x軸
    self.drawContentWidth = self.drawOriginContentWidth * self.zoomScale;
    self.drawContentHeight = self.drawOriginContentHeight;
    
    //! +1 : 最右/上多一格
    self.xDrawLineCount = self.xLineCount; //+ 1;
    self.yDrawLineCount = self.yLineCount; //+ 1;
    
    _xPerStepWidth = self.drawContentWidth / self.xDrawLineCount;
    _yPerStepHeight = self.drawContentHeight / self.yDrawLineCount;
    
    [self setTipLineViewConfigure];
    
    [self setNeedsDisplay];
}

//! 設定提示線參數
-(void) setTipLineViewConfigure
{
    self.tipLineView.xPerStepWidth = _xPerStepWidth;
    self.tipLineView.yPerStepHeight = _yPerStepHeight;
    self.tipLineView.contentScroll = _contentScroll;
    self.tipLineView.xArray = self.xArray;
    self.tipLineView.y1Array = self.y1Array;
    self.tipLineView.y2Array = self.y2Array;
    self.tipLineView.dataSourceAry = self.dataSourceAry;
    self.tipLineView.edgeInset = _edgeInset;
    
    self.tipLineView.frame = CGRectMake(_edgeInset.left, _edgeInset.bottom, (self.frame.size.width - _edgeInset.right - _edgeInset.left), (self.frame.size.height - _edgeInset.top - _edgeInset.bottom));

}

- (void)drawRect:(CGRect)rect {

    self.tipLineView.tipLineColor = self.tipLineColor;
    self.tipLineView.tipTextColor = self.tipTextColor;
}
#pragma mark - UIGestureRecognizer event
-(void) handleLongTap:(UIGestureRecognizer *) recongizer
{
    _tapLocation = [recongizer locationInView:self];
    
    if (self.isShowTipLine == YES) {
        
        [self.tipLineView handleLongTap:recongizer];
    }
}

-(void) handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _previousLocation = [recognizer locationInView:self];
    }
    
    CGPoint currentLocation = [recognizer locationInView:self];
    
    float xDiffrance = currentLocation.x - self.previousLocation.x;
    float yDiffrance = currentLocation.y - self.previousLocation.y;
    
    _previousLocation = [recognizer locationInView:self];
    
    if (self.isEnableUserAction == YES) {
        
        if (self.drawContentWidth > self.frame.size.width) {
            
            _contentScroll.x += xDiffrance;
            
            if (_contentScroll.x > 0) {
                
                _contentScroll.x = 0;
            }
            
            //! 位移量不超過最大高度
            if (-_contentScroll.x > (self.drawContentWidth - self.drawOriginContentWidth)) {
            
                _contentScroll.x = -(self.drawContentWidth - self.drawOriginContentWidth);
            }
        }
        
        if (self.drawContentHeight > self.frame.size.height) {
            
            _contentScroll.y += yDiffrance;
            
            if(_contentScroll.y > 0) {
                
                _contentScroll.y = 0;
            }
            
            //! 位移量不超過最大高度
            if (-_contentScroll.y > (self.drawContentHeight - self.drawOriginContentHeight)) {
                
                _contentScroll.y = -(self.drawContentHeight - self.drawOriginContentHeight);
            }
        }
        
        if (self.isShowTipLine == YES) {
            
            [self setTipLineViewConfigure];
        }
    }
     
    [self setNeedsDisplay];
}

-(void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    if (self.isEnableUserAction == YES) {
        
        self.zoomScale = recognizer.scale;
        
        if(self.zoomScale <= 1){
            
            self.zoomScale = 1;
        }
        else if(self.zoomScale >= 1.5) {
        
            self.zoomScale = 1.5;
        }

        [self updateViewWithFrame:self.frame];
    }
}

@end
