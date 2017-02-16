//
//  ViewController.m
//  mySocialApp
//
//  Created by SnehaPriya Ale on 1/25/17.
//  Copyright © 2017 snehapriyaale. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.refreshBtn.enabled = NO;
    self.logoutBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAction:(UIButton *)sender {
        [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Instagram"];

}

@end
