//
//  SplashScreenViewController.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/15/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "ConfigApp.h"
#import "ConfigManager.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface SplashScreenViewController (){
    UIImageView *bgView;
    UIActivityIndicatorView *loadingView;
    AppDelegate *appDelegate;
}

@end

@implementation SplashScreenViewController

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self initSubView];
    [[ConfigManager getInstance] loadConfig:CONFIG_URL finished:^(BOOL success, ConfigApp *configApp) {
        [loadingView stopAnimating];
        appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if (success) {
            appDelegate.config = configApp;
            [[NSUserDefaults standardUserDefaults] setValue:appDelegate.config.statusApp forKey:key_status_app];
            [[NSUserDefaults standardUserDefaults] setValue:appDelegate.config.urlShare forKey:key_url_share];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            appDelegate.config = [[ConfigApp alloc] init];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:key_status_app]) {
                appDelegate.config.statusApp = [[NSUserDefaults standardUserDefaults] objectForKey:key_status_app];
            }else{
                appDelegate.config.statusApp = STATUS_APP_DEFAUL;
            }
            if ([[NSUserDefaults standardUserDefaults] objectForKey:key_url_share]) {
                appDelegate.config.urlShare = [[NSUserDefaults standardUserDefaults] objectForKey:key_url_share];
            }
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:key_id_channel_default]) {
            appDelegate.config.iDchannelDefault = [[NSUserDefaults standardUserDefaults] objectForKey:key_id_channel_default];
        }else{
            appDelegate.config.iDchannelDefault = SELECTED_ID_CHANNEL_DEFAUL;
        }
        [self navigateToMainScreen];
    }];
}

- (void)navigateToMainScreen{
    appDelegate.window.rootViewController = appDelegate.navController;
    [appDelegate.window makeKeyAndVisible];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)initSubView{
    bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect tmpRect = self.view.frame;
    tmpRect.origin.x = tmpRect.size.width/2 - 20;
    tmpRect.origin.y = tmpRect.size.height/2 - 20;
    tmpRect.size.width = 40;
    tmpRect.size.height = 40;
    [loadingView setFrame:tmpRect];
    [self.view addSubview:bgView];
    [self.view addSubview:loadingView];
    [bgView setImage:[UIImage imageNamed:@"background_wave.png"]];
    [loadingView startAnimating];
}
@end
