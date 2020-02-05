select
    sale.id,
    sale.amount
from
    (
        (
            sale
            inner join customer on sale.customer_id = customer.id
            AND floor(
                datediff(sale.sale_date, customer.birth_date) / 365
            ) > 35
        )
        inner join seller on sale.seller_id = seller.id
        AND seller.gender = 'female'
    )
order by
    sale.amount