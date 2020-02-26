create database npos ;                   -- --(for importing the data to be migrated)
create database npo_second ;             -- --(for importing the current datatables)


-- after import collate the database npos

ALTER DATABASE npos DEFAULT COLLATE utf8_unicode_ci;
ALTER TABLE ngo_list CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;



-- --set flag = 0 for empty entries in email

alter table
    npos.ngo_list
add
    column flag bool default true;

update
    npos.ngo_list
set
    npos.ngo_list.flag = 0
where
     npos.ngo_list.`email` = "";




-- count before and  insertion--
select count(*) from npo_second.npos;


-- --insertion into npos table
insert into
    npo_second.npos(
        name,
        website_url,
        pincode,
        location,
        phone,
        email,
        contact_person_name
    )
select
     npos.ngo_list.`name`,
     npos.ngo_list.`website`,
     npos.ngo_list.`pincode`,
     npos.ngo_list.`city`,
     npos.ngo_list.`your_mobile_number`,
     npos.ngo_list.`email`,
     npos.ngo_list.`contact_person`
from
    npos.ngo_list where npos.ngo_list.email not in (select email from npo_second.users);
    



-- count before and  insertion--
select count(*) from npo_second.users;

-- insertion into users table
 
insert into
    npo_second.users (name, email, phone, location, pincode)
select
    npos.ngo_list.`contact_person`,
    npos.ngo_list.`email`,
    npos.ngo_list.`your_mobile_number`,
    npos.ngo_list.`city`,
    npos.ngo_list.`pincode`
from
    npos.ngo_list
where
    npos.ngo_list.flag = 1
group by
    npos.ngo_list.`email`;

-- --the entries which had empty email can be selected and reported further.


-- --selection of entries which were not inserted into users table due to empty field Email
select
    name,
    email
from
    npos.ngo_list
where
     npos.ngo_list.flag = 0;




-- count before and  insertion--
select count(*) from npo_second.npo_meta;
-- --insertion into npo_meta table
insert into
    npo_second.npo_meta(
        npo_id,
        darpan_portal_id,
        background,
        registration_number,
        why_need_volunteers,
        fcra_registration_number,
        geography,
        it_proficiency,
        it_infrastructure,
        employee_strength,
        primary_focus_area_other,
        primary_focus_area
    )
select
     npos.`id`,
     npos.ngo_list.`darpan_id`,
     npos.ngo_list.`background`,
     npos.ngo_list.`registration_number`,
     npos.ngo_list.`Why_do_you_need_volunteers`,
     npos.ngo_list.`fcra_registration_number`,
     npos.ngo_list.`geography`,
     npos.ngo_list.`it_proficiency`,
     npos.ngo_list.`it_infrastructure`,
     npos.ngo_list.`employee_strength`,
     npos.ngo_list.`primary_focus_area`,
     "other"
from
    npo_second.npos
    left join npos.ngo_list on npos.name =  npos.ngo_list.`name`; 
 
-- --insertion in model_has_users table

insert into
    npo_second.model_has_users(model_id,model_type,type, user_id)
select
    npo_second.npos.id model_id,
    'Modules\\Npo\\Entities\\Npo',
    'npo-supervisor',
    npo_second.users.id user_id
from
    npo_second.npos
    inner join npo_second.users on npo_second.npos.contact_person_name = npo_second.users.name;


-- --insertion into model_has_roles table

insert into
    npo_second.model_has_roles(model_id, role_id)
select
	distinct npo_second.model_has_users.id ,
    npo_second.roles.id ,
    "Modules\\User\\Entities\\User"
    
from
    npo_second.model_has_users
    inner join npo_second.roles on npo_second.roles.name = "npo-supervisor"
   and npo_second.model_has_users.type = "npo-supervisor";