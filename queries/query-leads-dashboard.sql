-- (Query 1) Leads gender
-- Colunas: gender, leads(#)

select
	ibge.gender,
	count(*) as "leads (#)"

from sales.customers as cus
left join temp_tables.ibge_genders as ibge
	on lower(cus.first_name) = lower(ibge.first_name)
group by ibge.gender


-- (Query 2) Leads professional status
-- Colunas: profissional status, leads (%)

select
	professional_status,
	(count(*)::float)/(select count(*) from sales.customers) as "leads (%)"

from sales.customers
group by professional_status
order by "leads (%)"


-- (Query 3) Leads age range
-- Colunas: age range, leads (%)

select
	case
		when datediff('years', birth_date, current_date) < 20 then '0-20'
		when datediff('years', birth_date, current_date) < 40 then '20-40'
		when datediff('years', birth_date, current_date) < 60 then '40-60'
		when datediff('years', birth_date, current_date) < 80 then '60-80'
		else '80+' end "age range",
		count(*)::float/(select count(*) from sales.customers) as "leads (%)"

from sales.customers
group by "age range"
order by "age range" desc


-- (Query 4) Leads salary range
-- Colunas: salary range, leads (%), order

select
	case
		when income < 5000 then '0-5000'
		when income < 10000 then '5000-10000'
		when income < 15000 then '10000-15000'
		when income < 20000 then '15000-20000'
		else '20000+' end "salary range",
		count(*)::float/(select count(*) from sales.customers) as "leads (%)",
	case
		when income < 5000 then 1
		when income < 10000 then 2
		when income < 15000 then 3
		when income < 20000 then 4
		else 5 end "order"

from sales.customers
group by "salary range", "ordem"
order by "order" desc


-- (Query 5) Visits vehicles classification
-- Colunas: vehicle classification, visits vehicles (#)
-- Business rule: New vehicles are up to 2 years old, and pre-owned (like new) behicles are over 2 years old

with
	vehicles_classification as (
	
		select
			fun.visit_page_date,
			pro.model_year,
			extract('year' from visit_page_date) - pro.model_year::int as vehicle_age,
			case
				when (extract('year' from visit_page_date) - pro.model_year::int)<=2 then 'new'
				else 'used'
				end as "vehicle classification"
		
		from sales.funnel as fun
		left join sales.products as pro
			on fun.product_id = pro.product_id	
	)

select
	"vehicle classification",
	count(*) as "visits vehicles (#)"
from vehicles_classification
group by "vehicle classification"


-- (Query 6) Age of visited vehicles
-- Colunas: Vehicle age, visited vehicle(%), order

with
	vehicles_age_range as (
	
		select
			fun.visit_page_date,
			pro.model_year,
			extract('year' from visit_page_date) - pro.model_year::int as vehicle_age,
			case
				when (extract('year' from visit_page_date) - pro.model_year::int)<=2 then '0-2 years'
				when (extract('year' from visit_page_date) - pro.model_year::int)<=4 then '2 to 4 years'
				when (extract('year' from visit_page_date) - pro.model_year::int)<=6 then '4 to 6 years'
				when (extract('year' from visit_page_date) - pro.model_year::int)<=8 then '6 to 8 years'
				when (extract('year' from visit_page_date) - pro.model_year::int)<=10 then '8 to 10 years'
				else '10+ years'
				end as "vehicle age",
			case
				when (extract('year' from visit_page_date) - pro.model_year::int)<=2 then 1
				when (extract('year' from visit_page_date) - pro.model_year::int)<=4 then 2
				when (extract('year' from visit_page_date) - pro.model_year::int)<=6 then 3
				when (extract('year' from visit_page_date) - pro.model_year::int)<=8 then 4
				when (extract('year' from visit_page_date) - pro.model_year::int)<=10 then 5
				else 6
				end as "order"

		from sales.funnel as fun
		left join sales.products as pro
			on fun.product_id = pro.product_id	
	)

select
	"vehicle age",
	count(*)::float/(select count(*) from sales.funnel) as "visits vehicles (%)",
	"order"
from vehicles_age_range
group by "vehicle age", "order"
order by "order"


-- (Query 7) Most visited vehicles by brand
-- Colunas: brand, model, visits (#)

select
	pro.brand,
	pro.model,
	count(*) as "visits (#)"

from sales.funnel as fun
left join sales.products as pro
	on fun.product_id = pro.product_id
group by pro.brand, pro.model
order by pro.brand, pro.model, "visits (#)"

