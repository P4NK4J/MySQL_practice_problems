--using JOIN operation

 SELECT
         a.name AS mentee,
         b.name AS mentor,
         b.email AS mentor_email
     FROM
         college_individual a
         INNER JOIN college_individual b ON a.mentor_id = b.id
     WHERE
         (
             (
                 SUBSTRING_INDEX(SUBSTR(b.email, INSTR(b.email, '@') + 1), '.', 1)
             ) = "gmail"
         )
     ORDER BY
         a.name





 -- //using subqueries====================================================



     SELECT
         a.name AS mentee,
         b.name AS mentor,
         b.email AS mentor_email
     FROM
         college_individual a,
         college_individual b
     WHERE
     (a.mentor_id = b.id)
     AND
         (SUBSTRING_INDEX(SUBSTR(b.email, INSTR(b.email, '@') + 1), '.', 1) = "gmail")
     ORDER BY
         a.name