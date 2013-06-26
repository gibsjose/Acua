//
//  splashViewController.h
//  Aqua
//
//  Created by Zachary Gill on 6/22/13.
//  Copyright (c) 2013 Zachary Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface splashViewController : UIViewController{
    BOOL menuOpen;
    BOOL addOpen;
    BOOL mL;
    BOOL L;
    BOOL oz;
    IBOutlet UISegmentedControl *Segment;
    NSString * databasePath;
    sqlite3 *statisticsDB;
    
}

@property int day, month, year, nAmount, drankToday, week, counter;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;


//labels

@property (weak, nonatomic) IBOutlet UILabel *drankTodayLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UILabel *menuLabel;


//menu buttons
@property (weak, nonatomic) IBOutlet UIButton *goals;
@property (weak, nonatomic) IBOutlet UIButton *statistics;
@property (weak, nonatomic) IBOutlet UIButton *options;




//add buttons

@property (weak, nonatomic) IBOutlet UIButton *amountEnteredButton;

//add view
@property (weak, nonatomic) IBOutlet UIView *addView;

@property (weak, nonatomic) IBOutlet UITextField *addTextField;

@property (weak, nonatomic) IBOutlet UILabel *addWaterLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedMes;

@end
