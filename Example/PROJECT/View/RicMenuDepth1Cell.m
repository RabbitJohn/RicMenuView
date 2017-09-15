//
//  RicMenuDepth1Cell.m
//  RicMenu
//
//  Created by john on 16/5/31.
//
//

#import "RicMenuDepth1Cell.h"
#import "Masonry.h"

@interface RicMenuDepth1Cell ()
{
    BOOL __isSelected__;
    RicMenuItem *__filterModel__;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedFlag;


@end

@implementation RicMenuDepth1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20.0f);
            make.top.equalTo(@16.0f);
            make.width.equalTo(@(CGRectGetWidth([UIScreen mainScreen].bounds)-125.0f));
            make.height.equalTo(@18.0f);
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
}

- (RicMenuItem *)menuItem{
    return __filterModel__;
}

@end
