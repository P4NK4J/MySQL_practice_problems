--using JOIN operation

SELECT
    sale.id,
    sale.amount
FROM
    (
        (
            sale
            INNER JOIN customer ON sale.customer_id = customer.id
            AND floor(
                datediff(sale.sale_date, customer.birth_date) / 365
            ) > 35
        )
        INNER JOIN seller ON sale.seller_id = seller.id
        AND seller.gender = 'female'
    )
ORDER BY
    sale.amount


--using subqueries======================================================



SELECT
    sale.id,
    sale.amount
FROM
    
        
            sale,customer,seller
            WHERE(sale.customer_id = customer.id)
            AND floor(
                datediff(sale.sale_date, customer.birth_date) / 365
            ) > 35

            AND sale.seller_id = seller.id
  
            AND seller.gender = 'female'
    
ORDER BY
    sale.amount
