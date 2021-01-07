#import "ViewController.h"
#import "CollectionViewCurve.h"
#import "BaseImageCell.h"

@interface ViewController()<CardSwitchViewDelegte,UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL isShow;
}
@property (nonatomic, weak) CollectionViewCurve *collectionViewScroll;
@property (nonatomic, strong) UICollectionView *baseCollectionView;
@property (nonatomic, strong) NSArray <Model *>*modelArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//不设置有问题。。
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图片浏览";
    [self requestData];
}

#pragma mark -
#pragma mark 设置UI及数据
-(void)requestData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DataPropertyList" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        // 字典转模型, 这里可以用YYModel 或 MJExtension
        Model *model = [Model modelWithDict:dict];
        [arrM addObject:model];
    }
    self.modelArray = [arrM copy];
}

- (void)setModelArray:(NSArray<Model *> *)modelArray {
    _modelArray = modelArray;
    [self.view addSubview:self.baseCollectionView];
    [self addSrcollView];
    [self addBtn];
    [self.baseCollectionView reloadData];
}

-(void)addBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100,150, 50)];
    btn.backgroundColor=[UIColor orangeColor];
    [btn setTitle:@"显示隐藏选择" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showCollectionView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)showCollectionView{
    isShow = !isShow;
    self.collectionViewScroll.hidden = isShow;
}


- (UICollectionView*)baseCollectionView {
    if (!_baseCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        float bw =self.view.bounds.size.width;
        float bh =self.view.bounds.size.height;
        layout.itemSize = CGSizeMake(bw,bh );
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        float w = [UIScreen mainScreen].bounds.size.width;
        float h =[UIScreen mainScreen].bounds.size.height;
        _baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,w, h) collectionViewLayout:layout];
        _baseCollectionView.delegate = self;
        _baseCollectionView.dataSource = self;
        _baseCollectionView.pagingEnabled = YES;
        
        [_baseCollectionView registerClass:[BaseImageCell class] forCellWithReuseIdentifier:NSStringFromClass([BaseImageCell class])];
    }
    return _baseCollectionView;
}


-(void)addSrcollView{
    CollectionViewCurve *collectionView = [[CollectionViewCurve alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height*0.75,self.view.bounds.size.width, self.view.bounds.size.height*0.25)];
    collectionView.delegate=self;
    _collectionViewScroll =collectionView;
    _collectionViewScroll.modelArray = self.modelArray;

    _collectionViewScroll.JKScrollviewBlock = ^() {
        
        NSLog(@"加载更多");
    };
    [self.view addSubview:_collectionViewScroll];
}

#pragma mark -
#pragma mark 下部选中结果
- (void)cardSwitchViewDidSelectAt:(NSIndexPath*)index {
    NSLog(@"选中了:%ld",(long)index.row);
    Model *item = _collectionViewScroll.modelArray[index.row];
    self.title = item.title;

    [self.baseCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}


#pragma mark -
#pragma mark dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BaseImageCell class]) forIndexPath:indexPath];
    [cell setItem:[self.modelArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark delegate 上部滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    //根据当前 contentoffset获得index
    
    CGFloat width = scrollView.contentSize.width / self.modelArray.count;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX / width;

    // 滑动结束时, 让顶部headerView 主动调用didSelected方法
    [_collectionViewScroll baseCollectionViewDidSelectedIndex:index];
}


@end

