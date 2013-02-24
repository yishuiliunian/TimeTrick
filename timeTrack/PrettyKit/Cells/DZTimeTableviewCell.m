//
//  DZTimeTableviewCell.m
//  PrettyExample
//
//  Created by dzpqzb on 13-2-23.
//
//

#import "DZTimeTableviewCell.h"

@interface DZTimeTableviewCell ()
@property (nonatomic, strong) UIImageView* lineBreakView;
@end

@implementation DZTimeTableviewCell
@synthesize titleLabel;
@synthesize begainLabel;
@synthesize endLabel;
@synthesize timeSpendLabel;
@synthesize lineBreakView;
@synthesize dzTime;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] init];
        begainLabel = [[UILabel alloc] init];
        endLabel = [[UILabel alloc] init];
         timeSpendLabel = [[UILabel alloc] init];
        void (^derectorPrettyCell)(UIView*,UILabel*,CGRect)= ^(UIView* customView, UILabel* label, CGRect frame)
        {
            label.frame = frame;
            label.backgroundColor = [UIColor clearColor];
            [customView addSubview:label];
            
        };
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        derectorPrettyCell(self, titleLabel, CGRectMake(0.0, 0.0, 0.0, 50.0));
    
        derectorPrettyCell(self, begainLabel, CGRectMake(50, 0.0, 50, 50.0));
        derectorPrettyCell(self, endLabel, CGRectMake(50.0, 0.0, 50, 50.0));
        derectorPrettyCell(self, timeSpendLabel, CGRectMake(50.0, 0.0, 50, 50.0));
        lineBreakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HistoryCellBackground"]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    float leftMargin = 10;
    float titleWidthPerc = 0.38;
    titleLabel.frame = CGRectMake(leftMargin, 5, CGRectGetWidth(self.frame)*titleWidthPerc,CGRectGetHeight(self.frame)-10);
    
    float height = (CGRectGetHeight(self.frame)-10)/3;
    
    begainLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)+1, 10 /3, CGRectGetWidth(self.frame)*(1-titleWidthPerc), height);
    lineBreakView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 0.0, 1, CGRectGetHeight(self.frame));
    timeSpendLabel.frame = CGRectOffset(begainLabel.frame, 0.0, height);
    endLabel.frame = CGRectOffset(timeSpendLabel.frame, 0.0, height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
