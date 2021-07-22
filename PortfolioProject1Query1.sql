
--select *
--from PortfolioProject1..CovidDeaths$
--order by 3,4

--select *
--from PortfolioProject1..CovidVaccinations$
--order by 3,4

--Selecting data i would be using

--select location, date, total_cases, new_cases, total_deaths, population
--from CovidDeaths$
--order by 1,2

--Analyzing the total cases and total deaths 
--Shows the probability of dying if one contracts Covid in a specific country

--select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 3) as DeathPercentage
--from CovidDeaths$
--where location = 'ireland'
--order by 2

--select distinct location
--from CovidDeaths$
--order by 1 asc

-- Analysing the total cases against the population
-- Shows percentage of population of which have contracted Covid

--select location, date, total_cases, population, round((total_cases/population)*100, 7) as CovidContractedPercentage
--from CovidDeaths$
--where location = 'ireland'
--order by 2

--Countries with Highest Infected Rates per Population

--select location, population, max(total_cases) as InfectedCases, max(total_cases/population)*100 as CovidContractedPercentage
--from CovidDeaths$
--group by location, population
--order by CovidContractedPercentage desc

--Countries with Highest Death Counts per Population

--select location, population, max(cast(total_deaths as int)) as TotalDeathCount, max(total_deaths/population)*100 as PopDeathPercentage
--from CovidDeaths$
--where continent is not null
--group by location, population
--order by TotalDeathCount desc

--Continents with Highest Death Counts per Population
--EX1:
--select continent, max(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths$
--where continent is not null
--group by continent
--order by TotalDeathCount desc

--EX2:
--select location, max(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths$
--where continent is null
--and location not in ('world', 'international', 'european union')
--group by location
--order by TotalDeathCount desc

--Global Counts dating to the 4th of July, 2021

--select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths,
--(sum(cast(new_deaths as int))/ sum(new_cases))*100 as DeathPercentage
--from CovidDeaths$
--where continent is not null
--order by 1

--Daily Global Cases and Death Counts

--select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths,
--(sum(cast(new_deaths as int))/ sum(new_cases))*100 as DeathPercentage
--from CovidDeaths$
--where continent is not null
--group by date
--order by 1

--Progressing Percentage of People Vaccinated in a country, using CTE

--with progpercentage (continent, location, date, population, new_vaccinations, PeopleVaccinated)
--as
--(
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY DEA.LOCATION, DEA.DATE) as PeopleVaccinated
--from CovidDeaths$ dea
--join CovidVaccinations$ vac
--	on dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null
----order by  2, 3
--)
--select *, (PeopleVaccinated/ Population)*100 as vacpercentage
--from progpercentage

--Using Temp Table

--drop table if exists #PercofPeopleVac
--create table #PercofPeopleVac
--(
--continent nvarchar(100),
--location nvarchar(100),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--PeopleVaccinated numeric
--)

--insert into #PercofPeopleVac
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY DEA.LOCATION, DEA.DATE) as PeopleVaccinated
--from CovidDeaths$ dea
--join CovidVaccinations$ vac
--	on dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null


--select *, (PeopleVaccinated/ Population)*100 as vacpercentage
--from #PercofPeopleVac
--order by 1,2

--Creating views for visualizations

--Create View PeopleVac as 
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY DEA.LOCATION, DEA.DATE) as PeopleVaccinated
--from CovidDeaths$ dea
--join CovidVaccinations$ vac
--	on dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null

--select *
--from PeopleVac