//
//  LoadingViewController.m
//  ExampleObjC
//
//  Created by divbyzero on 02/10/2019.
//  Copyright © 2019 EvolvKit. All rights reserved.
//

#import "LoadingViewController.h"
#import "EvolvClientHelper.h"

@interface LoadingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EvolvClientHelper shared] setDidChangeClientStatus:^(enum EvolvClientStatus status) {
        switch (status) {
            case EvolvClientStatusReady:
                [self performSegueWithIdentifier:@"showMain" sender:nil];
                break;
            case EvolvClientStatusFailed:
                [[self label] setText:@"Evolv Client - Failed to load data"];
            default:
                break;
        }
    }];
}

@end
