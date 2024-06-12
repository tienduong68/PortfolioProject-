select * from [COVIDPortfolioProject ]..CovidDeaths
order by 3,4
select * from [COVIDPortfolioProject ]..CovidVaccinations

select Location, date, total_cases, new_cases, total_deaths, population
from [COVIDPortfolioProject ]..CovidDeaths
order by 1,2

-- Looking at Total cases vs Total Deaths
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [COVIDPortfolioProject ]..CovidDeaths
where Location like '%states%'
order by 1,2
-- show likelihood of dying if you contract coivd in ur country
-- show wwhta percentage of population got Covid
--looking at Total cases vs Population
select Location, date, total_cases, population, (total_deaths/population)*100 as DeathPercentage
from [COVIDPortfolioProject ]..CovidDeaths
--where Location like '%states%'
order by 1,2

--Looking at countris with Highest Ifection rate compared to population
select Location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
from [COVIDPortfolioProject ]..CovidDeaths
group by Location, Population
order by PercentPopulationInfected desc
--Showing countries with Highest Death Count pẻ Population
select Location, Max(Total_deaths) as TotalDeathCount
from [COVIDPortfolioProject ]..CovidDeaths
group by Location
order by  TotalDeathCount desc
--total_deaths in table is nvarchar, so change it into int to get the accurate result
select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
from [COVIDPortfolioProject ]..CovidDeaths
where continent is not null
group by Location
order by  TotalDeathCount desc
-- LET'S BREAK THINGS DOWN BY CONTINENT
select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
from [COVIDPortfolioProject ]..CovidDeaths
where continent is null
group by Location
order by  TotalDeathCount desc

--global numbers 
select date,sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths
, sum(cast(new_deaths as int))/sum(new_cases) * 100 as DeathPercentage
-- total_cases, population, (total_deaths/population)*100 as DeathPercentage
from [COVIDPortfolioProject ]..CovidDeaths
--where Location like '%states%'
where continent is not null
group by date 
order by 1,2

select *
from [COVIDPortfolioProject ]..CovidVaccinations

--looking  at total population vs vaccinations
	with POPvsVAC (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
	as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.Location order by dea.Location, dea.date) as RollingPeopleVaccinated
from [COVIDPortfolioProject ]..CovidDeaths dea
join [COVIDPortfolioProject ]..CovidVaccinations vac
	on dea.Location = vac.Location
	and dea.date = vac.date
	where dea.continent is not null
	--order by  2, 3
	)
	select *, (RollingPeopleVaccinated/Population)*100
	from POPvsVAC



	-- USE CTE
	with POPvsVAC 
	as (Continent, Location, Date, Population, RollingPeopleVaccinated)

	--TEMP TABLE
drop table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.Location order by dea.Location, dea.date) as RollingPeopleVaccinated
from [COVIDPortfolioProject ]..CovidDeaths dea
join [COVIDPortfolioProject ]..CovidVaccinations vac
	on dea.Location = vac.Location
	and dea.date = vac.date
	--where dea.continent is not null

	select *, (RollingPeopleVaccinated/Population)* 100
	from #PercentagePopulationVaccinated

	--Creating View to store dât for later

	Create View PercentagePopulationVaccinated as
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.Location order by dea.Location, dea.date) as RollingPeopleVaccinated
from [COVIDPortfolioProject ]..CovidDeaths dea
join [COVIDPortfolioProject ]..CovidVaccinations vac
	on dea.Location = vac.Location
	and dea.date = vac.date
	where dea.continent is not null
	----------------
	
	select *
	from PercentagePopulationVaccinated

