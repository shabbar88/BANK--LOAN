# BANK LOAN ANALYTICS 💥
---
## Table of Contents:-
 - [Excel Dashboard Screenshot](#excel-dashboard-screenshot) 📷
 - [PowerBi Dahboard Screenshot](#powerbi-dashboard-screenshot) 📷
 - [Tableau Dashboard Screenshot](#tableau-dashboard-screenshot) 📷
 - [Project Overview](#project-overview) 🧑‍💻
 - [Data Sources](#data-sources) 📁
 - [Problem Statement](#problem-statement) ❓
 - [Tools](#Tools) 🛠️
 - [Data CLeaning](#data-cleaning) 🔨 
 - [Data Analysis](#data-analysis)  🧮
 - [Results](#results)  :suspect:
 - [Recommendation](#recommendation)  :basecamp:
 - [Project Files Location Links](#project-files-location-links)  📂
---
### Excel Dashboard Screenshot 
![bank_loan1](https://github.com/shabbar88/BANK--LOAN/assets/68353026/0204f917-0bea-4d2c-a8ae-f5968b480e3a)
---


## PowerBi Dashboard Screenshot
![bank_loan_powerbi](https://github.com/shabbar88/BANK--LOAN/assets/68353026/b685993e-d1ef-4cc4-a406-1309ef7d03b3)
---


## Tableau Dashboard Screenshot
![BANK_LOAN1_TABLEAU](https://github.com/shabbar88/BANK--LOAN/assets/68353026/3af8bc37-38ce-4531-bbda-f9475a2c5a79)
---

### **Project Overview**
---
This Data Analytics Project aims to provide insights into the loan of customer over numerous months. By analyzing various aspect of loan Data , we seek to identify trends, make data driven recommendation
and gain a deeper understanding of bank Performance. In this Project I solved the various loan related questions.
---

### Data Sources
---

Primary Dataset used for this project Analysis is Bank loan data containing detailed information about the loan in the bank.

[Bank Data](https://drive.google.com/drive/folders/1wc-gkqra5fnJE07QW6fUtMClRfpCJG4F?usp=sharing)
---

## **Problem Statement**
---
* 1> Year wise loan amount Stats
* 2> Grade and sub grade wise revol_bal
* 3> Total Payment for Verified Status Vs Total Payment for Non Verified Status
* 4> State wise and month wise loan status
* 5> Home ownership Vs last payment date stats

---
## Tools
 * Microsoft Excel
 * Microsoft PowerBi
 * Mysql
 * Tableau
---

 ## Data Cleaning
 
 ##Data Cleaning done on Power Query Editor on both Excel and PowerBi
 In the initial data preparation phase we performed the following tasks:
 * Data loading and inspection.
 * Handling missing values.
 * Data Cleaning and Formatting.
 * Removing Blank Rows.
---

## Data Analysis 
 🧑‍🔧 Include some code features worked with sql - 
  ``` sql
CREATE DATABASE BANK_LOAN_ANALYTICS;
USE BANK_LOAN_ANALYTICS;
CREATE TABLE finance_1(id int,member_id int,loan_amnt int,funded_amnt int,funded_amnt_inv float,
term varchar(255),int_rate varchar(5),installment float,grade varchar(5),sub_grade varchar(5),emp_title varchar(100),
emp_length varchar(55),home_ownership varchar(55),annual_inc int,verification_status varchar(55),
issue_d date,Year int, Month varchar(20),loan_status varchar(5),pymnt_plan varchar(55),descr varchar(255),purpose varchar(255),
title varchar(255),zip_code varchar(20),addr_state varchar(255),dti float );

select * from finance_1;

create table finance_2(id int,delinq_2yrs int,earliest_cr_line date,inq_last_6mths int,mths_since_last_delinq varchar(55),
mths_since_last_record varchar(55),open_acc int,pub_rec int,revol_bal int, revol_util varchar(5), total_acc int,
initial_list_status varchar(55),out_prncp int, out_prncp_inv int, total_pymnt float,total_pymnt_inv float, total_rec_prncp float, 
total_rec_int float,total_rec_late_fee float,recoveries float,collection_recovery_fee float,last_pymnt_d date, 
last_pymnt_amnt float,last_credit_pull_d date);

select * from finance_2;
/*
    INSERTING DATA INTO TABLES 
    =============================
    STEP1> GO TO PROGRAM LINES N COPY THE PATH OF MYSQL UP TO BIN FOLDER (C:\Program Files\MySQL\MySQL Server 8.0\bin)
    STEP2> GO TO COMMAND PROMPT AND WRITE CD PATH_TO_MYSQL 
    STEP3> WE WRITE mysql -u root -p  and enter then give pwd 
    STEP4> WRITE set GLOBAL local_infile=1; and then we write quit; 
    STEP5> CHOOSE THE DATABASE WHERE U WANNA INSERT DATA.. IN THIS CASE > USE bank_loan_analytics
    load data local infile 'E:\\finance_data\\Finance_1.csv' into table finance_1
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n IGNORE 1 ROWS';

load data local infile 'E:\\finance_data\\Finance_2.csv' into table finance_2
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n IGNORE 1 ROWS';
*/

#===========================================================================================================================
# 1> Year wise loan amount Stats

select Year,concat(round(sum(loan_amnt)/1000000,0)," M") as loan_amount from finance_1 group by Year order by Year;
#-----------------------------------------------------------------------------------------------------------------

# 2> Grade and sub grade wise revol_bal

select grade,sub_grade,concat(round(sum(revol_bal)/1000,0)," K") as total_revol_bal from finance_1 f1 join finance_2 f2 
on f1.id=f2.id group by grade,sub_grade order by grade;
#----------------------------------------------------------------------------------------------------------------------

# 3> Total Payment for Verified Status Vs Total Payment for Non Verified Status

select verification_status,concat("$",round(sum(total_pymnt)/1000000,0)," M") as total_payment from finance_1 f1 join finance_2 f2  
on f1.id=f2.id group by verification_status having verification_status in ('verified','Not verified');

#-------------------------------------------------------------------------------------------------------------------------
# 4> State wise and month wise loan status
    SELECT 
    addr_state,
    Month,loan_status,
    COUNT(loan_status) AS cnt_loan_status 
FROM 
    finance_1
GROUP BY 
    addr_state, Month,loan_status
ORDER BY 
    addr_state, 
    CASE 
        WHEN Month = 'January' THEN 1
        WHEN Month = 'February' THEN 2
        WHEN Month = 'March' THEN 3
        WHEN Month = 'April' THEN 4
        WHEN Month = 'May' THEN 5
        WHEN Month = 'June' THEN 6
        WHEN Month = 'July' THEN 7
        WHEN Month = 'August' THEN 8
        WHEN Month = 'September' THEN 9
        WHEN Month = 'October' THEN 10
        WHEN Month = 'November' THEN 11
        WHEN Month = 'December' THEN 12
    END;

#-----------------------------------------------------------------------------------------------------------------------

# 5> Home ownership Vs last payment date stats


SELECT home_ownership, last_pymnt_d, round(SUM(last_pymnt_amnt),2) AS total_pay_amount
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
WHERE home_ownership = "MORTGAGE" AND YEAR(last_pymnt_d) = 2008
GROUP BY home_ownership, last_pymnt_d order by last_pymnt_d;

#=========================================================================================================================v


 ```
---

### Results
---
Analysis results are summarized as follows:-
* 1> In the year 2007 total loan amount was 2 million dollar which  is minimum
   and in the year 2011 total loan amount was 261 million dollars which is maximum.
  
* 2>  For Grade A and Sub grade A5 total revol bal is 35303 K dollar, For Grade B and Sub Grade B5 total revol bal 37859 dollars,
  For Grade C and Sub Grade C1  total revol bal is 29385 K dollar,For Grade D and Sub Grade D2 total revol bal is 18571 K dollars,
  For Grade E and Sub Grade E1 total revol bal is 11133 K dollars, For Grade F and Sub Grade F1 total revol bal is 5841 K dollars
  and For Grade G and Sub Grade G1 total revol bal is 1809 K dollars.
  
* 3> Total Payment for Verified Status is 220 million dollar and for non verified is 154 million dollar.

* 4> For State AK in the month of December when loan status is fully carged then count of loan status is 10.
  
* 5>  When home ownership is "Mortgage" and last Payment is " 1 Oct 2008" then last paymentn amount is 52335.39 which is max,
   When home ownership is "own" and last Payment is " 1 June 2008" then last payment amount is 9624.64 which is max,
  When home ownership is "rent" and last Payment is " 1 Oct 2008" then last payment amount is 80236.03 which is max
---

## Recommendation
---
Based on the analysis we recommend the following actions:-

*

---

## Project Files Location Links
---
  *  Bank Loan Analytics [Excel Files Here](https://docs.google.com/spreadsheets/d/1l2r2RZi3eWhJXu6jvKUQakfLZUod2Fg_/edit?usp=drive_link&ouid=105011731887114377849&rtpof=true&sd=true)
     
  *  Bank Loan Analytics [Power Bi Files Here] (https://drive.google.com/file/d/1BB0zfR0AGTAj_rWJ6OtkMAEsufd-jbMn/view?usp=drive_link)
    
  *  Bank Loan Analytics [Tableau Files Here] (https://drive.google.com/file/d/1YNdQEd99d6JPyXP2QyPYAwuwnZW9vgJz/view?usp=drive_link)

  * Bank Loan Analytics [SQL Script Here] (https://drive.google.com/file/d/1FUv4LhDNig0e79s_CLkB3QC4N1raWV6v/view?usp=drive_link)

---

   




