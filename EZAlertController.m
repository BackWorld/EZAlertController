//
//  EZAlertController.m
//  EZAlerViewController
//
//  Created by zhuxuhong on 2016/11/23.
//  Copyright © 2016年 zhuxuhong. All rights reserved.
//

#import "EZAlertController.h"

#pragma mark -------- EZAlertTextField
@interface EZAlertTextField()

@property(nonatomic,strong)UIView *borderView;

+(instancetype)textFieldWithUITextField:(UITextField *)textField
                   configurationHandler:(EZAlertTextFieldConfigurationHandler)configurationHandler;

@end

@implementation EZAlertTextField
{
    UITextField *_textField;
    EZAlertTextFieldConfigurationHandler _configurationHandler;
}

+(instancetype)textFieldWithUITextField:(UITextField *)textField
                   configurationHandler:(EZAlertTextFieldConfigurationHandler)configurationHandler{
    
    EZAlertTextField *tf = [self new];
    [tf setValue:textField forKeyPath:@"textField"];
    [tf setValue:configurationHandler forKeyPath:@"configurationHandler"];
    return tf;
}


-(void)setBorderView:(UIView *)borderView{
    _borderView = borderView;
    
    _configurationHandler(self);
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    
    _borderView.backgroundColor = _backgroundColor;
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    _textField.placeholder = _placeholder;
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    
    _borderView.layer.borderColor = _borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    borderWidth = borderWidth < 0 ? 1 : borderWidth;
    _borderWidth = borderWidth;
    
    _borderView.layer.borderWidth = _borderWidth;
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    
    _borderView.layer.cornerRadius = _cornerRadius;
}

@end

#pragma mark -------- EZAlertString
@implementation EZAlertString

+(instancetype)stringWithString: (NSString *)string configurationHandler: (EZAlertStringConfigurationHandler)configurationHandler{
    EZAlertString *str = [EZAlertString new];
    str.string = [[NSMutableAttributedString alloc] initWithString:string];
    configurationHandler ? configurationHandler(str) : nil;
    return str;
}

-(void)setFont:(UIFont *)font{
    _font = font;
    
    [self.string addAttribute:NSFontAttributeName value:_font range:[self range]];
}

-(void)setColor:(UIColor *)color{
    _color = color;
    
    [self.string addAttribute:NSForegroundColorAttributeName value:_color range:[self range]];
}

-(void)setAlignment:(NSTextAlignment)alignment{
    _alignment = alignment;
    
    NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
    ps.alignment = alignment;
    [self.string addAttribute:NSParagraphStyleAttributeName value:ps range:[self range]];
}

-(NSRange)range{
    return NSMakeRange(0, self.string.string.length);
}

@end


#pragma mark -------- EZAlertAction
@implementation EZAlertAction

+(instancetype)actionWithTitle: (NSString *)title
                       handler: (EZAlertActionHandler)handler
          configurationHandler: (EZAlertActionConfigurationHandler)configurationHandler{
    EZAlertAction *action = [super actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler((EZAlertAction *)action);
    }];
    configurationHandler ? configurationHandler(action) : nil;
    return action;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(void)setIconImage:(UIImage *)image{
    _iconImage = image ? image : [UIImage new];
    [self setValue:[_iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKeyPath:@"image"];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont ? titleFont : [UIFont systemFontOfSize:18];
    [self setValue:_titleFont forKeyPath:@""];
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor ? titleColor : [UIColor blackColor];
    [self setValue:_titleColor forKeyPath:@"titleTextColor"];
}

-(void)setTitleAlignment:(NSTextAlignment)titleAlignment{
    _titleAlignment = titleAlignment;
    [self setValue:@(_titleAlignment) forKeyPath:@"titleTextAlignment"];
}

@end



#pragma mark ------- EZAlertController

@interface EZAlertController ()

@property(nonatomic,strong)UIViewController *owner;
@property(nonatomic,strong)UIAlertController *alert;

@end

@implementation EZAlertController
{
    UIView *_backdropView;
    UIVisualEffectView *_effectView;
    UICollectionView *_textFieldCollectionView;
    NSMutableArray<EZAlertTextField*> *_textFieldViews;
}

#pragma mark - initial method

+(instancetype)alertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                                  owner:(UIViewController *)owner
                         preferredStyle:(UIAlertControllerStyle)preferredStyle{
    
    EZAlertController *alert = [EZAlertController new];
    alert.alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    alert.owner = owner;
    return alert;
}

+(instancetype)alertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                                  owner:(UIViewController *)owner
                         preferredStyle:(UIAlertControllerStyle)preferredStyle
              titleConfigurationHandler:(EZAlertStringConfigurationHandler)titleConfigurationHandler
            messageConfigurationHandler:(EZAlertStringConfigurationHandler)messageConfigurationHandler{
    
    EZAlertController *alert = [EZAlertController alertControllerWithTitle:title?title:@"" message:message?message:@"" owner:owner preferredStyle:preferredStyle];
    if (title) {
        EZAlertString *eztitle = [EZAlertString stringWithString:title configurationHandler:titleConfigurationHandler];
        [alert.alert setValue:eztitle.string forKeyPath:@"attributedTitle"];
    }
    if (message) {
        EZAlertString *ezmessage = [EZAlertString stringWithString:message configurationHandler:messageConfigurationHandler];
        [alert.alert setValue:ezmessage.string forKeyPath:@"attributedMessage"];
    }
    return alert;
}

-(instancetype)init{
    if (self = [super init]) {
        _textFieldViews = [NSMutableArray array];
        
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - lifecycle method

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    if (_alert.isFirstResponder) {
        _alert.view.center = self.view.center;
    }
    
    // 这里进行自定义样式设置
    UIView *view = _alert.view.subviews[0]; //s1
    if (view.bounds.size.width > 0 && _alert.view.hidden) {
        _alert.view.hidden = false;
        [_alert becomeFirstResponder];
        
        _backdropView = view.subviews[0]; //s2-0
        _effectView = _backdropView.subviews[1];
        _effectView.effect = nil;
        
        UIView *scrollView = view.subviews[1].subviews[0].subviews[0]; //s2-1 s3-0 s4-0
        
        UIView *tfsParentView = [scrollView.subviews[0].subviews lastObject];
        _textFieldCollectionView = tfsParentView.subviews.count > 0 ? tfsParentView.subviews[0].subviews[0] : nil;
        _textFieldCollectionView ? [self updateStyleOfTextFields] : nil;
        [self updateStyleOfBackgroundView];
    }
}

#pragma mark - setters & getters
-(void)setShowRoundCorner:(BOOL)showRoundCorner{
    _showRoundCorner = showRoundCorner;
    
    CGFloat cornerRadius = _showRoundCorner ? 10 : 0;
    
    _alert.view.layer.cornerRadius = cornerRadius;
    _backdropView.layer.cornerRadius = cornerRadius;
    _backdropView.subviews[0].layer.cornerRadius = cornerRadius;
    _effectView.contentView.layer.cornerRadius = cornerRadius;
    _effectView.subviews[0].layer.cornerRadius = cornerRadius;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    if (!backgroundColor) {
        backgroundColor = [UIColor whiteColor];
    }
    _backgroundColor = backgroundColor;
    
    _alert.view.backgroundColor = _backgroundColor;
    _backdropView.backgroundColor = [UIColor clearColor];
    _backdropView.subviews[0].backgroundColor = [UIColor clearColor];
    _effectView.contentView.backgroundColor = [UIColor clearColor];
    _effectView.subviews[0].backgroundColor = [UIColor clearColor];
}


#pragma mark - private method


// 输入框
-(void)updateStyleOfTextFields{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_textFieldCollectionView.collectionViewLayout;
    layout.minimumLineSpacing = 10;
    for (int i=0; i<_textFieldCollectionView.subviews.count; i++)
    {
        UIView *view = _textFieldCollectionView.subviews[i];
        if ([view isMemberOfClass:
             NSClassFromString(@"_UIAlertControllerTextFieldViewCollectionCell")])
        {
            UICollectionViewCell *cell = (UICollectionViewCell *)view;
            UIView *v = cell.contentView.subviews[0].subviews[0];
            
            UIVisualEffectView *eview = v.subviews[0];
            eview.effect = nil;
            eview.contentView.subviews[0].backgroundColor = [UIColor clearColor];
            
            _textFieldViews[i].borderView = v.subviews[1];
            // 默认样式
            _textFieldViews[i].borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
            _textFieldViews[i].borderWidth = 1.0;
        }
    }
}

// 背景 - 圆角/背景色
-(void)updateStyleOfBackgroundView{
    
    // 设置圆角
    [self setShowRoundCorner:_showRoundCorner];
    
    // 半透明模糊效果
    [self setShowBlurEffect:_showBlurEffect];
    
    // 背景颜色
    [self setBackgroundColor: _backgroundColor];
}

-(void)dismiss{
    [_alert.view removeFromSuperview];
    [_alert dismissViewControllerAnimated:false completion:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [_owner dismissViewControllerAnimated:false completion:nil];
}

#pragma mark - public method

// add action
-(void)addActionWithTitle:(NSString *)title handler:(EZAlertActionHandler)handler configurationHandler:(EZAlertActionConfigurationHandler)configurationHandler{
    EZAlertAction *action = [EZAlertAction actionWithTitle:title handler:^(UIAlertAction * _Nonnull action) {
        handler ? handler((EZAlertAction*)action) : nil;
        [self dismiss];
    } configurationHandler:configurationHandler];
    [_alert addAction: action];
}

// add text field
-(void)addTextFieldWithConfigurationHandler:(EZAlertTextFieldConfigurationHandler)configurationHandler{
    NSMutableArray *arr = _textFieldViews;
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        EZAlertTextField *tf = [EZAlertTextField textFieldWithUITextField:textField configurationHandler:configurationHandler];
        [arr addObject:tf];
    }];
}

-(void)presentWithAnimated:(BOOL)flag completion:(EZAlertControllerCompletion)completion{
    [_owner addChildViewController:self];
    [_owner.view addSubview:self.view];
    
    [self.view addSubview:_alert.view];
    _alert.view.hidden = true;
    [self presentViewController:_alert animated:true completion:^{
        completion ? completion(self) : nil;
    }];
}

@end
