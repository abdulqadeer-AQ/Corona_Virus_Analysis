SELECT * FROM [Corona Virus Analysis]..['Corona Virus Dataset']
ORDER BY Date,[Country/Region]
--Q1. Write a code to check NULL values
SELECT COUNT(*) AS Null_Values FROM [Corona Virus Analysis]..['Corona Virus Dataset'] AS cvd
WHERE cvd.Province IS NULL
OR cvd.[Country/Region] IS NULL
OR cvd.Latitude IS NULL
OR cvd.Longitude IS NULL
OR cvd .Date IS NULL
OR cvd.Confirmed IS NULL 
OR cvd.Deaths IS NULL
OR cvd.Recovered IS NULL

--check total number of rows
SELECT COUNT(*) AS Toal_Rows 
FROM [Corona Virus Analysis]..['Corona Virus Dataset']

--Check what is start_date and end_date

SELECT MIN(Date) AS Start_Date , MAX(Date) AS End_Date
FROM [Corona Virus Analysis]..['Corona Virus Dataset']

--Number of month present in dataset

SELECT COUNT(DISTINCT CONCAT(YEAR(Date),'-',MONTH(Date))) AS Total_Month
FROM [Corona Virus Analysis]..['Corona Virus Dataset']

--Find monthly average for confirmed, deaths, recovered
ALTER DATABASE [Corona Virus Analysis] 
SET COMPATIBILITY_LEVEL = 120;


WITH Average_Calculation AS (
SELECT YEAR(Date) AS Year,MONTH(Date) AS Month,
SUM(Confirmed) AS Total_Confirmed,SUM(Deaths) AS Total_Deaths,
SUM(Recovered) AS Total_Recovers,COUNT(*) AS Dayscount
FROM [Corona Virus Analysis]..['Corona Virus Dataset'] 
GROUP BY YEAR(Date),MONTH(Date))
SELECT Year,Month,
Total_Confirmed/Dayscount AS Average_Confirmed,
Total_Deaths/Dayscount AS Average_Deaths,
Total_Recovers/Dayscount AS Average_Recovered
FROM Average_Calculation
ORDER BY Year,Month

--Find most frequent value for confirmed, deaths, recovered each month 

WITH MOSTFREQUENTVALUE AS(
SELECT YEAR(Date) AS Year,MONTH(Date) AS Month,MAX(Confirmed) AS Max_Confirmed_Value,
MAX(Deaths) AS Max_Death_Value,MAX(Recovered) AS Max_Recovered_Value
FROM [Corona Virus Analysis]..['Corona Virus Dataset'] 
GROUP BY YEAR(Date),MONTH(Date))
SELECT Year,Month,Max_Confirmed_Value,Max_Death_Value,Max_Recovered_Value
FROM MOSTFREQUENTVALUE
ORDER BY Year,Month

--Q8. Find minimum values for confirmed, deaths, recovered per year

WITH MINFREQUENTVALUE AS(
SELECT YEAR(Date) AS Year,
MIN(CASE WHEN Confirmed > 0 THEN Confirmed ELSE NULL END) AS Min_Confirmed_Value,
MIN(CASE WHEN Deaths > 0 THEN Deaths ELSE NULL END) AS Min_Death_Value,
MIN(CASE WHEN Recovered > 0 THEN Recovered ELSE NULL END) AS Min_Recovered_Value
FROM [Corona Virus Analysis]..['Corona Virus Dataset'] 
GROUP BY YEAR(Date))
SELECT Year,Min_Confirmed_Value,Min_Death_Value,Min_Recovered_Value
FROM MINFREQUENTVALUE
ORDER BY Year

--Q9. Find maximum values of confirmed, deaths, recovered per year

WITH MAXVALUE AS(
SELECT YEAR(Date) AS Year,MAX(Confirmed) AS Max_Confirmed_Value,
MAX(Deaths) AS Max_Death_Value,MAX(Recovered) AS Max_Recovered_Value
FROM [Corona Virus Analysis]..['Corona Virus Dataset'] 
GROUP BY YEAR(Date))
SELECT Year,Max_Confirmed_Value,Max_Death_Value,Max_Recovered_Value
FROM MAXVALUE
ORDER BY Year

--Q10. The total number of case of confirmed, deaths, recovered each month

WITH TOTALCASES AS(
SELECT YEAR(Date) AS Year,MONTH(Date) AS Month,SUM(Confirmed) AS Total_Confirmed_Value,
SUM(Deaths) AS Total_Death_Value,SUM(Recovered) AS Total_Recovered_Value
FROM [Corona Virus Analysis]..['Corona Virus Dataset'] 
GROUP BY YEAR(Date),MONTH(Date))
SELECT Year,Month,Total_Confirmed_Value,Total_Death_Value,Total_Recovered_Value
FROM TOTALCASES
ORDER BY Year,Month

--Q11. Check how corona virus spread out with respect to confirmed case
--(Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    SUM(Confirmed) AS Total_Confirmed_Cases,
    AVG(Confirmed) AS Average_Confirmed_Cases,
    VAR(Confirmed) AS Variance_Confirmed_Cases,
    STDEV(Confirmed) AS Stdev_Confirmed_Cases
FROM [Corona Virus Analysis]..['Corona Virus Dataset']
WHERE Confirmed > 0;

--Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

WITH DEATHPERMONTH AS(
SELECT YEAR(Date) AS Year, MONTH(Date) AS Month,
    SUM(Deaths) AS Total_Deaths_Cases,
    AVG(Deaths) AS Average_Deaths_Cases,
    VAR(Deaths) AS Variance_Deaths_Cases,
    STDEV(Deaths) AS Stdev_Deaths_Cases
FROM [Corona Virus Analysis]..['Corona Virus Dataset']
WHERE Deaths >0
GROUP BY YEAR(Date),MONTH(Date))
SELECT Year,Month,Total_Deaths_Cases,Average_Deaths_Cases,
Variance_Deaths_Cases,Stdev_Deaths_Cases
FROM DEATHPERMONTH 
ORDER BY Year,Month


 --Q13. Check how corona virus spread out with respect to recovered case
 --     (Eg.: total confirmed cases, their average, variance & STDEV )

 SELECT 
    SUM(Recovered) AS Total_Recovered_Cases,
    AVG(Recovered) AS Average_Recovered_Cases,
    VAR(Recovered) AS Variance_Recovered_Cases,
    STDEV(Recovered) AS Stdev_Recovered_Cases
FROM [Corona Virus Analysis]..['Corona Virus Dataset']
WHERE Recovered > 0;

-- Q14 Find Country having highest number of the Confirmed case

SELECT TOP 1 [Country/Region], SUM(Confirmed) AS MAXTotal_Confirmed
FROM [Corona Virus Analysis]..['Corona Virus Dataset']
Group BY [Country/Region]
ORDER BY MAXTotal_Confirmed DESC

-- Q15 Find Country having lowest number of the death case

SELECT TOP 1 [Country/Region], SUM(Deaths) AS Lowest_Death_Cases
FROM [Corona Virus Analysis]..['Corona Virus Dataset']
Group BY [Country/Region]
ORDER BY Lowest_Death_Cases 

--Q16 Find top 5 countries having highest recovered case

SELECT TOP 5 [Country/Region], SUM(Recovered) AS MAX_Recovered_Cases
FROM [Corona Virus Analysis]..['Corona Virus Dataset']
Group BY [Country/Region]
ORDER BY MAX_Recovered_Cases DESC