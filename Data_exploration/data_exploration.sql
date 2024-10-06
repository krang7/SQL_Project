use data_projects;
select * from coviddeaths ;
select * from covidvacinations ;
# selecting the data 
select location , date,total_cases,total_deaths , population from coviddeaths where continent is not null order by location ,date;

# total cases vs total deaths as death percentage
 select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage from coviddeaths where continent is not null
order by  location , death_percentage asc; 

#total cases vs population as Infection_rate
select location,date,total_cases,population, (total_cases/population )*100 as Infection_rate from coviddeaths where continent is not null
order by   location,Infection_rate desc;

#looking at countries with highest infection rate compare to population
select location,population,max(total_cases) as highest_infection_count, max((total_cases/population ))*100 as percent_population_infected from coviddeaths where continent is not null group by location,population 
order by   percent_population_infected	desc;

# showing countries with highest death count per population 
select location,max(cast(total_deaths as unsigned )) as total_deaths_count from coviddeaths  where continent is not null group by location order by total_deaths_count desc;

# global numbers
select date,sum(new_cases) as total_cases  , sum(cast(new_deaths as unsigned)) as total_deaths , sum(cast(new_deaths as unsigned))/sum(new_cases) *100  as death_percentage from coviddeaths  where continent is not null group by date order by date asc;

select * from coviddeaths as death join covidvacinations as vacine on death.location=vacine.location and death.date = vacine.date;

#looking at total population vs vaccinations
select death.continent,death.location,death.date,death.population,vacine.new_vaccinations,
sum(convert(vacine.new_vaccinations,unsigned )) over (partition by death.location order by death.location,death.date) as rolling_people_vaccinated
from coviddeaths as death
join covidvacinations as vacine 
on death.location=vacine.location and death.date = vacine.date
where death.continent is not null
order by 2,3 ;

with population_vs_vacinations(continent,location,date,population,new_vaccinations,rolling_people_vaccinated) as(
select death.continent,death.location,death.date,death.population,vacine.new_vaccinations,
sum(convert(vacine.new_vaccinations,unsigned )) over (partition by death.location order by death.location,death.date) as rolling_people_vaccinated
from coviddeaths as death
join covidvacinations as vacine 
on death.location=vacine.location and death.date = vacine.date
where death.continent is not null
order by 2,3 
)
select * , (rolling_people_vaccinated/population)*100  from population_vs_vacinations;
