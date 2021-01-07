#import "CollectionViewScrolllCell.h"

@implementation CollectionViewScrolllCell{
    UIImageView *_imageView;
    UILabel *_textLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth =10;
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelH = self.bounds.size.height * 0.2f;
    CGFloat imageViewH = self.bounds.size.height - labelH;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageViewH)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.alpha=0.8f;
    _imageView.layer.masksToBounds = true;
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewH, self.bounds.size.width, labelH)];
    _textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    _textLabel.font = [UIFont systemFontOfSize:22];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_textLabel];
    
}

- (void)setDataModel:(Model *)dataModel {
    _dataModel = dataModel;
    _imageView.image = [UIImage imageNamed:dataModel.imageName];
    _textLabel.text = dataModel.title;
}



- (void)setIsMySelected:(BOOL)isMySelected {
    _isMySelected = isMySelected;
    
    if (isMySelected) {
        self.layer.borderColor = [UIColor redColor].CGColor;
        _imageView.alpha=1.0f;
    }else{
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.alpha=0.8f;
    }
}


@end
