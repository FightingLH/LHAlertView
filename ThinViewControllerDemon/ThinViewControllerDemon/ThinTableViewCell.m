//
//  ThinTableViewCell.m
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/31.
//  Copyright © 2016年 lh. All rights reserved.
//

#import "ThinTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ThinTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@end
@implementation ThinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setModel:(ThinModel *)model{
    _model = model;
    [self.bannerImage sd_setImageWithURL:[NSURL URLWithString:model.bannerImage]];
}
@end
