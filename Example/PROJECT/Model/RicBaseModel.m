//
//  BaseModel.m
//  RicMenuView
//
//  Created by rice on 15/9/25.
//  Copyright © 2015年 ric. All rights reserved.
//

#import "RicBaseModel.h"
#import <objc/runtime.h>

static NSMutableDictionary *propertiesKeys;

@interface RicBaseModel ()

@property (nonatomic, strong) NSMutableArray *thekeysOfThisClassThatWillBeUsed;
@property (nonatomic, readonly) NSDictionary *_configs;

- (void)getAllKeys;

@end

@implementation RicBaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // do nothing here
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (void)getAllKeys
{
    NSString *keyOfThisClass = NSStringFromClass([self class]);
    if(!_thekeysOfThisClassThatWillBeUsed)
    {
        if(!propertiesKeys)
        {
            propertiesKeys = [NSMutableDictionary new];
        }
        if(![propertiesKeys.allKeys containsObject:keyOfThisClass])
        {
            // 属性个数
            unsigned int propertiesCount;
            // 获取属性列表
            objc_property_t *propertyList = class_copyPropertyList([self class],&propertiesCount);
            _thekeysOfThisClassThatWillBeUsed = [[NSMutableArray alloc] initWithCapacity:propertiesCount];

            for(int i=0; i<propertiesCount; i++)
            {
                // 分别取每一个属性的名字
                objc_property_t property = propertyList[i];
                const char *propertyName = property_getName(property);
                NSString *keyName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
                if(![keyName isEqualToString:@"thekeysOfThisClassThatWillBeUsed"])
                {
                    [_thekeysOfThisClassThatWillBeUsed addObject:keyName];
                }
            }
            if(_thekeysOfThisClassThatWillBeUsed.count > 0)
            {
                [propertiesKeys setValue:_thekeysOfThisClassThatWillBeUsed forKey:keyOfThisClass];
            }
        }
        else
        {
            _thekeysOfThisClassThatWillBeUsed = [propertiesKeys valueForKey:keyOfThisClass];
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self getAllKeys];
    for(int i=0; i<self.thekeysOfThisClassThatWillBeUsed.count; i++)
    {
        NSString *key = self.thekeysOfThisClassThatWillBeUsed[i];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        [self getAllKeys];
        for(int i=0; i<self.thekeysOfThisClassThatWillBeUsed.count; i++)
        {
            NSString *key = self.thekeysOfThisClassThatWillBeUsed[i];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

+ (void)clearProperties
{
    if(propertiesKeys != nil)
    {
        [propertiesKeys removeObjectsForKeys:[propertiesKeys allKeys]];
    }
}

@end
