# Check the data
select *
From covid_deaths.covid_deaths;

# Drop the unnecessary column
ALTER TABLE covid_deaths.covid_deaths
DROP COLUMN MyUnknownColumn;
ALTER TABLE covid_deaths.covid_vaccinations
DROP COLUMN MyUnknownColumn;

Select Location, date, total_cases, new_cases, total_deaths, population
From covid_deaths.covid_deaths
order by 1,2 ;

# Looking at Total Cases vs Total Deaths in India
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From covid_deaths.covid_deaths
where location like 'India'
order by 1,2 ;

# Looking at Total Cases vs Population (Shows what percentage of Population got Covid)
Select Location, date, total_cases, Population, (total_cases/population)*100 as PercentPopulationInfected
From covid_deaths.covid_deaths
order by 1,2 ;

# Looking at Countries with Highest Infection Rate compared to Population
Select Location, Population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths.covid_deaths
Group by Location, Population
Order by PercentPopulationInfected desc ;
 
 # Showing Countries with Highest Death Count per Population
 Select Location, MAX(cast(Total_deaths as unsigned)) as Total_Death_Count
 from covid_deaths.covid_deaths
 where Location not in ('Asia','World','Europe','European Union','North America', 'South America', 'Oceania')
 group by Location
 order by Total_Death_Count desc ;
 
 # Showing Total Death Count by continents
 Select continent, MAX(cast(Total_deaths as unsigned)) as Total_Death_Count
 from covid_deaths.covid_deaths
 where continent is not null
 group by continent
 order by Total_Death_Count desc ;
 

# Looking at Total Cases vs Total Deaths Globally
Select  sum(cast(total_cases as unsigned )) as total_cases, sum(cast(total_deaths as unsigned)) as total_deaths, (sum(cast(total_deaths as unsigned))/sum(cast(total_cases as unsigned )))*100 as DeathPercentage
From covid_deaths.covid_deaths
where continent is not null
order by 1,2 ;
 
# Checking Covid_Vaccinations Table
select *
from covid_deaths.covid_vaccinations;

# checking the joined table
select *
from covid_deaths.covid_deaths death
join covid_deaths.covid_vaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date 
where death.continent is not null ;

# Looking at total population vs vaccinations
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
from covid_deaths.covid_deaths death
join covid_deaths.covid_vaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null
order by 2,3;


select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, sum(cast(vaccine.new_vaccinations as unsigned)) over (Partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
from covid_deaths.covid_deaths death
join covid_deaths.covid_vaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null
order by 2,3 ;

# USING CTE
with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, sum(cast(vaccine.new_vaccinations as unsigned)) over (Partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
from covid_deaths.covid_deaths death
join covid_deaths.covid_vaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeopleVaccinated
from PopvsVac ;

# Use the database
USE covid_deaths;

# Create a new table
CREATE TABLE PercentPopulationVaccinated (
    Continent VARCHAR(255), 
    Location VARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

# Insert the selected data into the new table
INSERT INTO PercentPopulationVaccinated
SELECT 
    death.continent,
    death.location,
    death.date,
    CAST(NULLIF(death.population, '') AS float) AS Population,
    CAST(NULLIF(vaccine.new_vaccinations, '') AS float) AS New_vaccinations,
    SUM(CAST(NULLIF(vaccine.new_vaccinations, '') AS float)) OVER (
        PARTITION BY death.location
        ORDER BY death.date
    ) AS RollingPeopleVaccinated
FROM covid_deaths.covid_deaths death
JOIN covid_deaths.covid_vaccinations vaccine
    ON death.location = vaccine.location
    AND death.date = vaccine.date
WHERE death.continent IS NOT NULL ;

Select * , (RollingPeopleVaccinated/Population)*100 as "Percentage of R.P. Vaccinated"
From PercentPopulationVaccinated
where RollingPeopleVaccinated is not null ;
