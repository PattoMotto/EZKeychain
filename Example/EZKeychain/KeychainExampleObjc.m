//Pat

#import "KeychainExampleObjc.h"
@import EZKeychain;

@interface KeychainExampleObjc()

@property (nonatomic, strong, readwrite) EZKeychain *keychain;

@end

@implementation KeychainExampleObjc

NSString *const KeyString = @"StringKey";
NSString *const KeyData = @"DataKey";
NSString *const KeyObject = @"ObjectKey";

- (instancetype)init
{
    self = [super init];
    if (self) {
        _keychain = EZKeychain.shared;
        [self write];
        [self read];
//        update
        [self write];
        
        [self clear];
        [self read];
    }
    return self;
}

- (void)read {
    NSLog(@"%@ %@", KeyString, [self.keychain readStringWithKey:KeyString]);
    NSLog(@"%@ %@", KeyData, [self.keychain readDataWithKey:KeyData]);
    NSLog(@"%@ %@", KeyObject, [self.keychain readObjectWithKey:KeyObject]);
}

- (void)write {
    [self.keychain writeStringWithKey:KeyString
                                value:@"Simple string objective-c"];
    [self.keychain writeDataWithKey:KeyData
                              value:[NSKeyedArchiver archivedDataWithRootObject:@[@111.11, @999.99]]];
    [self.keychain writeObjectWithKey:KeyObject
                                value:@{@"Foo": @111.11}];
}

- (void)clear {
    [self.keychain clearWithKey:KeyString];
    [self.keychain clearWithKey:KeyData];
    [self.keychain clearWithKey:KeyObject];
}
@end
