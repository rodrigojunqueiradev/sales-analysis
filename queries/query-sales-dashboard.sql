-- (Query 1) Revenue, leads, conversion and montly average ticket
-- Colunas: month (BR), leads (#), sales (#), revenue (k, R$), conversion (%), average ticket (k, R$) 

WITH
	leads AS (
		SELECT 
			date_trunc('month', visit_page_date)::date AS visit_page_month, 
			COUNT(*) AS visit_page_count
			
		FROM sales.funnel
		GROUP BY visit_page_month
		ORDER BY visit_page_month
	),
	payments AS (
		SELECT
			date_trunc('month', fun.paid_date)::date AS paid_month,
			COUNT(fun.paid_date) AS paid_count,
			SUM(pro.price * (1+fun.discount)) AS revenue
			
		FROM sales.funnel AS fun
		LEFT JOIN sales.products AS pro
			ON fun.product_id = pro.product_id
		
		WHERE fun.paid_date IS NOT null
		GROUP BY paid_month
		ORDER BY paid_month
	)

SELECT
	leads.visit_page_month as "month",
	leads.visit_page_count as "leads (#)",
	payments.paid_count as "sales (#)",
	(payments.revenue/1000) as "revenue (k, R$)",
	(payments.paid_count::float / leads.visit_page_count::float) as "conversion (%)",
	(payments.receita / payments.paid_count / 1000) as "average ticket (k, R$)"

FROM leads
LEFT JOIN payments
	ON leads.visit_page_month = paid_month


-- (Query 2) Top 5 best-selling states last month
-- Colunas: country, state, sales (#)

SELECT
	'Brazil' AS country,
	cus.state AS state,
	COUNT(fun.paid_date) AS "sales (#)"
	
FROM sales.funnel AS fun
LEFT JOIN sales.customers AS cus
	ON fun.customer_id = cus.customer_id
	
WHERE paid_date BETWEEN '2021-08-01' AND '2021-08-31'
GROUP BY country, state
ORDER BY "sales (#)" DESC
LIMIT 5


-- (Query 3) Top 5 best-selling brands this month
-- Colunas: brand, sales (#)

SELECT
	pro.brand AS brand,
	COUNT(fun.paid_date) AS "sales (#)"

FROM sales.funnel AS fun
LEFT JOIN sales.products AS pro
	ON fun.product_id = pro.product_id

WHERE paid_date BETWEEN '2021-08-01' AND '2021-08-31'
GROUP BY brand
ORDER BY "sales (#)" DESC
LIMIT 5


-- (Query 4) Top 5 best-selling stores this month
-- Colunas: store, sales (#)

SELECT
	sto.store_name AS store,
	COUNT(fun.paid_date) AS "sales (#)"

FROM sales.funnel AS fun
LEFT JOIN sales.stores AS sto
	ON fun.store_id = sto.store_id

WHERE paid_date BETWEEN '2021-08-01' AND '2021-08-31'
GROUP BY store
ORDER BY "sales (#)" DESC
LIMIT 5


-- (Query 5) Website visits by day of the week for the month
-- Colunas: day_week, day of the week, visits (#)

SELECT
	EXTRACT('dow' FROM visit_page_date) AS day_week,
	CASE 
		WHEN EXTRACT('dow' FROM visit_page_date) = 0 THEN 'sunday'
		WHEN EXTRACT('dow' FROM visit_page_date) = 1 THEN 'monday'
		WHEN EXTRACT('dow' FROM visit_page_date) = 2 THEN 'tuesday'
		WHEN EXTRACT('dow' FROM visit_page_date) = 3 THEN 'wednesday'
		WHEN EXTRACT('dow' FROM visit_page_date) = 4 THEN 'thursday'
		WHEN EXTRACT('dow' FROM visit_page_date) = 5 THEN 'friday'
		WHEN EXTRACT('dow' FROM visit_page_date) = 6 THEN 'saturday'
		ELSE null	
	END AS "day of the week",
	COUNT(*) AS "visits #"

FROM sales.funnel
WHERE visit_page_date BETWEEN '2021-08-01' AND '2021-08-31'
GROUP BY day_week
ORDER BY day_week
