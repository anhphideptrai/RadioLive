//
//  ChannelsViewController.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/20/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#import "ChannelsViewController.h"
#import "SQLiteManager.h"
#import <SVSegmentedControl.h>
#import "AppDelegate.h"

@interface ChannelsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *channelList;
    NSMutableDictionary *sections;
    NSIndexPath *lastSelected;
    SVSegmentedControl *redSC;
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *contentTableView;

@end

@implementation ChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self loadDataForViewWithAllChannel:YES];
    
    redSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"All", @"Favorite", nil]];
    [redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    redSC.crossFadeLabelsOnDrag = YES;
    redSC.height = 32.f;
    redSC.thumb.tintColor = _red_color_;
    [redSC setSelectedSegmentIndex:0 animated:NO];
    [self.view addSubview:redSC];
}
- (void)loadDataForViewWithAllChannel:(BOOL)isAllChannels{
    if (isAllChannels) {
        channelList = [[SQLiteManager getInstance] getChannels];
    }else{
        channelList = [[SQLiteManager getInstance] getFavoriteChannels];
    }
    sections = [[NSMutableDictionary alloc] init];
    [self prepareDataForView];
    [self.contentTableView setBounces:YES];
    [self.contentTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    redSC.center = CGPointMake(self.contentTableView.frame.size.width/2, (64 - 20)/2 + 20);
}

- (void)prepareDataForView{
    BOOL found;
    for (RadioChannel *channel in channelList) {
        NSString *c = [[channel.title substringToIndex:1] uppercaseString];
        found = NO;
        for (NSString *str in [sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        if (!found)
        {
            [sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    // Loop again and sort the books into their respective keys
    for (RadioChannel *channel in channelList)
    {
        [[sections objectForKey:[[channel.title uppercaseString] substringToIndex:1]] addObject:channel];
    }
}

#pragma mark - UIControlEventValueChanged
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
    [self loadDataForViewWithAllChannel:segmentedControl.selectedSegmentIndex == 0];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{return [[sections allKeys] count];;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToolBackground.png"]]; //set your image/
    
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 205, 15)];//set as you need
    [headerLbl setTextColor:[UIColor lightGrayColor]];
    headerLbl.backgroundColor = [UIColor clearColor];
    headerLbl.text = [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    [headerImage addSubview:headerLbl];
    
    headerImage.frame = CGRectMake(0, 0, tableView.bounds.size.width, 22);
    
    [headerView addSubview:headerImage];
    
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    RadioChannel *channel = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [cell.textLabel setFont:_CONTACT_TITLE_CELL_FONT_];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setText:channel.title];
    
    [cell.detailTextLabel setFont:_CONTACT_SUBTITLE_CELL_FONT_];
    [cell.detailTextLabel setTextColor:_orange_color_];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"# %@", channel.pkey];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *backgroudCell = [[UIImageView alloc] init];
    [backgroudCell setAlpha:.5f];
    [backgroudCell setImage:[UIImage imageNamed:@"darkBackground.png"]];
    [cell setBackgroundView:backgroudCell];
    
    UIImageView *backgroudSelectedCell = [[UIImageView alloc] init];
    [backgroudSelectedCell setAlpha:.5f];
    [backgroudSelectedCell setImage:[UIImage imageNamed:@"Cell_Selected.png"]];
    [cell setSelectedBackgroundView:backgroudSelectedCell];
    [cell setTintColor:_orange_color_];
    [cell setAccessoryView:nil];
    if ([[channel.pkey lowercaseString] isEqualToString:[appDelegate.config.iDchannelDefault lowercaseString]]) {
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckSelected.png"]]];
        lastSelected = indexPath;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RadioChannel *channel = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if (![[channel.pkey lowercaseString] isEqualToString:[appDelegate.config.iDchannelDefault lowercaseString]]){
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckSelected.png"]]];
        if (lastSelected) {
            UITableViewCell* lastCell = [tableView cellForRowAtIndexPath:lastSelected];
            [lastCell setAccessoryView:nil];
        }
        lastSelected = indexPath;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedChannel:)]) {
            [[NSUserDefaults standardUserDefaults] setValue:channel.pkey forKey:key_id_channel_default];
            [[NSUserDefaults standardUserDefaults] synchronize];
            appDelegate.config.iDchannelDefault = channel.pkey;
            [self.delegate didSelectedChannel:channel];
        }
    }
}

@end
