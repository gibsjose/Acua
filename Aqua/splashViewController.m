//
//  splashViewController.m
//  Aqua
//
//  Created by Zachary Gill on 6/22/13.
//  Copyright (c) 2013 Zachary Gill. All rights reserved.
//

#import "splashViewController.h"

@interface splashViewController ()

@end


@implementation splashViewController

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
    addOpen = NO;
    mL = YES;
    L = NO;
    oz = NO;
    self.addView.hidden = YES;
    
    NSDate *date = [NSDate date];
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [myCalendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit)fromDate:date];
    self.year = [components year];
    self.month = [components month];
    self.day = [components day];
    self.week = [components week];
    [self defineTextElements];
    [self defineDatabase];
    [self checkDay];
    [self extractDailyAmount];
    //NSLog(@"%i", self.drankToday);
    if (self.drankToday >= 1000) {
        double literAmount = (double)self.drankToday;
        literAmount = (literAmount * .001);
        NSString* updatedAmount = [NSString stringWithFormat:@"%.1f", literAmount];
        self.drankTodayLabel.text = updatedAmount;
        self.unitLabel.text = @"L";
    }
    else{
        self.drankTodayLabel.text = [NSString stringWithFormat:@"%i", self.drankToday];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void) defineTextElements {
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AdventPro-Light" size:20] forKey:UITextAttributeFont];
    [self.segmentedMes setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    self.drankTodayLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:65];
    self.unitLabel.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.menuLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.goals.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.statistics.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.options.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];
    self.addWaterLabel.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.addTextField.font = [UIFont fontWithName:@"AdventPro-Regular" size:20];
    self.amountEnteredButton.titleLabel.font = [UIFont fontWithName:@"AdventPro-Light" size:20];

}

- (void) checkDay {

    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;

    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT day, counter FROM stats WHERE counter!=null"];
    
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int lastDay, curCount;
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
             NSString *day = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                lastDay = [day integerValue];
            NSString *countString = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                curCount = [countString integerValue];
                //NSLog(countString);
            }
            if (sqlite3_step(statement) != SQLITE_ROW) {
                self.counter = 1;
                self.drankToday = 0;
            }
            else {
                self.counter = curCount;
                if (lastDay != self.day){
                    self.counter++;
                    self.drankToday = 0;
                    NSString* updatedAmount = [NSString stringWithFormat:@"%i", self.drankToday];
                    self.drankTodayLabel.text = updatedAmount;
                }
            }
        sqlite3_finalize(statement);
        }
    sqlite3_close(statisticsDB);
    }
}


- (void) defineDatabase {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"stats.db"]];
    
   // NSFileManager *filemgr = [NSFileManager defaultManager];
    
    
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS STATS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DAY INTEGER, MONTH INTEGER, YEAR INTEGER, AMOUNT INTEGER, WEEK INTEGER, COUNTER INTEGER)";
            
            sqlite3_exec(statisticsDB, sql_stmt, NULL, NULL, &errMsg);
            sqlite3_close(statisticsDB);
        }
}

- (void) saveData
{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO STATS (day, month, year, amount, week, counter) VALUES (\"%i\", \"%i\", \"%i\",\"%i\",\"%i\",\"%i\")", self.day, self.month, self.year, self.nAmount, self.week, self.counter];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(statisticsDB, insert_stmt, -1, &statement, NULL);
        
        self.nAmount = 0;
        
        sqlite3_finalize(statement);
        sqlite3_close(statisticsDB);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)menuPressed:(id)sender {
    //flyout menu control
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



- (IBAction)addPressed:(id)sender {
    if (addOpen == NO){
        CGRect frame = self.topView.frame;
        frame.origin.x = -320;
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.topView.frame = frame;
        [UIView commitAnimations];
        addOpen = YES;
        self.addView.hidden = NO;
        self.addButton.hidden = YES;
        self.addTextField.text = @"";
    }
}

- (IBAction)amountEntered:(id)sender {
    CGRect frame= self.topView.frame;
    frame.origin.x = 0;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.topView.frame = frame;
    
    [UIView commitAnimations];
    
    addOpen = NO;
    self.addView.hidden = YES;
    self.addButton.hidden = NO;
    [self.view endEditing:NO];
    int numIn = 0;
    NSString *stringIn = self.addTextField.text;
    numIn = [stringIn intValue];
    if (oz == YES) {
        numIn = (numIn / .033814);
    }
    if (L == YES){
        numIn = (numIn * 1000);
    }
    self.drankToday += numIn;
    self.nAmount = self.drankToday;
    if (self.drankToday >= 1000) {
        double literAmount = (double)self.drankToday;
         literAmount = (literAmount * .001);
        self.drankTodayLabel.text = [NSString stringWithFormat:@"%.1f", literAmount];
        self.unitLabel.text = @"L";
    }
    else{
    self.drankTodayLabel.text = [NSString stringWithFormat:@"%i", self.drankToday];
    self.unitLabel.text = @"mL";

    }
    
    [self saveData];
    //[self extractData];
    
}


- (IBAction)mesChanged:(id)sender {
    if (Segment.selectedSegmentIndex == 0) {
        mL = YES;
        L = NO;
        oz = NO;
    }
    if (Segment.selectedSegmentIndex == 1) {
        mL = NO;
        L = YES;
        oz = NO;
    }
    if (Segment.selectedSegmentIndex == 2) {
        mL = NO;
        L = NO;
        oz = YES;
    }
}



- (void)extractDailyAmount {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &statisticsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT amount FROM stats WHERE day=\"%i\" AND month=\"%i\" AND year=\"%i\"", self.day, self.month, self.year];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(statisticsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int todaysDrank = 0;
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *amount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                int newEntry = [amount integerValue];
                todaysDrank += newEntry;
                
            }
            self.drankToday = todaysDrank;
            sqlite3_finalize(statement);
        }
        sqlite3_close(statisticsDB);
    }
}
























@end
