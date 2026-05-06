create database covid;
use covid;

-- Find top 5 states with highest confirmed cases.
SELECT 
    State_UnionTerritory, SUM(Confirmed) AS Total_confirmed
FROM
    covid_india
GROUP BY State_UnionTerritory
ORDER BY total_confirmed DESC
LIMIT 5;

select distinct State_UnionTerritory from covid_india;
UPDATE covid_india
SET State_UnionTerritory = 'OriginalValue'
WHERE State_UnionTerritory = '';


-- Find bottom 5 states with lowest death count.
SELECT 
    State_UnionTerritory, SUM(Deaths) AS Total_deaths
FROM
    covid_india
GROUP BY State_UnionTerritory
ORDER BY total_deaths asc
LIMIT 5;

update covid_india
set State_UnionTerritory = ''
where State_UnionTerritory like '%***';

set sql_safe_updates = 0 ;

-- Show total confirmed, recovered, and deaths for each state.
SELECT 
    State_UnionTerritory, SUM(Confirmed) AS Total_confimed, SUM(Cured) AS Total_cured ,SUM(Deaths) AS Total_deaths 
FROM
    covid_india
GROUP BY State_UnionTerritory;




-- Find states where recovered cases are greater than confirmed cases (data issue check).
SELECT 
    State_UnionTerritory, SUM(Confirmed) AS Total_confimed, SUM(Cured) AS Total_cured 
FROM
    covid_india

GROUP BY State_UnionTerritory
having Total_cured > Total_confimed ;



-- Find states with death rate greater than 2%.

SELECT 
    State_UnionTerritory,SUM(Deaths) AS Total_deaths , round(sum(Deaths) * 100 / sum(Confirmed),2) as Deaths_rate 
FROM
    covid_india
GROUP BY State_UnionTerritory
having Deaths_rate > 2;







-- States where high testing but low confirmed cases
SELECT 
    ci.State_UnionTerritory,
    ci.total_confirmed,
    ct.total_tests
FROM 
    (SELECT 
        State_UnionTerritory, 
        SUM(Confirmed) AS total_confirmed
     FROM covid_india
     GROUP BY State_UnionTerritory) ci
JOIN 
    (SELECT 
        State, 
        SUM(COALESCE(TotalSamples,0)) AS total_tests
     FROM covid_testing
     GROUP BY State) ct
ON ci.State_UnionTerritory = ct.State
WHERE 
    ct.total_tests > (
        SELECT AVG(total_tests) FROM (
            SELECT SUM(COALESCE(TotalSamples,0)) AS total_tests
            FROM covid_testing
            GROUP BY State
        ) t
    )
AND 
    ci.total_confirmed < (
        SELECT AVG(total_confirmed) FROM (
            SELECT SUM(Confirmed) AS total_confirmed
            FROM covid_india
            GROUP BY State_UnionTerritory
        ) c
    );


-- Daily growth rate of confirmed cases for each state?
SELECT 
   distinct State_UnionTerritory,
    Date,
    Confirmed,
    LAG(Confirmed) OVER (PARTITION BY State_UnionTerritory ORDER BY Date) AS prev_day_cases,
    
    (Confirmed - LAG(Confirmed) OVER (PARTITION BY State_UnionTerritory ORDER BY Date)) 
    / LAG(Confirmed) OVER (PARTITION BY State_UnionTerritory ORDER BY Date) 
    AS daily_growth_rate

FROM covid_india;

-- Top 5 states with highest increase in cases in last 7 days
select distinct State_UnionTerritory, Confirmed,Date,
lag(Confirmed , 7) over(partition by State_UnionTerritory order by Date) as 7_days_case,

(Confirmed - lag(Confirmed , 7) over(partition by State_UnionTerritory order by Date)) as increased
from covid_india 
where State_UnionTerritory is not null;

-- Top 5 states with highest increase in cases in last 7 days
SELECT 
        distinct State_UnionTerritory,
        (Confirmed - LAG(Confirmed, 7) OVER (PARTITION BY State_UnionTerritory ORDER BY Date)) 
        AS increase_7_days
    FROM covid_india
group by State_UnionTerritory;

select distinct State_UnionTerritory from covid_india
order by State_UnionTerritory desc;


-- Testing vs Cases trend over time
SELECT DISTINCT
    ci.State_UnionTerritory,
    ci.`Date`,
    ci.Confirmed,
    ct.TotalSamples as Total_testing
FROM
    covid_india ci
        JOIN
    covid_testing ct ON ci.State_UnionTerritory = ct.State
        AND ci.`Date` = ct.`Date`
ORDER BY ci.State_UnionTerritory , ci.Date;

-- Test Positivity Rate (TPR) for each state
select State,
sum(Positive) as Total_Positive,
sum(TotalSamples) as Total_testing,
round((sum(Positive)/sum(TotalSamples))*100 ,2) as test
from covid_testing
group by State
order by test desc;

-- States with highest vaccination efficiency
-- Vaccination vs population or cases
UPDATE covid_india
SET State_UnionTerritory = REPLACE(State_UnionTerritory, '*', '');
set sql_safe_updates =0;
SELECT 
    ct.State,
    ct.total_cases,
    ct.total_tests,
    cv.total_vaccinated
FROM 
    (SELECT 
        State, 
        SUM(Positive) AS total_cases,
        SUM(TotalSamples) AS total_tests
     FROM covid_testing
     GROUP BY State) ct

JOIN 
    (SELECT 
        State, 
        SUM(Total_Individuals_Vaccinated) AS total_vaccinated
     FROM covid_vaccine
     GROUP BY State) cv

ON ct.State = cv.State

ORDER BY total_vaccinated DESC;


-- Recovery Rate and Death Rate per state

SELECT 
    State_UnionTerritory AS state,
    SUM(COALESCE(Deaths, 0)) AS Total_deaths,
    SUM(COALESCE(Cured, 0)) AS Total_cured,
    SUM(COALESCE(Confirmed, 0)) AS Total_Confirmed,
    ROUND((SUM(COALESCE(Cured, 0)) / NULLIF(SUM(COALESCE(Confirmed, 0)), 0)) * 100,
            2) AS Recovery_Rate,
    ROUND((SUM(COALESCE(Deaths, 0)) / NULLIF(SUM(COALESCE(Confirmed, 0)), 0)) * 100,
            2) AS death_Rate
FROM
    covid_india
GROUP BY state
ORDER BY Recovery_Rate DESC;


