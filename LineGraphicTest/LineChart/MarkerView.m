//
//  MarkerView.m
//  LineGraphicTest
//
//  Created by yehengjia on 2015/7/31.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import "MarkerView.h"
#import "Constants.h"

#define XOffset 5.0

@interface MarkerView()

@property (nonatomic, strong) UILabel *lbTitle;

@property (nonatomic, strong) UILabel *lbMessage;

@end

@implementation MarkerView

-(void) dealloc
{
    OBJC_RELEASE(self.title);
    OBJC_RELEASE(self.message);

    OBJC_RELEASE(self.lbTitle);
    OBJC_RELEASE(self.lbMessage);
    
    [super dealloc];
}

-(instancetype) init {

    if ( self = [super init]) {
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.lbTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbTitle.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbTitle];
        [self.lbTitle release];
        
        self.lbMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.lbMessage.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbMessage.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbMessage];
        [self.lbMessage release];

    }
    
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(XOffset, 0, frame.size.width - XOffset, (frame.size.height / 3))];
        self.lbTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbTitle.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbTitle];
        [self.lbTitle release];
        
        self.lbMessage = [[UILabel alloc] initWithFrame:CGRectMake(XOffset, (frame.size.height / 3), frame.size.width - XOffset, (frame.size.height / 3))];
        self.lbMessage.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbMessage.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbMessage];
        [self.lbMessage release];
    }
    
    return self;
}

-(instancetype) initWithImage:(UIImage *)image
{
    if ( self = [super initWithImage:image]) {
    
        CGSize imgSize = image.size;
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(XOffset, 0, imgSize.width - XOffset, (imgSize.height / 3))];
        self.lbTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbTitle.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbTitle];
        [self.lbTitle release];
        
        self.lbMessage = [[UILabel alloc] initWithFrame:CGRectMake(XOffset, (imgSize.height / 3), imgSize.width - XOffset, (imgSize.height / 3))];
        self.lbMessage.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbMessage.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbMessage];
        [self.lbMessage release];
    }
    
    return self;
}

-(instancetype) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if ( self = [super initWithImage:image highlightedImage:highlightedImage]) {
        
        CGSize imgSize = image.size;
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(XOffset, 0, imgSize.width - XOffset, (imgSize.height / 3))];
        self.lbTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbTitle.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbTitle];
        [self.lbTitle release];
        
        self.lbMessage = [[UILabel alloc] initWithFrame:CGRectMake(XOffset, (imgSize.height / 3), imgSize.width - XOffset, (imgSize.height / 3))];
        self.lbMessage.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lbMessage.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.lbMessage];
        [self.lbMessage release];
    }
    
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.lbTitle != nil) {
        
        self.lbTitle.frame = CGRectMake(XOffset, 0, frame.size.width - XOffset, (frame.size.height / 3));
    }
    
    if (self.lbMessage != nil) {
        
        self.lbMessage.frame = CGRectMake(XOffset, (frame.size.height / 3), frame.size.width - XOffset, (frame.size.height / 3));
    }
}

-(void) setTitle:(NSString *)title
{
    if (self.lbTitle != nil) {
        
        self.lbTitle.text = title;
    }
}

-(void) setMessage:(NSString *)message
{
    if (self.lbMessage != nil) {
        
        self.lbMessage.text = message;
    }
}
@end
