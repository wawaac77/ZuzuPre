//
//  ZZContentModel.m
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZContentModel.h"

@implementation ZZContentModel

/*全局变量 */
static NSDateFormatter *fmt_;
static NSDateFormatter *outputFmt_;
static NSCalendar *calendar_;
static NSTimeZone *inputTimeZone_;
static NSTimeZone *outputTimeZone_;

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"listEventID" : @"_id",
             @"listEventUpdatedBy" : @"updatedBy",
             @"listEventUpdatedAt" : @"updatedAt",
             @"listEventCreatedBy" : @"createdBy",
             @"listEventCreatedAt" : @"createdAt",
             @"listMessage" : @"message",
             @"listPublishUser" : @"member",
             @"listEventRestaurant" : @"restaurant",
             @"listImage" : @"image",
             @"listIsLike" : @"isLike",
            };
}

-(CGFloat)cellHeight
{
    //如果cell高度已经计算处理 就直接返回
    if (_cellHeight) return _cellHeight;
    //头像
    _cellHeight = GFiconH;
    
    //文字
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * GFMargin;
    CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
    CGSize textSize = [self.listMessage boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    _cellHeight += textSize.height + GFMargin;
    
    //中间
    /*
    if (self.type != GFTopicTypeWord) {
        CGFloat contentH = textMaxW * self.height / self.width;
        
        if (contentH >= GFScreenHeight) {//超长图片
            contentH = GFLargImageCompressH;
            self.is_largeImage = YES;
        }
        //中间内容的Frame
        //CGRect middleF = CGRectMake(GFMargin, _cellHeight, textMaxW, contentH);
        //self.middleF = middleF;
        
        _cellHeight += contentH + GFMargin;
        
    //}*/
    
    /*
    //最热评论
    if (self.top_cmt) {
        _cellHeight += GFHotCommentLabel ;
        //展示评论数据
        NSString *content = self.top_cmt.content;
        if(self.top_cmt.voiceuri.length)
        {
            content = @"语言评论''";
        }
        NSString *topCmtContent = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, content];
        
        CGSize topCmtContentSize = [topCmtContent boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        _cellHeight += topCmtContentSize.height + GFMargin;
        
    }*/
    //底部工具条
    _cellHeight += GFDcrcH + GFMargin;
    
    //return _cellHeight;
    return 230;
}


/**
 只调用一次
 */
+(void)initialize
{
    fmt_ = [[NSDateFormatter alloc] init];
    outputFmt_ = [[NSDateFormatter alloc] init];
    calendar_ = [NSCalendar gf_calendar];
    inputTimeZone_ = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    outputTimeZone_ = [NSTimeZone localTimeZone];

    [fmt_ setTimeZone:inputTimeZone_];
    [outputFmt_ setTimeZone:outputTimeZone_];
}


-(NSString *)listEventCreatedAt {
    
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *creatAtDate = [fmt_ dateFromString:_listEventCreatedAt];
    
    NSLog(@"_listEventCreatedAt %@", _listEventCreatedAt);
    NSLog(@"createAtDate NSDate %@", creatAtDate);
    //判断
    if (creatAtDate.isThisYear) {//今年
        if ([calendar_ isDateInToday:creatAtDate]) {//今天
            //当前时间
            NSDate *nowDate = [NSDate date];
            
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *comps = [calendar_ components:unit fromDate:creatAtDate toDate:nowDate options:0];
            
            if (comps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd hours ago",comps.hour];
            }else if (comps.minute >= 1){
                return [NSString stringWithFormat:@"%zd minutes ago",comps.minute];
            }else
            {
                return @"Just now";
            }
            
        }else if ([calendar_ isDateInYesterday:creatAtDate]){//昨天
            outputFmt_.dateFormat = @"Yesterday HH:mm";
            return [outputFmt_ stringFromDate:creatAtDate];
            
        }else{//其他
            outputFmt_.dateFormat = @"dd MMM HH:mm";
            return [outputFmt_ stringFromDate:creatAtDate];
            
        }
        
    }else{//非今年
        outputFmt_.dateFormat = @"dd MMM yyyy";
        return [outputFmt_ stringFromDate:creatAtDate];
    }
    
    return _listEventCreatedAt;

}

/**
 日期处理get方法
 */
-(NSString *)listEventUpdatedAt
{
    //将服务器返回的数据进行处理
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.sss'Z'";
    
    NSDate *creatAtDate = [fmt_ dateFromString:_listEventUpdatedAt];
    NSLog(@"_listEventUpdatedAt %@", _listEventUpdatedAt);
    NSLog(@"createAtDate NSDate %@", creatAtDate);
    //判断
    if (creatAtDate.isThisYear) {//今年
        if ([calendar_ isDateInToday:creatAtDate]) {//今天
            //当前时间
            NSDate *nowDate = [NSDate date];
            
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *comps = [calendar_ components:unit fromDate:creatAtDate toDate:nowDate options:0];
            
            if (comps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd hours ago",comps.hour];
            }else if (comps.minute >= 1){
                return [NSString stringWithFormat:@"%zd minutes ago",comps.minute];
            }else
            {
                return @"Just now";
            }
            
        }else if ([calendar_ isDateInYesterday:creatAtDate]){//昨天
            outputFmt_.dateFormat = @"Yesterday HH:mm";
            return [outputFmt_ stringFromDate:creatAtDate];
            
        }else{//其他
            outputFmt_.dateFormat = @"dd MMM HH:mm";
            return [outputFmt_ stringFromDate:creatAtDate];
            
        }
        
    }else{//非今年
        outputFmt_.dateFormat = @"dd MMM yyyy";
        return [outputFmt_ stringFromDate:creatAtDate];
    }
    
    return _listEventUpdatedAt;
}

@end
