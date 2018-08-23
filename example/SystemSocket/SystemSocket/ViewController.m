//
//  ViewController.m
//  SystemSocket
//
//  Created by 肖旭晖 on 2018/8/23.
//  Copyright © 2018年 [简书](https://www.jianshu.com/p/e1d8b4eb0ecd). All rights reserved.
//

#import "ViewController.h"

#import "SocketStream.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SocketStream shareInstance] connectToHost];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
