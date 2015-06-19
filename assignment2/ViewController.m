//
//  ViewController.m
//  assignment2
//
//  Created by Muppala, Goutham Krishna Teja (UMKC-Student) on 6/19/15.
//  Copyright (c) 2015 Muppala, Goutham Krishna Teja (UMKC-Student). All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#define BASE_URL "http://api.skybiometry.com/fc/faces/detect.json?api_key=5c7ab188e789451fba822cd07c8cc1a6&api_secret=3cf2487383e749c09a74c53e5df573dc&urls="
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *sentenceTextField;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Recognise:(id)sender {
    
    [_sentenceTextField resignFirstResponder];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *sentense = [_sentenceTextField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlrest=@"&attributes=all";
    
    NSString *url = [NSString stringWithFormat:@"%s%@%@", BASE_URL,sentense, urlrest];
    NSLog(@"%@", url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *array=[responseObject objectForKey:@"photos"];
        NSDictionary *dict=[array objectAtIndex:0];
        NSArray *array1=[dict objectForKey:@"tags"];
        NSDictionary *dict1=[array1 objectAtIndex:0];
        NSDictionary *dict2=[dict1 objectForKey:@"attributes"];
        NSDictionary *dict3=[dict2 objectForKey:@"gender"];
        NSString *v_1=[dict3 objectForKey:@"value"];
        
        NSString *v_2=[[dict2 objectForKey:@"age_est"] objectForKey:@"value"];

        
        NSLog (@"%@", v_1);
        NSLog (@"%@", v_2);
        
        ///messaging part of code
        
        NSString *kTwilioSID = @"ACd359ee9e16ba9811ff0d85cc1c913ed8";
        NSString *kTwilioSecret = @"8cfaecfeae6fd12b219e6eef52684cd5";
        NSString *kFromNumber = @"9136530811";
        NSString *kToNumber = @"+12817160359";
        NSString *kMessage = @"Please%20help%20me.I%20Person%20Features%20are%20";
        NSString *gen=@"gender";
        NSString *est_age=@"estimated_age";
        
        NSString *concat = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", kMessage,gen,v_1,est_age,v_2];
        
        // Build request
        NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        
        // Set up the body
        NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, concat];
        NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSError *error;
        NSURLResponse *response;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // Handle the received data
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
            NSLog(@"Request sent. %@", receivedString);
            
        }

        
        
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }];
}

@end




