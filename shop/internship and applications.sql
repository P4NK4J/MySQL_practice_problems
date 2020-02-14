--temporary table
create table list(
    email varchar(255),
    name varchar(255),
    phone varchar(255)
);

--application details
insert into
    list(email, name, phone)
SELECT
    DISTINCT hr_applicants.email,
    hr_applicants.name,
    hr_applicants.phone
FROM
    hr_applicants,
    hr_applications,
    hr_jobs
WHERE
    hr_applicants.id = hr_applications.hr_applicant_id
    AND hr_applications.hr_job_id in (
        SELECT
            id
        FROM
            hr_jobs
        WHERE
            hr_jobs.title in (
                "Interaction Designer",
                "Graphic Designer",
                "Production Designer",
                "UI Developer"
            )
    );

-- internship details 
insert into
    list(email, name, phone)
SELECT
    DISTINCT hr_applicants.email,
    hr_applicants.name,
    hr_applicants.phone
FROM
    hr_applications,
    hr_application_meta,
    hr_applicants
WHERE
    hr_application_meta.hr_application_id = hr_applications.id
    AND(
        hr_application_meta.value LIKE "%field:design%"
        OR hr_application_meta.value LIKE "%Portfolio Link%"
        OR hr_application_meta.value LIKE "%Uploaded Portfolio%"
        OR hr_application_meta.value LIKE "%Graphic Designer%"
    )
    AND hr_applications.hr_applicant_id = hr_applicants.id;

/* codetrek details */

create table temporary(
    email varchar(255),
    name varchar(255),
    phone varchar(255)
);

insert into
    temporary(email, name, phone)
SELECT
     DISTINCT `cc_post_meta_email`.`meta_value`,
    `cc_posts`.`post_title`,
    
    `cc_post_meta_phone`.`meta_value`
FROM
    `cc_posts`
    LEFT JOIN `cc_postmeta` AS `cc_post_meta_email` ON `cc_post_meta_email`.`post_id` = `cc_posts`.`ID`
    AND `cc_post_meta_email`.`meta_key` = 'email'
    LEFT JOIN `cc_postmeta` AS `cc_post_meta_phone` ON `cc_post_meta_phone`.`post_id` = `cc_posts`.`ID`
    AND `cc_post_meta_email`.`meta_key` = '%phone'
    LEFT JOIN `cc_postmeta` AS `cc_post_meta_session` ON `cc_post_meta_session`.`post_id` = `cc_posts`.`ID`
    AND `cc_post_meta_session`.`meta_key` = 'session'
WHERE
    `cc_posts`.`post_type` = 'codetrek_data'
    AND `cc_post_meta_session`.`meta_value` = "Product (digital) Design";


/* merge temporary and list table */

insert into employee_database.list
select * from employee_portal.temporary;
 
 /* list table now contains all the necessary details */

/* to export into excel file */

-> right click on the table in sql workbench
-> select table data export wizard
-> select the directory of export
-> select , seperator on export 
->save to csv extension
-> finalize the export
