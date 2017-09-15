//
//  RicMenuDepth2Cell.m
//  RicMenuView
//
//  Created by john on 2017/7/23.
//
//

#import "RicMenuDepth2Cell.h"
#import "Masonry.h"

@interface RicMenuDepth2Cell ()
{
    BOOL __isSelected__;
    RicMenuItem *__filterModel__;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedFlag;

@end

@implementation RicMenuDepth2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        __weak RicMenuDepth2Cell *weakSelf = self;
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20.0f);
            make.top.equalTo(@16.0f);
            make.width.equalTo(@(CGRectGetWidth([UIScreen mainScreen].bounds)-125.0f));
            make.height.equalTo(@18.0f);
        }];
        
        self.selectedFlag = [UIImageView new];
        self.selectedFlag.backgroundColor = [UIColor redColor];
        [self addSubview:self.selectedFlag];
        [self.selectedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-10.0f);
            make.top.equalTo(@(13.0f));
            make.height.equalTo(@24.0f);
            make.width.equalTo(@24.0f);
        }];
    }
    
    return self;
}

- (UIView *)selectedFlagView{
    return self.selectedFlag;
}
- (void)updateMenuItem:(RicMenuItem *)menuItem{
    __filterModel__ = menuItem;
    
    self.titleLabel.text = __filterModel__.title;
    
    self.selectedFlag.backgroundColor = __filterModel__.isSelected ? [UIColor redColor]:[UIColor clearColor];
    
}

- (RicMenuItem *)menuItem{
    return __filterModel__;
}
@end
