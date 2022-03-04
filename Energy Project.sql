-- Energy Data Exploration 
-- Skills used: Joins, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, case function


-------------------------


-- 1. ENERGY SOURCE'S PRODUCTION PER CAPITA --


-- Checking for Top 10 countries with highest average coal production per capita in the last 10 years
-- Can check for any energy source (eg., oil_prod_per_capita, etc)
-- Can check for avg, max, min, etc on aggregate clause (eg., max(coal_prod_per_capita))

select country, round(avg(other_renewable_consumption),2) as 'Average other renewable Consumption'
from otherrenewable
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
and year between 1980 and 2021
group by country
order by round(avg(other_renewable_consumption),2) desc
limit 10

-- Selecting year to check for year on year trend 
-- Can check for any energy souce (eg., oil_prod_per_capita, etc)

-- YOY trend
select year, round(avg(other_renewable_consumption*1000000000/population),5) as 'Average other renewable Consumption per capita'
from otherrenewable
where year between 1980 and 2019
group by year

-- Country wise trend
select country, round(avg(other_renewable_consumption*1000000000/population),5) as 'Average otherrenewable Consumption per capita'
from otherrenewable
where year between 1980 and 2019
group by country
order by round(avg(other_renewable_consumption*1000000000/population),5) desc


-- Checking decade on decade trend
-- created a joined temp table 'yeardecade'

select Yeardecade.decade,round(avg(coal.coal_prod_per_capita),2) as 'average coal production'
from 
(
select 
id, 
case 
when year between 1901 and 1910 then 1
when year between 1911 and 1920 then 2
when year between 1921 and 1930 then 3
when year between 1931 and 1940 then 4
when year between 1941 and 1950 then 5
when year between 1951 and 1960 then 6
when year between 1961 and 1970 then 7
when year between 1971 and 1980 then 8
when year between 1981 and 1990 then 9
when year between 1991 and 2000 then 10
when year between 2001 and 2010 then 11
when year between 2011 and 2020 then 12
else 0
end as Decade
from coal
) as Yeardecade

join coal 
on coal.id = yeardecade.id
where Yeardecade.decade not in (0)
group by yeardecade.decade


-------------------------


-- 2. ENERGY SOURCE'S SHARE IN ELECTRICTY GENERATION --


-- Checking for top 10 countries with highest average coal share of electricity in the last 10 years

-- Can also check for countries with minimum average coal share of electricity in the last 10 years using round(min(coal_share_elec),2) or by using order by round(avg(other_renewables_share_elec) asc where round(avg(other_renewables_share_elec) is not null

-- Can check for any energy souce (eg., avg(nuclear_share_elec), etc)

select year, round(avg(other_renewables_share_elec),4) as 'Average other renewable share of electricity'
from otherrenewable
where year between 1985 and 2021
-- and country = 'India'
group by year
order by year desc
limit 10

-------------------------


-- 3. ELECTRICITY GENERATED --


-- Checking for top 10 countries with highest average electricity generation in the last 10 years
-- -- Can check for per capita using round(avg(per_capita_electricity),2) in select and order by clause

select country, round(avg(electricity_generation),2) as 'Average electricity gerenated'
from Elecenergy 
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
and year between 2010 and 2019
group by country
order by round(avg(electricity_generation),2) desc
limit 10

-- Can select year to check for year on year trend as well

select year, round(avg(per_capita_electricity),2) as 'Average electricity gerenated per capita'
from Elecenergy 
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
group by year
order by year


-------------------------


-- 4. ENERGY CONSUMED --


-- Checking for top 10 countries with highest average energy consumed in the last 10 years
-- Can check for per capita using round(avg(energy_per_capita),2) in select and order by clause

select country, round(avg(primary_energy_consumption),2) as 'Average energy consumed'
from Elecenergy 
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
and year between 2010 and 2019
group by country
order by round(avg(primary_energy_consumption),2) desc
limit 10

-- Can select year to check for year on year trend

select year, round(avg(primary_energy_consumption),2) as 'Average energy consumed per capita'
from Elecenergy  
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
group by year


-------------------------


-- 5. SHARE OF ELECTRICITY GENERATED FROM RENEWABLE SOURCES --


-- Top 10 countries with highest average share of renewable energy consumed in the last 10 years

select entity, round(avg(percent_renewable),2) as 'Electicity generated from renewable sources'
from renewableshare
where entity not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
and year between 2010 and 2019
group by entity
order by round(avg(percent_renewable),2) desc
limit 10

-- Can also check for year on year trend

select year, round(avg(percent_renewable),2) as 'Electricity generated from renewable sources'
from renewableshare
where entity not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
group by year


-------------------------


-- 6. SHARE OF ENERGY SOURCE (BOTH RENEWABLE AND NON RENEWABLE) IN TOTAL ELECTRICITY GENERATED 


-- can be checked for a country in particular using 'and t1.country = 'India''
-- can be checked for a specific or range of years using 'and t1.year between 2000 and 2019' or 'and t1.year = '2019''

-- Country Wise 

select 
t1.country, 
t1.year, 
t1.coal_share_elec as 'share from coal',
t3.gas_share_elec as 'share from gas',
t4.hydro_share_elec as 'share from hydro',
t6.nuclear_share_elec as 'share from nuclear',
t7.oil_share_elec as 'share from oil',
t8.solar_share_elec as 'share from solar',
t9.wind_share_elec as 'share from wind',
t10.other_renewables_share_elec as 'share from other renewables',

case 
when round(100-(t1.coal_share_elec + t3.gas_share_elec+ t4.hydro_share_elec+ t6.nuclear_share_elec+ t7.oil_share_elec+ t8.solar_share_elec+ t9.wind_share_elec+ t10.other_renewables_share_elec),2) < '1' then '0'
when round(100-(t1.coal_share_elec + t3.gas_share_elec+ t4.hydro_share_elec+ t6.nuclear_share_elec+ t7.oil_share_elec+ t8.solar_share_elec+ t9.wind_share_elec+ t10.other_renewables_share_elec),2) = '100' then ''
else round(100-(t1.coal_share_elec + t3.gas_share_elec+ t4.hydro_share_elec+ t6.nuclear_share_elec+ t7.oil_share_elec+ t8.solar_share_elec+ t9.wind_share_elec+ t10.other_renewables_share_elec),2) 
end as 'share from other sources'


from coal t1

join gas t3
on t1.id = t3.id
join hydro t4
on t1.id = t4.id
join Nuclear t6
on t1.id = t6.id
join oil t7
on t1.id = t7.id
join solar t8
on t1.id = t8.id
join wind t9
on t1.id = t9.id
join otherrenewable t10
on t1.id = t10.id

where t1.country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")

-- Year wise

select 
t1.year, 
round(avg(t1.coal_share_elec),2) as 'share from coal',
round(avg(t3.gas_share_elec),2) as 'share from gas',
round(avg(t4.hydro_share_elec),2) as 'share from hydro',
round(avg(t6.nuclear_share_elec),2) as 'share from nuclear',
round(avg(t7.oil_share_elec),2) as 'share from oil',
round(avg(t8.solar_share_elec),2) as 'share from solar',
round(avg(t9.wind_share_elec),2) as 'share from wind',
round(avg(t10.other_renewables_share_elec),2) as 'share from other renewables',

case 
when round(100-(avg(t1.coal_share_elec) + avg(t3.gas_share_elec) + avg(t4.hydro_share_elec) + avg(t6.nuclear_share_elec) + avg(t7.oil_share_elec) + avg(t8.solar_share_elec) + avg(t9.wind_share_elec)+ avg(t10.other_renewables_share_elec)),2) < '1' then '0'
when round(100-(avg(t1.coal_share_elec) + avg(t3.gas_share_elec) + avg(t4.hydro_share_elec) + avg(t6.nuclear_share_elec) + avg(t7.oil_share_elec) + avg(t8.solar_share_elec) + avg(t9.wind_share_elec)+ avg(t10.other_renewables_share_elec)),2) = '100' then ''
else round(100-(avg(t1.coal_share_elec) + avg(t3.gas_share_elec) + avg(t4.hydro_share_elec) + avg(t6.nuclear_share_elec) + avg(t7.oil_share_elec) + avg(t8.solar_share_elec) + avg(t9.wind_share_elec)+ avg(t10.other_renewables_share_elec)),2) 
end as 'share from other sources'


from coal t1

join gas t3
on t1.id = t3.id
join hydro t4
on t1.id = t4.id
join Nuclear t6
on t1.id = t6.id
join oil t7
on t1.id = t7.id
join solar t8
on t1.id = t8.id
join wind t9
on t1.id = t9.id
join otherrenewable t10
on t1.id = t10.id

group by year

-- can be checked for a country in particular using 'and t1.country = 'India''
-- can be checked for a specific or range of years using 'and t1.year between 2000 and 2019' or 'and t1.year = '2019''


-------------------------


-- 7. CREATE VIEW TO CHECK FOR CORELATION 


-- Hypothesis: Population and/or GDP of a country has an impact on the percentage renewable source of electricity
-- impact of renewable use of energy on GDP of a country
-- Impact of population over the use of renewable source of energy

-- Country Centric

create view GDPvsRSE_I
as
select 
t1.entity,
t1.year,
t2.GDP,
t2.population,
t1.percent_renewable
from renewableshare t1
join elecenergy t2
on 
t1.entity = t2.country
and t1.year = t2.year
where t1.entity = 'India'

select * from GDPvsRSE


-- GLobal Centric


create view GDPvsRSE_G
as

select 
-- t1.entity,
t1.year,
round(avg(t2.GDP),2) as 'Average GDP',
round(avg(t2.population),2) as 'Average Population',
round(avg(t1.percent_renewable),2) as 'Average Renewable Percentage share of energy'
from renewableshare t1
join elecenergy t2
on 
t1.entity = t2.country
and t1.year = t2.year
-- where t1.entity = 'India'
group by year

select * from GDPvsRSE_G
