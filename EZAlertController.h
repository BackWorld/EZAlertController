//
//  EZAlertController.h
//  EZAlerViewController
//
//  Created by zhuxuhong on 2016/11/23.
//  Copyright © 2016年 zhuxuhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZAlertController;
@class EZAlertAction;
@class EZAlertString;
@class EZAlertTextField;

typedef NS_ENUM(NSUInteger, EZAlertActionStyle){
    EZAlertActionStyleBold,
    EZAlertActionStyleLight
};


typedef void (^EZAlertControllerCompletion)(EZAlertController *alert);
typedef void (^EZAlertActionHandler)(EZAlertAction *action);
typedef void (^EZAlertStringConfigurationHandler)(EZAlertString *string);
typedef void (^EZAlertActionConfigurationHandler)(EZAlertAction *action);
typedef void (^EZAlertTextFieldConfigurationHandler)(EZAlertTextField *textField);

#pragma mark ===== EZAlertTextField

@interface EZAlertTextField : NSObject

@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,strong)UIColor *backgroundColor;
@property(nonatomic,strong)UIColor *borderColor;
@property(nonatomic)CGFloat borderWidth;
@property(nonatomic)CGFloat cornerRadius;

@end


#pragma mark ===== EZAlertString

@interface EZAlertString : NSObject

@property(nonatomic,strong)NSMutableAttributedString *string;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIColor *color;
@property(nonatomic)NSTextAlignment alignment;

+(instancetype)stringWithString: (NSString *)string
           configurationHandler: (EZAlertStringConfigurationHandler)configurationHandler;

@end

#pragma mark ===== EZAlertAction

@interface EZAlertAction : UIAlertAction

@property(nonatomic,strong)UIImage *iconImage;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,strong)UIFont *titleFont;
@property(nonatomic)NSTextAlignment titleAlignment;

+(instancetype)actionWithTitle: (NSString *)title
                       handler: (EZAlertActionHandler)handler
          configurationHandler: (EZAlertActionConfigurationHandler)configurationHandler;

@end


#pragma mark ===== EZAlertController

@interface EZAlertController : UIViewController

@property(nonatomic,strong)UIColor *backgroundColor; //背景色
@property(nonatomic)BOOL showRoundCorner; //显示圆角
@property(nonatomic)BOOL showBlurEffect; //模糊效果

+(instancetype)alertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                                  owner:(UIViewController *)owner
                         preferredStyle:(UIAlertControllerStyle)preferredStyle;

+(instancetype)alertControllerWithTitle: (NSString *)title
                                message: (NSString *)message
                                  owner: (UIViewController*)owner
                         preferredStyle: (UIAlertControllerStyle)preferredStyle
              titleConfigurationHandler: (EZAlertStringConfigurationHandler)titleConfigurationHandler
            messageConfigurationHandler: (EZAlertStringConfigurationHandler)messageConfigurationHandler;


-(void)addActionWithTitle: (NSString*)title
                  handler: (EZAlertActionHandler)handler
     configurationHandler: (EZAlertActionConfigurationHandler)configurationHandler;

- (void)addTextFieldWithConfigurationHandler:(EZAlertTextFieldConfigurationHandler)configurationHandler;

-(void)presentWithAnimated:(BOOL)flag completion:(EZAlertControllerCompletion)completion;

@end
