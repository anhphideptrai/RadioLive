//
//  ChannelsViewController.m
//  Hungary Radio Live
//
//  Created by Phi Nguyen on 12/20/14.
//  Copyright (c) 2014 Thien Nguyen. All rights reserved.
//

#import "ChannelsViewController.h"
#import "Channel.h"

@interface ChannelsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *channelList;
    NSMutableDictionary *sections;
    NSIndexPath *lastSelected;
}
@property (strong, nonatomic) IBOutlet UITableView *contentTableView;

@end

@implementation ChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    channelList = [[NSMutableArray alloc] init];
    sections = [[NSMutableDictionary alloc] init];
    Channel *channel = [[Channel alloc] init];
    [channel setName:@"new york"];
    [channel setLocation:@"no name"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"FM"];
    [channel setLocation:@"Ho Chi Minh"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"AM"];
    [channel setLocation:@"Sai Gon"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"VOA Special"];
    [channel setLocation:@"USA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Spotlight English"];
    [channel setLocation:@"CANADA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Hungary Radio"];
    [channel setLocation:@"Hungary"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"VOA Special"];
    [channel setLocation:@"USA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Spotlight English"];
    [channel setLocation:@"CANADA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Hungary Radio"];
    [channel setLocation:@"Hungary"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"VOA Special"];
    [channel setLocation:@"USA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Spotlight English"];
    [channel setLocation:@"CANADA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Hungary Radio"];
    [channel setLocation:@"Hungary"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"VOA Special"];
    [channel setLocation:@"USA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Spotlight English"];
    [channel setLocation:@"CANADA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Hungary Radio"];
    [channel setLocation:@"Hungary"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"VOA Special"];
    [channel setLocation:@"USA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Spotlight English"];
    [channel setLocation:@"CANADA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Hungary Radio"];
    [channel setLocation:@"Hungary"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"VOA Special"];
    [channel setLocation:@"USA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Spotlight English"];
    [channel setLocation:@"CANADA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Hungary Radio"];
    [channel setLocation:@"Hungary"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"VOA Special"];
    [channel setLocation:@"USA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Spotlight English"];
    [channel setLocation:@"CANADA"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"Hungary Radio"];
    [channel setLocation:@"Hungary"];
    [channelList addObject:channel];
    
    channel = [[Channel alloc] init];
    [channel setName:@"LIVE Program"];
    [channel setLocation:@"Live"];
    [channelList addObject:channel];
    [self prepareDataForView];
    [self.contentTableView setBounces:YES];
    [self.contentTableView reloadData];
    
}
- (void)prepareDataForView{
    BOOL found;
    for (Channel *channel in channelList) {
        NSString *c = [[channel.name substringToIndex:1] uppercaseString];
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
    for (Channel *channel in channelList)
    {
        [[sections objectForKey:[[channel.name uppercaseString] substringToIndex:1]] addObject:channel];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{return [[sections allKeys] count];;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"ToolBackground" ofType:@"png"]]]; //set your image/
    
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
    Channel *channel = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [cell.textLabel setFont:_CONTACT_TITLE_CELL_FONT_];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setText:channel.name];
    
    [cell.detailTextLabel setFont:_CONTACT_SUBTITLE_CELL_FONT_];
    [cell.detailTextLabel setTextColor:_orange_color_];
    cell.detailTextLabel.text = channel.location;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *backgroudCell = [[UIImageView alloc] init];
    [backgroudCell setAlpha:.5f];
    [backgroudCell setImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"darkBackground" ofType:@"png"]]];
    [cell setBackgroundView:backgroudCell];
    
    UIImageView *backgroudSelectedCell = [[UIImageView alloc] init];
    [backgroudSelectedCell setAlpha:.5f];
    [backgroudSelectedCell setImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"Cell_Selected" ofType:@"png"]]];
    [cell setSelectedBackgroundView:backgroudSelectedCell];
    [cell setTintColor:_orange_color_];
    [cell setAccessoryView:nil];
    if (lastSelected && [indexPath compare:lastSelected] == NSOrderedSame) {
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"CheckSelected" ofType:@"png"]]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([indexPath compare:lastSelected] != NSOrderedSame){
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"CheckSelected" ofType:@"png"]]]];
        if (lastSelected) {
            UITableViewCell* lastCell = [tableView cellForRowAtIndexPath:lastSelected];
            [lastCell setAccessoryView:nil];
        }
        lastSelected = indexPath;
    }
}

@end
