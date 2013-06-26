//
//  statsViewController.m
//  Acua
//
//  Created by Zachary Gill on 6/26/13.
//  Copyright (c) 2013 Zachary Gill. All rights reserved.
//

#import "statsViewController.h"

@interface statsViewController ()

@end

@implementation statsViewController

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
	// Do any additional setup after loading the view.
    menuOpen = NO;
    NSDate *date = [NSDate date];
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [myCalendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit)fromDate:date];
    
    self.year = [components year];
    self.month = [components month];
    self.day = [components day];
    self.week = [components week];
    [self setTextElements];
    [self defineDBPath];
    [self extractWeeklyAmount];
    [self extractMonthlyAmount];
    [self extractYearlyAmount];
    [self getCount];
    [self extractAverageAmounts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTextElements{
    self.menuLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.goals.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.statistics.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.options.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.back.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.statsTitle.font = [UIFont fontWithName:@"AdventPro-Regular" size:30];
    self.thisWeek.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.thisMonth.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.thisYear.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.weekLabel.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.monthLabel.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.yearLabel.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.clearStatistics.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.averageTitle.font = [UIFont fontWithName:@"AdventPro-Regular" size:25];
    self.averageDaily.font = [UIFont fontWithName:@"AdventPro-Regular" size:17];
    self.averageWeekly.font = [UIFont fontWithName:@"AdventPro-Regular" size:17];
    self.averageMonthly.font = [UIFont fontWithName:@"AdventPro-Regular" size:17];
    self.averageYearly.font = [UIFont fontWithName:@"AdventPro-Regular" size:17];
}

- (IBAction)menuPressed:(id)sender {
    if (menuOpen == NO){
        CGRect frame = self.topView.frame;
        frame.origin.x = 170;
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.topView.frame = frame;
        [UIView commitAnimations];
        menuOpen = YES;
        self.menuButton.hidden = YES;
    }
}

- (IBAction)swipeClose:(id)sender {
    CGRect frame= self.topView.frame;
    frame.origin.x = 0;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.topView.frame = frame;
    [UIView commitAnimations];
    menuOpen = NO;
    self.menuButton.hidden = NO;
}

- (void)defineDBPath{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"stats.db"]];
}

- (void)extractWeeklyAmount {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT amount FROM stats WHERE week=\"%i\" AND YEAR=\"%i\"", self.week, self.year];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int weeklyWater = 0;
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *amount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                int newEntry = [amount integerValue];
                weeklyWater += newEntry;
                
            }
            if (weeklyWater < 1000){
                self.weekLabel.text = [NSString stringWithFormat:@"%i mL", weeklyWater];
            }
            else{
                double litersWeekly = (double)weeklyWater;
                litersWeekly = (litersWeekly / 1000.0);
                self.weekLabel.text = [NSString stringWithFormat:@"%.1f L", litersWeekly];
            }
            if (weeklyWater >= 21000) {
                self.weekLabel.textColor = [UIColor greenColor];
            }
            else{
                self.weekLabel.textColor = [UIColor redColor];
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(statisticsDB);
    
    }
}

- (void)extractMonthlyAmount {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT amount FROM stats WHERE month=\"%i\" AND YEAR=\"%i\"", self.month, self.year];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int monthlyWater = 0;
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *amount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                int newEntry = [amount integerValue];
                monthlyWater += newEntry;
                
            }
            if (monthlyWater < 1000){
                self.monthLabel.text = [NSString stringWithFormat:@"%i mL", monthlyWater];
            }
            else{
                double litersMonthly = (double)monthlyWater;
                litersMonthly = (litersMonthly / 1000.0);
                self.monthLabel.text = [NSString stringWithFormat:@"%.1f L", litersMonthly];
            }
            if (monthlyWater >= 84000) {
                self.monthLabel.textColor = [UIColor greenColor];
            }
            else{
                self.monthLabel.textColor = [UIColor redColor];
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(statisticsDB);
        
    }
}

- (void)extractYearlyAmount {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT amount FROM stats WHERE YEAR=\"%i\"", self.year];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int yearlyWater = 0;
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *amount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                int newEntry = [amount integerValue];
                yearlyWater += newEntry;
                
            }
            if (yearlyWater < 1000){
                self.yearLabel.text = [NSString stringWithFormat:@"%i mL", yearlyWater];
            }
            else{
                double litersYearly = (double)yearlyWater;
                litersYearly = (litersYearly / 1000.0);
                self.yearLabel.text = [NSString stringWithFormat:@"%.1f L", litersYearly];
            }
            if (yearlyWater >= 1095000) {
                self.yearLabel.textColor = [UIColor greenColor];
            }
            else{
                self.yearLabel.textColor = [UIColor redColor];
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(statisticsDB);
        
    }
}

- (IBAction)clearPressed:(id)sender {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DROP TABLE stats"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            self.weekLabel.text = @"0 ml";
            
            self.monthLabel.text = @"0 ml";
        
            self.yearLabel.text = @"0 ml";
            
            
            
        }
        sqlite3_close(statisticsDB);
        //[self defineDatabase];
    }
}

- (void)extractAverageAmounts {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT amount FROM stats"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int allWater = 0;
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *amount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                int newEntry = [amount integerValue];
                allWater += newEntry;
                
            }
            
            sqlite3_finalize(statement);
            double dubAll = (double)allWater;
            dubAll = (dubAll * .001);
            double daily, monthly, weekly, yearly;
            daily = (dubAll/self.count);
            weekly = (daily * 7);
            monthly = (weekly * 4);
            yearly = (daily * 365);
            self.averageDaily.text = [NSString stringWithFormat:@"%.1f L daily", daily];
            self.averageWeekly.text = [NSString stringWithFormat:@"%.1f L weekly", weekly];
            self.averageMonthly.text = [NSString stringWithFormat:@"%.1f L monthly", monthly];
            self.averageYearly.text = [NSString stringWithFormat:@"%.1f L yearly", yearly];
        }
        sqlite3_close(statisticsDB);
        
    }
    
    
}

- (void) getCount {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT counter FROM stats"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int curCount = 0;
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *countString = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                curCount = [countString integerValue];
            }
            self.count = curCount;
            sqlite3_finalize(statement);
        }
        sqlite3_close(statisticsDB);
    }
}


@end
