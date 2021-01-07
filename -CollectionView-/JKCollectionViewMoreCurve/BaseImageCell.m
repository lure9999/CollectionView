//
//  CollectionViewScrolllCell.m
//  OCTest
//
//  Created by 王冲 on 2018/10/29.
//  Copyright © 2018年 希爱欧科技有限公司. All rights reserved.
//

#import "BaseImageCell.h"

@implementation BaseImageCell{
    UIImageView *_imageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
   
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    

    
}

- (void)setItem:(Model *)item {
    _imageView.image = [UIImage imageNamed:item.imageName];
}

@end
