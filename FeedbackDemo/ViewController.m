//
//  ViewController.m
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "ViewController.h"
#import "UMFeedback.h"
#import "CustomViewController.h"


#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController ()
@property (strong, nonatomic) NSArray *buttons;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = NSLocalizedString(@"Demo", nil);

    }
    return self;
}

- (void)loadView {
    [super loadView];
    NSUInteger i = 1;
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (NSString *title in @[NSLocalizedString(@"Push", nil),
                              NSLocalizedString(@"Modal", nil),
                              NSLocalizedString(@"List", nil),
                              NSLocalizedString(@"Custom", nil)]) {
        UIButton *feedbackButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 100 * i, 200, 100)];
        feedbackButton.tag = i;
        [feedbackButton setTitle:title
                        forState:UIControlStateNormal];
        [feedbackButton setTitleColor:UIColorFromRGB(0.0, 122.0, 255.0)
                             forState:UIControlStateNormal];
        [feedbackButton addTarget:self
                           action:@selector(feedbackButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:feedbackButton];
        [self.view addSubview:feedbackButton];
        i++;
    }
    self.buttons = buttons;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLayoutWithOrientation:self.interfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutWithOrientation:toInterfaceOrientation];
}

- (void)updateLayoutWithOrientation:(UIInterfaceOrientation)orientation {
    CGFloat viewWidth, viewHeight;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            viewWidth = [UIScreen mainScreen].bounds.size.width;
            viewHeight= [UIScreen mainScreen].bounds.size.height;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            if (IOS_8_OR_LATER) {
                viewWidth = [UIScreen mainScreen].bounds.size.width;
                viewHeight= [UIScreen mainScreen].bounds.size.height;
            } else {
                viewWidth = [UIScreen mainScreen].bounds.size.height;
                viewHeight = [UIScreen mainScreen].bounds.size.width;
            }
            break;
        }
        default:
            viewWidth = 0;
            viewHeight = 0;
            break;
    }
    NSUInteger i = 1;
    if (viewHeight == 320) {
        for (UIButton *button in self.buttons) {
            if (i < 3) {
                button.frame = CGRectMake(viewWidth/4-100, 100*i, 200, 100);
            } else {
                button.frame = CGRectMake(viewWidth*3/4-100, 100*(i-2), 200, 100);
            }
            i++;
        }
    } else {
        for (UIButton *button in self.buttons) {
            button.frame = CGRectMake(viewWidth/2-100, 100 * i, 200, 100);
            i++;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feedbackButtonPressed:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
//            [[UMFeedback sharedInstance] setTitleColor:[UIColor blueColor]];
            [self.navigationController pushViewController:[UMFeedback feedbackViewController]
                                                 animated:YES];
            break;
        case 2:
            [self presentModalViewController:[UMFeedback feedbackModalViewController]
                                    animated:YES];
//             previous method
//            [UMFeedback showFeedback:self withAppkey:APPKEY];
            break;
        case 3:
//            self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
            break;
        case 4:
            [self.navigationController pushViewController:[CustomViewController new]
                                                 animated:YES];
            break;
        default:
            break;
    }
}

@end
