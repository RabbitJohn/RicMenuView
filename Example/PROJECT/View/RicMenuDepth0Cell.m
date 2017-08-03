//
//  RicMenuCell.m
//  RicMenu
//
//  Created by rice on 16/5/31.
//
//

#import "RicMenuDepth0Cell.h"
#import "Masonry.h"

@interface RicMenuDepth0Cell ()
{
    BOOL __isSelected__;
    RicMenuItem *__filterModel__;
}
/**
   当前title
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
    表示是否有子节点选中
 */
@property (nonatomic, strong) UIView *selectedFlag;

@end

@implementation RicMenuDepth0Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        __weak RicMenuDepth0Cell *weakSelf = self;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.titleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20.0f);
            make.top.equalTo(@16.0f);
            make.width.equalTo(@100.0f);
            make.height.equalTo(@18.0f);
        }];
        
        self.selectedFlag = [UIView new];
        self.selectedFlag.backgroundColor = [UIColor clearColor];
        [self addSubview:self.selectedFlag];
        [self.selectedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.titleLabel.mas_left).offset(-3.0f);
            make.top.equalTo(@23.0f);
            make.width.equalTo(@4.0f);
            make.height.equalTo(@4.0f);
        }];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIView *)selectedFlagView{
    return self.selectedFlag;
}
- (void)setFilterModel:(RicMenuItem *)filterModel{
    __filterModel__ = filterModel;
    self.titleLabel.text = __filterModel__.title;
    // replace the color below
    
//    self.backgroundColor = __filterModel__.isSelected ? [UIColor lightGrayColor]:[UIColor whiteColor];
    
    self.selectedFlag.backgroundColor = __filterModel__.hasSubMenuSelected && !__filterModel__.isLeaf && !__filterModel__.isSelected ? [UIColor redColor]:[UIColor clearColor] ;
    
    // do some changes
}

- (RicMenuItem *)filterModel{
    return __filterModel__;
}

@end
