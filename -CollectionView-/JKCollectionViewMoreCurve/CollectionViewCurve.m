#import "CollectionViewCurve.h"
#import "UIView+JKUiviewExtension.h"
#import "CollectionViewScrolllCell.h"
#define JKRandomColor  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0  blue:arc4random_uniform(256)/255.0  alpha:1.0]

@interface CollectionViewCurve ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property(nonatomic,strong) UICollectionView *collectionView;

// 定义 JKCurve对象
@property(nonatomic,strong) JKCurve *jkCurve;
// 用来判断的一个字段(初始值赋为 1)
@property(nonatomic,strong) NSString *judge;
// 右边加载更多的最大距离
@property(nonatomic,assign) CGFloat maxPopDistance;
// 右边加载更多的距离
@property(nonatomic,assign) CGFloat popDistance;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation CollectionViewCurve

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /**
           创建collection
         */
        [self setUICollection];
    }
    
    return self;
}



#pragma mark 设置一个collection
-(void)setUICollection{
    
    //1.UICollectionViewFlowLayout的做布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    /**
     *  设置滑动方向
     *  UICollectionViewScrollDirectionHorizontal 水平方向
     *  UICollectionViewScrollDirectionVertical   垂直方向
     */
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //3.格子的注册
    
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, self.width, self.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor purpleColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    [self.collectionView registerClass:[CollectionViewScrolllCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewScrolllCell class])];
    [self addSubview:self.collectionView];
    
    
    self.maxPopDistance = 60;
    self.judge = @"1";
    self.jkCurve = [[JKCurve alloc]initWithFrame:CGRectMake(self.width, 0, 0, self.height) withType:@"加载更多"];
    [self addSubview:self.jkCurve];
    
}

- (void)setModelArray:(NSArray<Model *> *)modelArray {
    _modelArray = modelArray;
    
    [self.collectionView reloadData];
    
    //默认选中第一行
    
}

#pragma mark -
#pragma mark 上部BaseCollectionView 滚动结束后调用
- (void)baseCollectionViewDidSelectedIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];

    [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
    
}


#pragma mark -CollectionViewDelegate
/*
 collection的段落
 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
/*
 collection每个段落格子数
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.modelArray.count;
    
}
/*
 格子的宽高设置
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.size.height*0.8*1.25, self.collectionView.size.height*0.8);
}

#pragma mark 列间距(上下之间的间距)
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.f;
}

#pragma mark 行间距(左右之间的间距)
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewScrolllCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewScrolllCell class]) forIndexPath:indexPath];
    
    cell.dataModel = self.modelArray[indexPath.item];
    
    // 为选中BOOL值赋值, 上一次的赋值为NO , 当前的indexPath为YES
    if (indexPath.item == _selectedIndexPath.item) {
        cell.isMySelected = YES;
    }else {
        cell.isMySelected = NO;
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 上一个撤销选中
    CollectionViewScrolllCell *selectedCell = (CollectionViewScrolllCell *)[collectionView cellForItemAtIndexPath:_selectedIndexPath];
    
    selectedCell.isMySelected = NO;
    
    // 当前的点击选中
    CollectionViewScrolllCell *cell = (CollectionViewScrolllCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.isMySelected = YES;
    
    // 记录上一个选中的IndexPath
    _selectedIndexPath = indexPath;

    // 将当前的indexPath传递至BaseCollectionView
    if ([self.delegate respondsToSelector:@selector(cardSwitchViewDidSelectAt:)]) {
        [self.delegate cardSwitchViewDidSelectAt:indexPath];
    }
    
    // collectionView 滚动至中央位置
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // 更新
    [_collectionView reloadData];
    
}

#pragma mark 滑动的监听
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // scrollView的x偏移量
    double offsetX = scrollView.contentOffset.x;
    
    if (offsetX<=0) return;
    
    double scrollViewX = offsetX+self.width;

    // collectionView的滚动范围的 width
    float collectionContentSizeWidth = scrollView.contentSize.width;
    
    // 防止在走加载全部再次走下面
    if([self.judge isEqualToString: @"1"]){
        
        self.judge = @"0";
        return;
    }

    if (scrollViewX > collectionContentSizeWidth) {
        
        self.popDistance = (scrollViewX-collectionContentSizeWidth)*2;
        
        if (self.popDistance >= self.maxPopDistance) {
            
            self.popDistance = self.maxPopDistance;
        }
        
        self.jkCurve.controlPoint = CGPointMake(self.jkCurve.width-self.popDistance, self.jkCurve.height/2.0);
        
    }
}

#pragma mark 松开手的操作
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if (targetContentOffset->x == 0) return;
    
    if (self.popDistance == self.maxPopDistance) {
        
        self.judge = @"1";
        
        self.popDistance = 0;
        
        self.jkCurve.controlPoint = CGPointMake(self.jkCurve.width-1, self.jkCurve.height/2.0);
        
        if (self.JKScrollviewBlock) {
            self.JKScrollviewBlock();
        }
    }
}




@end

