//
//  CustomViewController.m
//  UMFeedback
//
//  Created by amoblin on 14/9/12.
//
//

#import "CustomViewController.h"


@interface CustomViewController ()

@property (strong, nonatomic) UMFeedback *feedback;
@end

@implementation CustomViewController

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Feedback";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UMFeedback setAppkey:APPKEY];
    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
    
    NSUInteger i = 1;
    for (NSString *title in @[NSLocalizedString(@"Get", nil),
                              NSLocalizedString(@"Post", nil),
                              NSLocalizedString(@"Update User Info", nil),
                              NSLocalizedString(@"checkReply", nil)]) {
        UIButton *feedbackButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 80 * i, 300, 100)];
        feedbackButton.tag = i;
        [feedbackButton setTitle:title
                        forState:UIControlStateNormal];
        [feedbackButton setTitleColor:UIColorFromRGB(0.0, 122.0, 255.0)
                             forState:UIControlStateNormal];
        [feedbackButton addTarget:self
                           action:@selector(feedbackButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
//        [buttons addObject:feedbackButton];
        [self.view addSubview:feedbackButton];
        i++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)feedbackButtonPressed:(UIButton *)sender
{
    switch (sender.tag) {
        case 1: {
            UMFeedback *feedback = [UMFeedback sharedInstance];
            [feedback get];
            break;
        }
        case 2: {
            NSDictionary *postContent = @{@"content":@"biao ti",
                                          @"gender":@"1",
                                          @"age_group":@"3",
                                          @"type": @"user_reply",
                                          };
            [[UMFeedback sharedInstance] post:postContent];
            break;
        }
        case 3:
            [[UMFeedback sharedInstance] updateUserInfo:@{@"contact": @{@"qq": @"123",
                                                                        @"email": @"ios@umeng.com",
                                                                        @"phone": @"1388888888",
                                                                        @"plain": @"very good"}}];
            break;
        case 4:
            [UMFeedback checkWithAppkey:APPKEY];
            break;
        default:
            break;
    }
}

#pragma mark - UMFeedback Delegate

- (void)getFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", self.feedback.topicAndReplies);
    }
}

- (void)postFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", self.feedback.topicAndReplies);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    self.feedback.delegate = nil;
}

@end
