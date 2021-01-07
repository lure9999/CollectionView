#import "Model.h"

@implementation Model
+ (instancetype)modelWithDict:(NSDictionary *)dict {
    
    Model *model = [[self alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
