-- Covid 19 Data Exploration 
-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


------------------------


-- 1.


-- Sanity Check
-- Checing for duplicate entries against the same date within the location field

select location, DATE, count(*)
from CovidDeath
group by location, DATE
having count(*)>1


-- TEST

select * from CovidDeath
select * from CovidVaccination

-- select data for query

select location, date, total_cases, new_cases,total_deaths, population
from CovidDeath
order by 1,2


------------------------


-- 2. 


-- Total Cases vs Total Deaths

select location, sum(new_cases), sum(new_deaths), round((sum(new_deaths)/sum(new_cases)*100),2) as DeathPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by location

-- Population vs Total Cases

select location, population, sum(new_cases), round((sum(new_cases)/population)*100,2) as InfectionPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by location,population


-------------------------------


-- 3.
-- Selecting specific country using where clause


-- Country wise Total Cases vs Total Deaths

select location, sum(new_cases), sum(new_deaths), round((sum(new_deaths)/sum(new_cases)*100),2) as DeathPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
and location = 'India'
group by location

-- Country wise Population vs Total Cases

select location, population, sum(new_cases), round((sum(new_cases)/population)*100,2) as InfectionPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
and location = 'India'
group by location,population


------------------------


-- 4. 
-- Checking for Fatality rate and infection rates
-- country wise


-- Top ten countries with highest fatality rate 

select location, sum(new_cases), sum(new_deaths), round((sum(new_deaths)/sum(new_cases)*100),2) as DeathPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by location
order by DeathPercentage DESC
limit 10

-- Top ten countries with highest Number of Deaths 

select location, sum(new_cases), sum(new_deaths), round((sum(new_deaths)/sum(new_cases)*100),2) as DeathPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by location
order by sum(new_deaths) DESC
limit 10

-- Top ten countries with highest Infection rate

select location,population,max(total_cases), max((total_cases/population)*100) as InfectionPercentage
from CovidDeath
group by location,population
order by InfectionPercentage desc
limit 10
 -- OR --
select location, population, sum(new_cases), round((sum(new_cases)/population)*100,2) as InfectionPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by location, population
order by InfectionPercentage DESC
limit 10

-- Top ten countries with highest Number of Infections 

select location, population, sum(new_cases), round((sum(new_cases)/population)*100,2) as InfectionPercentage
from CovidDeath
where location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by location, population
order by sum(new_cases) DESC
limit 10


------------------------


-- 5.
-- Checking for Fatality rate and infection rates
-- continent wise


-- Continents with highest fatality rate

select continent, sum(new_cases), sum(new_deaths), round((sum(new_deaths)/sum(new_cases)*100),2) as DeathPercentage
from CovidDeath
where continent in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by continent
order by DeathPercentage DESC

-- Continents with highest Number of Deaths 

select continent, sum(new_cases), sum(new_deaths), round((sum(new_deaths)/sum(new_cases)*100),2) as DeathPercentage
from CovidDeath
where continent in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
group by continent
order by sum(new_deaths) DESC

-- Continents with highest Infection rate

select location,population, max(total_cases), round((max(total_cases)/population)*100,2) as InfectionPercentage
from CovidDeath
where location in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe") 
group by location,population
order by InfectionPercentage DESC

-- Continents with highest Number of Infections

select location,population, max(total_cases), round((max(total_cases)/population)*100,2) as InfectionPercentage
from CovidDeath
where location in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe") 
group by location,population
order by max(total_cases) DESC


------------------------


-- 6.
-- Checking for Fatality rate and infection rates Globally 


--  Global Fatality rate 

select sum(new_cases), sum(new_deaths), round((sum(new_deaths)/sum(new_cases)*100),2) as DeathPercentage
from CovidDeath
where continent is not null

-- Global Infection rate

select sum(population), max(total_cases), round((max(total_cases)/sum(population))*100,2) as InfectionPercentage
from CovidDeath
where continent is not null
group by date
order by InfectionPercentage DESC
limit 1


------------------------


-- 7
-- Total Population vs Total Vaccination 


select t1.location,t1.date, t1.population, t2.new_vaccinations
from covidDeath t1
inner join CovidVaccination t2
on t1.death_id = t2.vaccination_id

-- Country wise 
-- Total Population vs Total Vaccination

select t1.location,t1.date, t1.population, t2.new_vaccinations
from covidDeath t1
inner join CovidVaccination t2
on t1.death_id = t2.vaccination_id
where t1.location ='India'

-- Population vs Rolling Vaccination 
-- RollingVaccination shows cumulative new vaccinations data

select t1.location, t1.date, t1.population, t2.new_vaccinations,
sum(t2.new_vaccinations) over (partition by t1.location order by t1.location,t1.date) as RollingVaccinations
from covidDeath t1  
join CovidVaccination t2
on t1.death_id = t2.vaccination_id
where t1.location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
order by t1.location,t1.date


------------------------


-- 8.
-- Percentage Rolling Vaccination vs Population


-- A. using CTE method

with PopvsVac (location, date, population, new_vaccinations,RollingVaccinations)
as 
(
select t1.location, t1.date, t1.population, t2.new_vaccinations,
sum(t2.new_vaccinations) over (partition by t1.location order by t1.location,t1.date) as RollingVaccinations
from covidDeath t1
join CovidVaccination t2
on t1.death_id = t2.vaccination_id
where t1.location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
)
select *,(RollingVaccinations/population)*100
from PopvsVac

-- to find Max(RollingVaccinations) need to deselect t1.date


-- B. using Temp Table Method

Drop Table if exist PopvsVac2
create TABLE PopvsVac2
(
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingVaccinations numeric
)
insert into PopvsVac2 
select t1.location, t1.date, t1.population, t2.new_vaccinations,
sum(t2.new_vaccinations) over (partition by t1.location order by t1.location,t1.date) as RollingVaccinations
from covidDeath t1
join CovidVaccination t2
on t1.death_id = t2.vaccination_id
/*where t1.location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")*/

select *,(RollingVaccinations/population)*100
from PopvsVac2

------------------------


-- 9.
-- Creating view for Percentage Rolling Vaccination vs Population


create view Percetagepopulationvaccinated as
select t1.location, t1.date, t1.population, t2.new_vaccinations,
sum(t2.new_vaccinations) over (partition by t1.location order by t1.location,t1.date) as RollingVaccinations
from covidDeath t1
join CovidVaccination t2
on t1.death_id = t2.vaccination_id
where t1.location not in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")

select * from Percetagepopulationvaccinated
