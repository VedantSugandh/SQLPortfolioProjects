
/*

Covid-19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/



Select * 
From PortfolioProject..['Covid Deaths]
Where continent is not null
ORDER BY 3,4


-- Select Data that we are going to be starting with


Select location,total_cases,new_cases,total_deaths,population
From PortfolioProject..['Covid Deaths]
Where continent is not null
Order By 1,2


-- Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in country

Select location, date ,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['Covid Deaths]
Where location like '%India%'
and continent is not null
Order By 1,2


--Total Cases vs Population
--showing what percentage of population infected with covid

Select location, date ,population,total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProject..['Covid Deaths]
--Where location like '%India%'
Order By 1,2

--Countries with Hightest Infection rate compared to Population

Select location,population, MAX(total_cases) as HighestInfectionCount ,
MAX(total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProject..['Covid Deaths]
--Where location like '%India%'
Group By location,population
Order By  PercentagePopulationInfected desc

-- Countries with Highest Death Count per population

Select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Deaths]
--where location like '%India%'
where continent is not null
Group by location
Order by  TotalDeathCount desc


--Showing the continent with the highest death count per population

Select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Deaths]
--where location like '%India%'
Where continent is not null
Group By continent
Order By  TotalDeathCount desc

--Global Numbers



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths ,
SUM(cast(new_deaths as int ))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..['Covid Deaths]
--WHERE LOCATION LIKE '%India%'
Where continent is not null
--group by date
Order by 1,2


-- Total population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.Date) RollingPeopleVaccinated

From PortfolioProject..['Covid Deaths] dea
Join PortfolioProject..['Covid Vaccination] vac
  On dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
  Order by 2,3


  --USE CTE to perform Calculation on Partition By in previous query

  WITH PopvsVac (continent, Location, Date, Population ,new_vaccination , RollingPeopleVaccinated)
  as
  (
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.Date) RollingPeopleVaccinated
 --RollingPeopleVaccinated/population*100

From PortfolioProject..['Covid Deaths] dea
join PortfolioProject..['Covid Vaccination] vac
  On dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
 -- Order by 2,3
  )

  Select *, RollingPeopleVaccinated/population*100
  From PopvsVac 



  -- Using Temp Table to perform Calculation on Partition By in previous query

  Drop table if exists #PercentPopulationVaccinated
  CREATE TABLE #PercentPopulationVaccinated
  (
  Continent nvarchar (255),
  location nvarchar (255),
  Date datetime,
  population numeric,
  New_vaccinated numeric,
  RollingPeopleVaccinated numeric
  )


   INSERT INTO  #PercentPopulationVaccinated
   Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.Date) RollingPeopleVaccinated
 --RollingPeopleVaccinated/population*100

From PortfolioProject..['Covid Deaths] dea
join PortfolioProject..['Covid Vaccination] vac
  On dea.location = vac.location
  and dea.date = vac.date
 --where dea.continent is not null
 -- order by 2,3

  Select *, RollingPeopleVaccinated/population * 100
  From #PercentPopulationVaccinated




  -- Creating View to store data for later visualization

  Create view PercentPopulationVaccinated as
   Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.Date) RollingPeopleVaccinated
 --RollingPeopleVaccinated/population*100

From PortfolioProject..['Covid Deaths] dea
join PortfolioProject..['Covid Vaccination] vac
  On dea.location = vac.location
  and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3


 select *
 From PercentPopulationVaccinated
 
 
 
