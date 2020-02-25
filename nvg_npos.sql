create database npos ;                   -- --(for importing the data to be migrated)
create database npo_second ;             -- --(for importing the current datatables)

-- --alter name of columns of imported data table

alter table ngo_list change `Sno` `id` int(11);
alter table ngo_list change `Name` `name` text;
alter table ngo_list change `Primary focus area*` `primary_focus_area` text;
alter table ngo_list change `Background` `background` text;
alter table ngo_list change `Registration number*` `registration_number` text;
alter table ngo_list change `FCRA registration number` `fcra_registration_number` text;
alter table ngo_list change `Darpan id*` `darpan_id` text;
alter table ngo_list change `Website` `website` text;
alter table ngo_list change `Why do you need volunteers?* (500 characters)` `why_do_you_need_volunteers` text;
alter table ngo_list change `It proficiency* (nil/basic/medium/high)` `it_proficiency` text;
alter table ngo_list change `It infrastructure* (no vcomputer/ 1-5/5-10/more than 10)` `it_infrastructure` text;
alter table ngo_list change `Employee strength*` `employee_strength` text;
alter table ngo_list change `pincode` `pincode` int(11);
alter table ngo_list change `City` `city` text;
alter table ngo_list change `Geography* (urban/rural/semi urban)` `geography` text;
alter table ngo_list change `Your mobile number`  `your_mobile_number` bigint(20);
alter table ngo_list change `phone_no` `phone_no` bigint(20);
alter table ngo_list change `Upload logo` `upload_logo` text;
alter table ngo_list change `Upload program pictures` `upload_program_pictures` text;
alter table ngo_list change `Email` `email` text;
alter table ngo_list change `Contact Person` `contact_person` text;




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
    ngo_list.`name`,
    ngo_list.`website`,
    ngo_list.`pincode*`,
    ngo_list.`city`,
    ngo_list.`your_mobile_number`,
    ngo_list.`email`,
    ngo_list.`contact_person`
from
    npos.ngo_list;



-- insertion into users table
alter table
    npos.ngo_list
add
    column flag bool default true;

update
    npos.ngo_list
set
    ngo_list.flag = 0
where
    ngo_list.`email` = ""; -- --set flag = 0 for empty entries in email

insert into
    npo_second.users(name, email, phone, location, pincode)
select
    npos.ngo_list.`contact_peron`,
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
    flag = 0;



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
        primary_focus_area
    )
select
    npos.`id`,
    ngo_list.`darpan_id*`,
    ngo_list.`background`,
    ngo_list.`registration_number*`,
    ngo_list.`Why_do_you_need_volunteers`,
    ngo_list.`fcra_registration_number`,
    ngo_list.`geography`,
    ngo_list.`it_proficiency`,
    ngo_list.`it_infrastructure`,
    ngo_list.`employee_strength*`,
    ngo_list.`primary_focus_area*`
from
    npo_second.npos
    left join npos.ngo_list on npos.name = ngo_list.`name`;

-- --insertion in model_has_users table

insert into
    npo_second.model_has_users(model_id,model_type,type, user_id)
select
    npo_second.npos.id model_id,
    'Modules\Npo\Entities\Npo',
    'npo-supervisor',
    npo_second.users.id user_id
from
    npo_second.npos
    inner join npo_second.users on npo_second.npos.contact_person_name = npo_second.users.name
group by
    model_id;



-- --insertion into model_has_roles table

insert into
    model_has_roles(role_id, model_id)
select
    roles.id,
    model_has_users.id
from
    model_has_users
    inner join roles on roles.name = "npo-supervisor"
    and model_has_users.type = "npo-supervisor";