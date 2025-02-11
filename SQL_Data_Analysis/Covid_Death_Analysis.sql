# Check the data
select *
From covid_deaths.covid_deaths;

# Drop the unnecessary column
ALTER TABLE covid_deaths.covid_deaths
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
Select  sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned)) as total_deaths, (sum(cast(new_deaths as unsigned))/sum(new_cases))*100 as DeathPercentage
From covid_deaths.covid_deaths
where continent is not null
order by 1,2 ;
 
 

