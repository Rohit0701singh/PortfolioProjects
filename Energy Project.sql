-- Energy Data Exploration 
-- Skills used: Joins, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, case function


-------------------------


-- 1. ENERGY SOURCE'S PRODUCTION PER CAPITA --

-- Checking for Top 10 countries with highest average coal production per capita in the last 10 years
-- Can check for any energy source (eg., oil_prod_per_capita, etc)
-- Can check for avg, max, min, etc on aggregate clause (eg., max(coal_prod_per_capita))

select country, round(avg(coal_prod_per_capita),2) as 'Average Coal Production per capita'
from coal 
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America")
and year between 2010 and 2019
group by country
order by avg(coal_prod_per_capita) desc
limit 10

-- Selecting year to check for year on year trend 
-- Can check for any energy souce (eg., oil_prod_per_capita, etc)

select year, round(sum(coal_prod_per_capita),2)
from coal
group by year

-- Checking decade to decade trend
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


-- 2. ENERGY SHOURCE'S SHARE IN ELECTRICTY GENERATION --

-- Checking for top 10 countries with highest average coal share of electricity in the last 10 years
-- Can also check for countries with minimum average coal share of electricity in the last 10 years using round(min(coal_share_elec),2)
-- Can check for any energy souce (eg., avg(nuclear_share_elec), etc)

select country, round(avg(coal_share_elec),2) as 'Average Coal share of electricity'
from coal 
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America")
and year between 2010 and 2019
group by country
order by round(avg(coal_share_elec),2) desc
limit 10


-------------------------


-- 3. ELECTRICITY GENERATED PER CAPITA --

-- Checking for top 10 countries with highest average electricity generation per capita in the last 10 years
-- Can select year to check for year on year trend as well

select country, round(avg(per_capita_electricity),2) as 'Average electricity gerenated per capita'
from Elecenergy 
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America")
and year between 2010 and 2019
group by country
order by round(avg(per_capita_electricity),2) desc
limit 10


-------------------------


-- 4. ENERGY CONSUMED PER CAPITA --

-- Checing for top 10 countries with highest average energy consumed per capita in the last 10 years
-- Can select year to check for year on year trend as well

select country, round(avg(energy_per_capita),2) as 'Average energy consumed per capita'
from Elecenergy 
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America")
and year between 2010 and 2019
group by country
order by round(avg(energy_per_capita),2) desc
limit 10


-------------------------


-- 5. SHARE OF ELECTRICITY GENERATED FROM RENEWABLE SOURCES --

-- Top 10 countries with highest average share of renewable energy consumed in the last 10 years

select entity, round(avg(percent_renewable),2) as 'Average energy consumed per capita'
from renewableshare
where entity not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America")
and year between 2010 and 2019
group by entity
order by round(avg(percent_renewable),2) desc
limit 10

-- Can also check for year on year trend

select year, round(avg(percent_renewable),2) as 'Average energy consumed per capita'
from renewableshare
where entity not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America")
group by year


-------------------------


-- 6. SHARE OF ENERGY SOURCE (BOTH RENEWABLE AND NON RENEWABLE) IN TOTAL ELECTRICITY GENERATED 


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

where t1.country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America")

-- can be checked for a country in particular using 'and t1.country = 'India''
-- can be checked for a specific or range of years using 'and t1.year between 2000 and 2019' or 'and t1.year = '2019''


-------------------------


-- 7. CREATE VIEW TO CHECK FOR CORELATION 

-- impact of renewable use of energy on GDP of a country
-- Impact of population over the use of renewable source of energy

create view GDPvsRSE
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


