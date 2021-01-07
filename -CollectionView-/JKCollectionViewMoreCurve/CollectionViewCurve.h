#import <UIKit/UIKit.h>
#import "JKCurve.h"
#import "Model.h"

@protocol CardSwitchViewDelegte <NSObject>
@optional

- (void)cardSwitchViewDidSelectAt:(NSIndexPath *)indexPath;


@end

@interface CollectionViewCurve : UIView

@property (nonatomic, strong) NSArray <Model *>*modelArray;
@property (nonatomic, weak) id <CardSwitchViewDelegte>delegate;

@property(nonatomic,strong) void(^JKScrollviewBlock)(void);
- (void)baseCollectionViewDidSelectedIndex:(NSInteger)index;
@end


