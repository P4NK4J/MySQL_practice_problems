select
    concat(customer.first_name, ' ', customer.last_name) AS customer_name,
    SUM(sale.amount)
FROM
    (
        customer
        INNER JOIN sale on customer.id = sale.customer_id
    )
GROUP BY
    customer.first_name
ORDER BY
    sum(sale.amount)