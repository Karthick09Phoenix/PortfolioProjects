select * from CovidDeaths

select * from covidvaccinations

----------Select Data

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths 
order by 1,2

---------Looking at Total cases vs Total Deaths

SELECT location, 
       date, 
       total_cases, 
       total_deaths, 
       (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS DeathPercentage
FROM CovidDeaths 
WHERE location = 'India' 
ORDER BY location, date


---Total cases vs Population

SELECT location, 
       date, 
       population, 
       total_cases, 
       (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS DeathPercentage
FROM CovidDeaths 
WHERE location = 'India' 
ORDER BY location, date


-------------Looking at countries with high infection rate

select location,population,max(total_cases) as Highinfections,max(cast(total_cases As Float)/cast(Population as Float)) as
percentagepopulation
from CovidDeaths
group by location,population
order by percentagepopulation desc

-----------Showing Countries with High Death Count

select location,max(cast(total_deaths as Int)) as TotalDeathcount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathcount desc

----------Showing Continent with the Highest Death count per population

select continent,max(cast(total_deaths as Int)) as TotalDeathcount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathcount desc


----Global Numbers

SELECT date,
       SUM(CAST(new_cases AS INT)) AS total_cases,
       SUM(CAST(new_deaths AS INT)) AS total_deaths,
       (SUM(CAST(new_deaths AS INT)) / SUM(CAST(new_cases AS INT))) * 100 AS total_death_percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


---------------------Covid vaccination + Covid cases

----------Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) 
as Rolepopulation
from CovidDeaths dea 
join CovidVaccinations vac
  on dea.location=vac.location
  and dea.date=vac.date
  where dea.continent is not null
  and vac.new_vaccinations is not null
  order by 1,2,3,4 asc


  -------------Use CTE

  with PopvsVac(continent,location,population,date,new_vaccinations,Rolepopulation)
  as
  (
  select dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) 
as Rolepopulation
from CovidDeaths dea 
join CovidVaccinations vac
  on dea.location=vac.location
  and dea.date=vac.date
  where dea.continent is not null
  and vac.new_vaccinations is not null
  --order by 1,2,3,4 asc
  
  )

  select *,(Rolepopulation/population)*100
  from PopvsVac

  ------------------TempTable


  Drop table if exists #percentagePopulation
  CREATE TABLE #percentagePopulation
(
    Continent VARCHAR(255),
    Location VARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    Rolepopulation NUMERIC
);

INSERT INTO #percentagePopulation (Continent, Location, date, population, new_vaccinations, Rolepopulation)
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(NUMERIC, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS Rolepopulation
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
  AND vac.new_vaccinations IS NOT NULL;

SELECT *,
       (Rolepopulation / population) * 100 AS VaccinationPercentage
FROM #percentagePopulation;

-------------------------Create View to store data

Create view  Deathcontinent as
select continent,max(cast(total_deaths as Int)) as TotalDeathcount
from CovidDeaths
where continent is not null
group by continent
--order by TotalDeathcount desc

