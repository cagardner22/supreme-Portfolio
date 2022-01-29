--joining the two tables (CovidDeaths and CovidVaccines) on location and date
-- total_population vs new_vaccinations
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(convert(bigint,vaccine.new_vaccinations)) OVER (partition by death.location 
order by death.location, death.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
from CovidStats_DB..CovidDeaths death
join CovidStats_DB..CovidVaccinations vaccine
	on death.location = vaccine.location 
	and death.date = vaccine.date
where death.continent is not null
order by 2,3

-- CTE
-- Common Table Expression
-- makes improved readability and maintenance easier

With Pop_vs_Vacc(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
--number of columns in CTE should be the same as below. ex: below 5, above 5(not including RollingPeopleVaccinated)
(
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(convert(bigint,vaccine.new_vaccinations)) OVER (partition by death.location 
order by death.location, death.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from CovidStats_DB..CovidDeaths death
join CovidStats_DB..CovidVaccinations vaccine
	on death.location = vaccine.location 
	and death.date = vaccine.date
where death.continent is not null
-- order by 2,3
-- can not have a ORDER BY clause when using CTE
)
select *, (RollingPeopleVaccinated/population)*100 
as PercentVaccinated
from Pop_vs_Vacc


--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated

(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated

select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(convert(bigint,vaccine.new_vaccinations)) OVER (partition by death.location 
order by death.location, death.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
from CovidStats_DB..CovidDeaths death
join CovidStats_DB..CovidVaccinations vaccine
	on death.location = vaccine.location 
	and death.date = vaccine.date
where death.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100 
as PercentVaccinated
from #PercentPopulationVaccinated


-- CREATING VIEWs

Create View PopulationVaccinated
as
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(convert(bigint,vaccine.new_vaccinations)) OVER (partition by death.location 
order by death.location, death.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
from CovidStats_DB..CovidDeaths death
join CovidStats_DB..CovidVaccinations vaccine
	on death.location = vaccine.location 
	and death.date = vaccine.date
where death.continent is not null
--order by 2,3

select *
from PopulationVaccinated

