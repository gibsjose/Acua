//
//  statsViewController.h
//  Acua
//
//  Created by Zachary Gill on 6/26/13.
//  Copyright (c) 2013 Zachary Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface statsViewController : UIViewController{
    bool menuOpen;
    NSString * databasePath;
    sqlite3 *statisticsDB;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *statsTitle;
@property (weak, nonatomic) IBOutlet UIButton *clearStatistics;

//menu elements
@property (weak, nonatomic) IBOutlet UIButton *statistics;

@property (weak, nonatomic) IBOutlet UIButton *options;
@property (weak, nonatomic) IBOutlet UIButton *goals;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UIButton *back;

//labels

@property (weak, nonatomic) IBOutlet UILabel *thisWeek;
@property (weak, nonatomic) IBOutlet UILabel *thisMonth;
@property (weak, nonatomic) IBOutlet UILabel *thisYear;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

//date elements
@property int day, month, year, week, count;

//avg elements
@property (weak, nonatomic) IBOutlet UILabel *averageTitle;
@property (weak, nonatomic) IBOutlet UILabel *averageDaily;

@property (weak, nonatomic) IBOutlet UILabel *averageWeekly;
@property (weak, nonatomic) IBOutlet UILabel *averageMonthly;
@property (weak, nonatomic) IBOutlet UILabel *averageYearly;



@end



