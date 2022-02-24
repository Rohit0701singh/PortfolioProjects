/*
Queries for Tableau Visualization
Please check https://github.com/Rohit0701singh/PortfolioProjects/blob/main/Covid%20Project.sql for SQL Queries
*/

---------------------

/* 1. View for Death Percentage */ 


Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From covidDeath
where continent is not null 

/*OR*/

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From CovidDeath
where location = 'World'

---------------------

/* 2.View for Total Death Count */ 

/*Continent wise*/

Select location, sum(new_deaths) as TotalDeathCount
from CovidDeath
where location in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")
/*World, European Union and International removed to maintain consistency in queries*/
Group by location
order by TotalDeathCount desc

/*Country wise*/

Select location, sum(new_deaths) as TotalDeathCount
from CovidDeath
where location = 'India'
/*where continent is not null*/
/*where location in ("Asia","North America","Africa","South America","Oceania","Antartica","Europe")*/
Group by location
order by TotalDeathCount desc

---------------------

/* 3. View for Infection Rate - Country wise */


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeath
Group by Location, Population
order by PercentPopulationInfected desc

---------------------

/* 4. View for Infection Rate - Date wise */


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeath
Group by Location, Population, date
order by PercentPopulationInfected desc

---------------------

/* 5. View for People Vaccinated */


Select t1.continent, t1.location, t1.date, t1.population
, MAX(t2.total_vaccinations) as RollingPeopleVaccinated
/*, (RollingPeopleVaccinated/population)*100*/
From CovidDeath t1
Join CovidVaccination t2
	On t1.death_id = t2.vaccination_id
where t1.continent is not null 
group by t1.continent, t1.location, t1.date, t1.population
order by 1,2,3

---------------------

/* 6. View for People Vaccinated vs Population */


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select t1.continent, t1.location, t1.date, t1.population
, MAX(t2.total_vaccinations) as RollingPeopleVaccinated
/*, (RollingPeopleVaccinated/population)*100*/
From CovidDeath t1
Join CovidVaccination t2
	On t1.death_id = t2.vaccination_id
where t1.continent is not null 
group by t1.continent, t1.location, t1.date, t1.population
/*order by 1,2,3*/
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac
