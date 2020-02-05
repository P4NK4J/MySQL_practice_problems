select
    a.name mentee,
    b.name mentor,
    b.email mentor_email
from
    college_individual a
    INNER JOIN college_individual b on a.mentor_id = b.id
where
    (
        (
            SUBSTRING_INDEX(SUBSTR(b.email, INSTR(b.email, '@') + 1), '.', 1)
        ) = "gmail"
    )
ORDER BY
    `a`.`name`