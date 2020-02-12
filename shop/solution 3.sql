--using JOIN operation

SELECT
    concat(customer.first_name, ' ', customer.last_name) AS customer_name,
    SUM(sale.amount)
FROM
    (
        customer
        INNER JOIN sale ON customer.id = sale.customer_id
    )
GROUP BY
    customer.first_name
ORDER BY
    sum(sale.amount)


--using subqueries========================================================


SELECT
    concat(customer.first_name, ' ', customer.last_name) AS customer_name,
    SUM(sale.amount) AS avg_amount
FROM
    
        customer,sale
        WHERE(customer.id = sale.customer_id)
    
GROUP BY
    customer.first_name
ORDER BY
    sum(sale.amount)