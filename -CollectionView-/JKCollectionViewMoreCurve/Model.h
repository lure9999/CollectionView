#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *mp3Url;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
