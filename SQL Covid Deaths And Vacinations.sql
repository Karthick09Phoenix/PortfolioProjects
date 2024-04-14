select *
from PortfolioProject..CovidDeaths
order by 3,4

update CovidDeaths set total_deaths='2000'

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total cases vs Total Deaths

select location,date,total_cases,Total_deaths,population,(total_deaths/total_cases)*100 As Deathpercentage
from PortfolioProject..CovidDeaths
where location like'%india%'
order by 1,2

--Looking at Total cases vs Population
--Shows what percentage of population got covid
select location,date,population,total_cases,(total_cases/population)*100 As PercentagePopuloationInfected
from PortfolioProject..CovidDeaths
--where location like'%india%'
order by 1,2

--Looking at countries with Highest Infection rate  Compared to Population

select location,population,Max(total_cases) As HighestInfectionCount,Max(total_cases/population)*100 As PercentagePopuloationInfected
from PortfolioProject..CovidDeaths
--where location like'%india%'
Group By location,population
order by  PercentagePopuloationInfected desc

--Showing Countries With Highest Death Count Per population

select location,Max(cast(Total_deaths as Int)) AS TotaldeathCount
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
Group By location
order by  TotaldeathCount desc

---Lets Break things Down To Continent

select location,Max(cast(Total_deaths as Int)) AS TotaldeathCount
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
Group By location
order by  TotaldeathCount desc

--Showing Continents with Highest Death Count Per Population

select continent,Max(cast(Total_deaths as Int)) AS TotaldeathCount
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
Group By continent
order by  TotaldeathCount desc

--Breaking Global Numbers

select sum(new_cases) as t0tal_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases) * 100 as Deathpercentage
--Total_deaths,population,(total_deaths/total_cases)*100 As Deathpercentage
from PortfolioProject..CovidDeaths
--where location like'%india%'g
where continent is not null
--group by date
order by 1,2

--Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

--Creating Views

Create view PercentPopulationPercentage as
select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3

select * from 
PercentPopulationPercentage














