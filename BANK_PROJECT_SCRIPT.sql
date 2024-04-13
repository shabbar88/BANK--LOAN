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

#=========================================================================================================================
























