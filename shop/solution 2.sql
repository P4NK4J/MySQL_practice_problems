SELECT
    concat(customer.last_name, ' ', customer.first_name) AS customer_name,
    seller.name,
    sale.amount
FROM
    (
        (
            sale
            INNER JOIN customer ON sale.customer_id = customer.id
        )
        INNER JOIN seller ON sale.seller_id = seller.id
    )
ORDER BY
    customer.first_name,
    sale.amount