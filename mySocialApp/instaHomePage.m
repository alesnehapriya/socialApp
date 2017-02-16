//
//  instaHomePage.m
//  mySocialApp
//
//  Created by SnehaPriya Ale on 1/25/17.
//  Copyright © 2017 snehapriyaale. All rights reserved.
//

#import "instaHomePage.h"
#import "NXOAuth2.h"


@interface instaHomePage()
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;

@end

@implementation instaHomePage
- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    NSArray *instagramAccount = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"Instagram"];
    
    if([instagramAccount count] == 0){
        NSLog(@"Accounts Logged in %ld",(long)[instagramAccount count]);
        return;
    }
    
    NXOAuth2Account *Acct = instagramAccount[0];
    NSString *token = Acct.accessToken.accessToken;
    
    NSString *urlStr = [@"https://api.instagram.com/v1/users/self/media/recent/?access_token=" stringByAppendingString:token];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        if(error){
            NSLog(@"Error");
            return ;
        }
        
        NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *) response;
        
        if(httpRes.statusCode <200 || httpRes.statusCode >= 300){
            NSLog(@"Error");
            return;
        }


        NSError *parseErr;
        id pkg = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseErr];
        
        
        if(!pkg){
            NSLog(@"Errr");
            return;
        }
        
        NSString *imgURLStr = pkg[@"data"][0][@"images"][@"standard_resolution"][@"url"];
        NSURL *imageURL = [NSURL URLWithString:imgURLStr];
        [[session dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
            
            if(error){
                NSLog(@"Error");
                return ;
            }
            
            NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *) response;
            
            if(httpRes.statusCode <200 || httpRes.statusCode >= 300){
                NSLog(@"Error");
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imagePic.image = [UIImage imageWithData:data];
            });
            
            
        }]resume];
        
    }]resume];

}

- (IBAction)logoutAction:(UIBarButtonItem *)sender {
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    NSArray *instagramAccount = [store accountsWithAccountType:@"Instagram"];
    
    for(id account in instagramAccount){
        [store removeAccount:account];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(navigateToLogin) withObject:nil afterDelay:0.50];
}

- (void)navigateToLogin {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
