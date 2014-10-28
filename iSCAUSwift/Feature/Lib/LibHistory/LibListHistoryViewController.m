//
//  LibListHistoryViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-11.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "LibListHistoryViewController.h"
#import "CardStyleView.h"
#import "LibListHistoryCell.h"
#import "UIImage+Tint.h"
#import "AZTools.h"
#import "iSCAUSwift-Swift.h"

#define CELL_HEIGHT 122;

@interface LibListHistoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) BOOL isReloading;
@property (nonatomic, weak) IBOutlet UITableView *tableListHistory;
@property (nonatomic, strong) NSMutableArray *booksArray;
@end

@implementation LibListHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史借阅";
    
    SET_DEFAULT_BACKGROUND_COLOR(self.tableListHistory);
    
    self.booksArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    if ([Utils stuNum].length < 1 || [Utils libPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }
    if (self.isReloading) {
        return;
    }
    self.isReloading = YES;
    SHOW_WATING_HUD;
    
    [LibHttpManager borrowedBooksWithCompletionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id data, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.isReloading = NO;
        HIDE_ALL_HUD
        if (response.statusCode == kStatusCodeSuccess) {
            self.booksArray = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"books"]];
            [self.tableListHistory reloadData];
        }
    }];
    
//    [[LibHttpClient shareInstance]
//     libListHistorySuccess:^(NSData *responseData, NSInteger httpCode){
//         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
//         self.isReloading = NO;
//         HIDE_ALL_HUD;
//         if (httpCode == 200) {
//             self.booksArray = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"books"]];
//             [self.tableListHistory reloadData];
//         }
//     }failure:^(NSData *responseData, NSInteger httpCode){
//         self.isReloading = NO;
//     }];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.booksArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *LibListHistoryCellIndentifier = @"LibListHistoryCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LibListHistoryCellIndentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"LibListHistoryCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [(LibListHistoryCell *)cell configurateInfo:self.booksArray[indexPath.row]];
    
    return cell;
}

@end
