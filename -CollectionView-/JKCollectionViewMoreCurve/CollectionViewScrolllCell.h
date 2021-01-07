#import <UIKit/UIKit.h>
#import "Model.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewScrolllCell : UICollectionViewCell
@property (nonatomic, strong) Model *dataModel;
@property (nonatomic, assign) BOOL isMySelected;

@end

NS_ASSUME_NONNULL_END
