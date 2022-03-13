-- Creating views for Tableau Presentation
-- Link to be attached here shortly 


--------------


-- 1. Data for Consumption of Sources in Total

select
t1.country,
t1.year,
t1.coal_consumption as 'Coal Consumption',
t3.gas_consumption as 'Gas Consumption',
t4.hydro_consumption as 'Hydro Consumption',
t6.nuclear_consumption as 'Nuclear Consumption',
t7.oil_consumption as 'Oil Consumption',
t8.solar_consumption as 'Solar Consumption',
t9.wind_consumption as 'Wind Consumption',
t10.other_renewable_consumption as 'Other Renewables Consumption'

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


---------------------


-- 2. Data for consumption of sources per capita

select
t1.country,
t1.year,
round(avg(t1.coal_consumption*1000000000/t1.population),5) as 'Coal Consumption per capita',
round(avg(t3.gas_consumption*1000000000/t1.population),5) as 'Gas Consumption per capita',
round(avg(t4.hydro_consumption*1000000000/t1.population),5) as 'Hydro Consumption per capita',
round(avg(t6.nuclear_consumption*1000000000/t1.population),5) as 'Nuclear Consumption per capita',
round(avg(t7.oil_consumption*1000000000/t1.population),5) as 'Oil Consumption per capita',
round(avg(t8.solar_consumption*1000000000/t1.population),5) as 'Solar Consumption per capita',
round(avg(t9.wind_consumption*1000000000/t1.population),5) as 'Wind Consumption per capita',
round(avg(t10.other_renewable_consumption*1000000000/t1.population),5) as 'Average otherrenewable Consumption per capita'

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

group by t1.country,t1.year


-----------------------------


-- 3. Data for Production of Sources in Total

select
t1.country,
t1.year,
round(t1.coal_production,2) as 'Coal Production',
round(t2.gas_production,2) as 'Gas Production',
round(t3.oil_production,2) as 'Oil Production'

from coal t1

join gas t2
on t1.id = t2.id
join oil t3
on t1.id = t3.id

where t1.country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
-- and t1.coal_production not in ("0.00")
-- and t2.gas_production not in ("0.00")
-- and t3.oil_production not in ("0.00")


------------------------


-- 4. Data for Production of sources per capita

select
t1.country,
t1.year,
round(t1.coal_prod_per_capita,2) as 'Coal Production Per Capita',
round(t2.gas_prod_per_capita,2) as 'Gas Production Per Capita',
round(t3.oil_prod_per_capita,2) as 'Oil Production Per Capita'

from coal t1

join gas t2
on t1.id = t2.id
join oil t3
on t1.id = t3.id

where t1.country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")
-- and round(t1.coal_prod_per_capita,2) not in ("0.00")
-- and round(t2.gas_prod_per_capita,2) not in ("0.00")
-- and round(t3.oil_prod_per_capita,2) not in ("0.00")


-----------------------


-- 5. Data for Electricity Generated in Total

select country, year, round(electricity_generation,2) as 'Electricity generated'
from Elecenergy
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","South America","South & Central America","Middle East","OPEC","CIS","USSR")


-----------------------


-- 6. Data for Electricity Generated per capita

select country,year, round(per_capita_electricity,2) as 'Electricity gerenated pr Capita'
from Elecenergy
where country not in ("Asia Pacific","Africa","Asia","Europe","North America","Sounth America","South & Central America","Middle East","OPEC","CIS","USSR")


-----------------------


-- 7. Data for comparison of delta trend in Population, GDP, Percentage renewable

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

where t1.entity not in ("Asia Pacific","Africa","Asia","Europe","North America","South America","South & Central America","Middle East","OPEC","CIS","USSR")


------------------


-- 8. Data for Electricity generated per source

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

where t1.country not in ("Asia Pacific","Africa","Asia","Europe","North America","South America","South & Central America","Middle East","OPEC","CIS","USSR")


----------------------


-- 9. Data for energy generated from Renewable sources

select entity,year, round(percent_renewable,2) as 'Electricity generated from renewable sources'
from renewableshare
where entity not in ("Asia Pacific","Africa","Asia","Europe","North America","South America","South & Central America","Middle East","OPEC","CIS","USSR")