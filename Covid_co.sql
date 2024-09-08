
-- we first make the exploratory of data analysis (EDA)  and ordered the data by date and location 
select 
*
from covid_co.owid_covid
where continent is not null 
order by 3,4; 

--  select the data that we are going to be using 


select  location, date, total_cases,new_cases,total_deaths,population
from covid_co.owid_covid
order by location,date ;

--  we are looking at total casese VS total death 



select  location, date, total_cases,total_deaths, (total_deaths/total_cases) *100 as pct_of_death  
from covid_co.owid_covid

order by location,date ;



--  to see the locations that exist in our data 

select
 distinct(location) as locations
from covid_co.owid_covid;

-- see the percentage of total death in Egypt 

 select
 location , 
 date,
 total_cases,
 total_deaths,
 (total_deaths/total_cases)*100 as Pct_Death
 from covid_co.owid_covid
 where location like '%egypt%' 
 group by location,date ; 




-- looking at total cases Vs the population  show percentage of population being coverd 

 select
 location , 
 date,
 total_cases,
 population,
 (total_cases/population)*100 as Pct_Death_population 
 from covid_co.owid_covid
 where location like '%egypt%' 
 group by location,date; 
 
 
 
 
 
 -- looking to countries with hightest infection rate compared to population 
 
 
 
  select
 distinct (location) , 
 MAX(total_cases) as highest_infection ,
 population,
  max((total_cases/population ))*100 as Pct_Death
 from covid_co.owid_covid
 
 group by 1 
 order by location asc; 




-- showing countries with hightest death count per population 

SELECT 
  location, 
  MAX(total_deaths ) AS total_death_count 
FROM covid_co.owid_covid
 where continent is not null 
GROUP BY location;



--  Now we use continent  insted of location  to see total death by continent 


SELECT 
  continent, 
  MAX(total_deaths ) AS total_death_count 
FROM covid_co.owid_covid
 where continent is not  null 
GROUP BY continent;




-- Global numbers 


select 
date , 
sum(new_cases) as total_cases ,
sum(new_deaths)  as total_death , 
(sum(new_deaths) / sum(new_cases)) *100 as pct_death 
from covid_co.owid_covid
where continent is not null 
group by 1 

order by 2 desc ;


-- LOOKING AT TOTAL POPULATION vs VACCINATIONS 


SELECT 
continent , 
location,
date,
population,
new_vaccinations,
sum(new_vaccinations) over (partition by location order by location,date) as rolling_people_vacinated 
-- (rolling_people_vacinated/ population) 
from covid_co.owid_covid
where continent is not null 
order by 2,3; 




-- use CTE 


with population_Vs_vaccination  ( continent , 
location,
date,
population,
new_vaccinations,
rolling_people_vacinated)
as 
(
SELECT 
continent , 
location,
date,
population,
new_vaccinations,
sum(new_vaccinations) over (partition by location order by location,date) as rolling_people_vacinated 
-- (rolling_people_vacinated/ population) 
from covid_co.owid_covid
where continent is not null 
)

select 
*,
(rolling_people_vacinated/ population) *100 
from  population_Vs_vaccination;



-- Creating view for later 



create view  covid_co.population_Vs_vaccination as 
SELECT 
continent , 
location,
date,
population,
new_vaccinations,
sum(new_vaccinations) over (partition by location order by location,date) as rolling_people_vacinated 
-- (rolling_people_vacinated/ population) 
from covid_co.owid_covid
where continent is not null ;


select * 
from covid_co.population_Vs_vaccination ;



