--*verify data check CovidDeaths* 1
--^^^
select * from CovidStats_DB..CovidDeaths
order by 1,2

--*verify data check CovidVaccinations* 1
--^^^
select * from CovidStats_DB..CovidVaccinations
order by 1,2


--*Gets baseline data to analyze* 1
--^^^
select Location, date, total_cases, new_cases, total_deaths, population
from CovidStats_DB..CovidDeaths order by 1,2


-- *total_cases vs total_deaths*:
-- possibility(%) of death if a patient is COVID-Positive, by country
select Location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as DeathRate_Percentage
from CovidStats_DB..CovidDeaths
where location like '%United States%'
order by 1,2

-- *total_cases vs population*:
-- population of people who are COVID-positive, by country
select Location, date, population, total_cases, round((total_cases/population)*100,2) as CovidPositive_Percentage
from CovidStats_DB..CovidDeaths
where location like '%United States%'
order by 1,2

-- *Countries with Highest Infection Rate per population*
select Location, population, MAX(total_cases) as HighestInfectionCount, round(MAX(total_cases/population)*100,2) as CovidPositive_Percentage
from CovidStats_DB..CovidDeaths
group by Location, population
order by CovidPositive_Percentage desc

-- *Countries with Highest Death Count per Population*
select continent, location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidStats_DB..CovidDeaths
-- *DATA ENTRY ERROR* ->income levels placed in locational data. == 0 ==NOT FIXED
where continent is not null and location != 'High income' and location != 'low income' and location != 'upper middle income' and location != 'lower middle income' and location != 'international'
group by continent, location
order by continent asc
--^^^ building upon above entries --RETREIVED countries stats by themselves
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidStats_DB..CovidDeaths
where continent is not null
group by continent 
order by TotalDeathCount desc

--*Global Numbers by DATE*
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100
as DeathPercentage
from CovidStats_DB..CovidDeaths
where continent is not null 
group by date
order by 1,2

--*Global Numbers TOTALED*
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100
as DeathPercentage
from CovidStats_DB..CovidDeaths
where continent is not null 
order by 1,2