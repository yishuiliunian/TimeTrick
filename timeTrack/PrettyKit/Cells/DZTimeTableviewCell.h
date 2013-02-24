//
//  DZTimeTableviewCell.h
//  PrettyExample
//
//  Created by dzpqzb on 13-2-23.
//
//

#import "PrettyCustomViewTableViewCell.h"

@interface DZTimeTableviewCell : PrettyCustomViewTableViewCell
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* timeSpendLabel;
@property (nonatomic, strong) UILabel* begainLabel;
@property (nonatomic, strong) UILabel* endLabel;
@property (nonatomic, strong) DZTime* dzTime;
@end
