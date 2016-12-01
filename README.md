#EZAlertController


###0、 暂时只支持 UIAlertControllerStyleAlert

> 先来个最终效果图，看合您的口味和需求，再接着往下看

![默认情况下](http://upload-images.jianshu.io/upload_images/1334681-5c180c4fbc68b02e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
> ----只是把系统的圆角给弄没了，可以设置** alert.showRoundCorner = true **显示出来

###1、 自定义样式效果图

![可以设置背景图/色](http://upload-images.jianshu.io/upload_images/1334681-9b436397b4c750d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###2、 看到这，相信你已经有些兴趣了，就再看看用法：

```
// 创建对话框
   EZAlertController *alert = [EZAlertController 
    alertControllerWithTitle:@"title"           
    message:@"message" 
    owner:self 
    preferredStyle:UIAlertControllerStyleAlert //目前只支持Alert样式
    titleConfigurationHandler:^(EZAlertString *title) {
        title.font = [UIFont boldSystemFontOfSize:24];
        title.color = [UIColor redColor];
        title.alignment = NSTextAlignmentLeft;
    } 
    messageConfigurationHandler:^(EZAlertString *message) {
        message.font = [UIFont boldSystemFontOfSize:16];
        message.color = [UIColor greenColor];
        message.alignment = NSTextAlignmentRight;
    }];
// 是否显示圆角
    alert.showRoundCorner = false;
// 是否显示毛玻璃效果
    alert.showBlurEffect = false;
// 背景色/图
    alert.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
// add action 1
    [alert addActionWithTitle:@"action1" handler:^(UIAlertAction *action) {
        NSLog(@"%@",action.title); //点击按钮回调
    } configurationHandler:^(EZAlertAction *action) {
        action.titleAlignment = NSTextAlignmentLeft; //按钮文字对齐
        action.titleColor = [UIColor orangeColor]; // 按钮文字颜色
        action.iconImage = [UIImage imageNamed:@"icon"]; //按钮的图标
    }];

// add action 2
    [alert addActionWithTitle:@"action2" handler:^(UIAlertAction *action) {
        NSLog(@"%@",action.title);
    } configurationHandler:^(EZAlertAction *action) {
        action.titleAlignment = NSTextAlignmentRight;
        action.titleColor = [UIColor redColor];
    }];

// 添加输入框1
    [alert addTextFieldWithConfigurationHandler:^(EZAlertTextField *textField) {
        textField.placeholder = @"用户名";
        textField.borderWidth = 1;
    }];

// 添加输入框2
    [alert addTextFieldWithConfigurationHandler:^(EZAlertTextField *textField) {
        textField.placeholder = @"密码";
        textField.borderWidth = 2;
    }];

// 显示对话框
    [alert presentWithAnimated:true completion:nil];
```
###3、 基于UIAlertController的封装，其实是变相“改造”

> 如果你想更进一步“改造”，不妨先弄清楚它原始的结构

![三维层级图](http://upload-images.jianshu.io/upload_images/1334681-4a280ae86c967a42.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 或者如下图可以改造私有API，但有风险且苹果不推荐

![调试层级图](http://upload-images.jianshu.io/upload_images/1334681-7a4c44f9634a4eb5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 我是结合了2种方式，些许私有API + controller封装，然后“改造”里边的view样式，这样就不会过多设计私有API而是直接作用于UIView，自然起到了“自定义”的功效

###4、 我简单打印拆分的UIViewController - Alert的层级结构

```
s _UIAlertControllerView
s1 0 UIView
        s2 0 _UIDimmingKnockoutBackdropView
            s3 0 UIView
            s3 1 UIVisualEffectView
        s2 1 UIView
            s3 0 UIView
                s4 0 _UIAlertControllerShadowedScrollView
                    s5 0 UILabel - title
                    s5 1 UILabel - message
                    s5 2 UIView - unknown
                    s5 3 UIView  - tf views
                          s6 0 UICollectionViewControllerWrapperView
                              s7 0 UICollectionView
                                  s8 0 _UIAlertControllerTextFieldViewCollectionCell
                                      s9 0 UIView
                                          s10 0 UIVisualEffectView
                                          s10 1 UIView
                                                s11 0 _UIAlertControllerTextField - textfield
                    s5 4 UIImageView
                    s5 5 UIImageView
                s4 1 UILabel
                s4 2 UICollectionView
                    s5 0 _UIAlertControllerCollectionViewCell
                        s6 0 UIView
                            s7 0 _UIAlertControllerActionView
                                s8 0 UIView
                                    s9 0 UILabel - btn
                                    s9 1 UILabel
                                s8 0 UIImageView
                                s9 1 UIView
                    s5 1 _UIAlertControllerBlendingSeparatorView
                        s6 0 _UIBlendingHighlightView
                            s7 0 _UIView
                            s7 1 _UIView
                        s6 1 UIImageView
                        s6 2 UIImageView
```

### 5、简单易用，与UIAlertController无异

![拖进去](http://upload-images.jianshu.io/upload_images/1334681-570143d1c39663a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> github: https://github.com/BackWorld/EZAlertController

### 6、如对你有些许帮助，别忘了⭐️一下哦

