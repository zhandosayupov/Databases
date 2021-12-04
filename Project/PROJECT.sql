CREATE TABLE customer(
    id SERIAL NOT NULL UNIQUE PRIMARY KEY,
    country VARCHAR(30) NOT NULL,
    city VARCHAR(40) NOT NULL,
    street_address VARCHAR(40) NOT NULL,
    postal_code VARCHAR(15) NOT NULL,
    email VARCHAR(40) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    type VARCHAR(7),
    CHECK(type IN ('company', 'person'))
);

CREATE TABLE company(
    company_id SERIAL NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    office_address VARCHAR(50) NOT NULL,
    FOREIGN KEY (company_id) REFERENCES customer(id)
);

CREATE TABLE person(
    person_id SERIAL NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES customer(id)
);

CREATE TABLE contract(
    id SERIAL NOT NULL UNIQUE PRIMARY KEY,
    company_id SERIAL NOT NULL,
    discount INT2 DEFAULT(0),
    period VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CHECK(start_date < contract.end_date),
    CHECK(0 <= discount AND discount < 100),
    FOREIGN KEY (company_id) REFERENCES company(company_id)
);

CREATE TABLE "order"(
    id SERIAL PRIMARY KEY,
    order_date TIMESTAMP NOT NULL,
    expected_date TIMESTAMP NOT NULL,
    delivery_date TIMESTAMP,
    timeliness VARCHAR(20),
    is_international BOOLEAN,
    cost INT,
    contract_id INT,
    customer_id INT NOT NULL,
    FOREIGN KEY (contract_id) REFERENCES contract(id),
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    CHECK (timeliness in ('morning', 'afternoon', 'evening')  )
);

CREATE TABLE package(
    id SERIAL PRIMARY KEY ,
    order_id INT NOT NULL,
    size VARCHAR(10),
    is_hazardous BOOLEAN NOT NULL,
    weight INT,
    CHECK(size in ('small', 'medium', 'large', 'flat', 'long')),
    FOREIGN KEY (order_id) REFERENCES "order"(id)
);

CREATE TABLE operation(
    id SERIAL PRIMARY KEY,
    package_id INT NOT NULL,
    FOREIGN KEY (package_id) REFERENCES package(id)
);

CREATE TABLE warehouse(
    id SERIAL PRIMARY KEY,
    country VARCHAR(30) NOT NULL,
    city VARCHAR(40) NOT NULL,
    street_address VARCHAR(40) NOT NULL,
    status VARCHAR(30)
);

CREATE TABLE keeping(
    operation_id INT NOT NULL UNIQUE,
    warehouse_id INT NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    CHECK(start_date < end_date),
    FOREIGN KEY  (operation_id) REFERENCES operation(id),
    FOREIGN KEY  (warehouse_id) REFERENCES warehouse(id)
);

CREATE TABLE transport(
    id SERIAL PRIMARY KEY,
    type VARCHAR(10),
    CHECK ( type in ('plane', 'ship', 'truck', 'train') )
);

CREATE TABLE transportation(
    operation_id INT NOT NULL UNIQUE,
    transport_id INT NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    start_address VARCHAR(50),
    end_address VARCHAR(50),
    CHECK(start_date < end_date),
    FOREIGN KEY  (operation_id) REFERENCES operation(id),
    FOREIGN KEY (transport_id) REFERENCES transport(id)
);

CREATE TABLE credit_card(
    id SERIAL PRIMARY KEY,
    owner_id INT,
    number VARCHAR(30),
    expiration_date DATE,
    owner_name VARCHAR(50),
    CVV VARCHAR(3),
    FOREIGN KEY (owner_id) REFERENCES customer(id)
);

CREATE TABLE bank_account(
    id SERIAL PRIMARY KEY,
    owner_id INT,
    number VARCHAR(30),
    FOREIGN KEY (owner_id) REFERENCES customer(id)
);

CREATE TABLE payment(
    id SERIAL PRIMARY KEY,
    order_id INT,
    status BOOLEAN,
    type VARCHAR(20),
    FOREIGN KEY (order_id) references "order"(id)
);

INSERT INTO customer (id,country,city,street,postal_code,email,phone_number,type) VALUES
  (1,'Australia','Galashiels','5411 Sem St.','328564','duinec@outlook.com','1-332-213-8549','company'),
  (2,'Indonesia','Keswick','727-7701 Vulputate, Avenue','629533','est.nunc@aol.edu','(929) 478-8103','person'),
  (3,'Netherlands','San Pietro Mussolino','203-500 Non, Rd.','75645','mauris@outlook.edu','1-394-834-4441','person'),
  (4,'Costa Rica','New Glasgow','488-4870 Tellus. Rd.','27614','lacus.aliquam.rutrum@yahoo.edu','(569) 515-9456','person'),
  (5,'India','Palembang','Ap #820-3883 Libero. Street','240301','euismod@icloud.couk','1-964-668-5114','person'),
  (6,'Nigeria','Clarksville','9376 Cras St.','232396','molestie@aol.org','(326) 462-0218','company'),
  (7,'Belgium','Kraków','Ap #717-5972 Fringilla Av.','840052','proin.eget@protonmail.couk','1-702-307-2778','company'),
  (8,'Nigeria','Wetaskiwin','698-6588 Ipsum Av.','737342','consequat.auctor@outlook.couk','(590) 910-5800','company'),
  (9,'Spain','Yên Bái','P.O. Box 823, 8689 Aenean Rd.','29984','gravida@protonmail.org','(307) 748-9641','company'),
  (10,'Germany','İskenderun','4992 Eu Rd.','90868-623','pellentesque.massa@protonmail.org','1-441-369-7413','company'),
  (11,'New Zealand','Sokoto','Ap #259-1066 Integer Rd.','5438','nunc.est@icloud.ca','1-457-476-6738','person'),
  (12,'India','Enterprise','676-1079 Montes, Av.','473629','cursus.luctus@outlook.net','1-511-786-7132','company'),
  (13,'China','Zhob','153-8219 Pede Road','11251','urna@aol.com','1-419-322-5544','person'),
  (14,'Turkey','Charlottetown','8297 Dui Ave','26512','mus.donec@icloud.net','(122) 776-2463','person'),
  (15,'France','Wonju','Ap #687-7693 Donec Av.','72-672','ac.risus@outlook.edu','(331) 259-7685','company'),
  (16,'Belgium','Melilla','782-5588 Mi Av.','354202','pede.ultrices@yahoo.org','(373) 689-7946','company'),
  (17,'Pakistan','Cao Bằng','467-668 Semper. Street','33511','eu@protonmail.net','(262) 555-8213','company'),
  (18,'Ireland','Thatta','Ap #200-822 Tristique St.','4557','natoque.penatibus.et@google.edu','(738) 569-5975','company'),
  (19,'South Korea','Panjim','Ap #540-5542 Tincidunt St.','50201','ac@aol.net','(164) 513-5297','person'),
  (20,'Colombia','Chimbote','Ap #874-7150 Eu Av.','441377','libero.morbi@yahoo.couk','(234) 850-7466','person');

INSERT INTO company (company_id,name,office_address) VALUES
    (1,'Dolor Egestas Inc.','337-8593 Id Rd.'),
    (6,'Pellentesque Habitant Inc.','564-1280 Vivamus Avenue'),
    (7,'Euismod Urna Limited','Ap #902-1582 Morbi Avenue'),
    (8,'Tristique Corp.','Ap #774-2456 Convallis Road'),
    (9,'Quisque Varius Limited','865-5947 Phasellus Avenue'),
    (10,'Erat Sed Ltd','Ap #164-8917 Nisl. Ave'),
    (12,'Fusce Diam Nunc Ltd','466-9936 Et Rd.'),
    (15,'Sollicitudin Orci Corporation','669-5223 Penatibus Avenue'),
    (16,'Sed Est PC','Ap #923-6928 Sed St.'),
    (17,'Eu Lacus Ltd','Ap #275-6177 Volutpat. Rd.'),
    (18,'Vestibulum Neque PC','389-6019 At Street');

INSERT INTO person (person_id,name,surname) VALUES
  (2,'Martin','Vega'),
  (3,'Rhea','Sandoval'),
  (4,'Kaseem','Combs'),
  (5,'Garrison','Mccarty'),
  (11,'Cody','Clay'),
  (13,'Zeph','Warner'),
  (14,'Daquan','Pace'),
  (19,'Cain','Daniel'),
  (20,'Dara','Sharp');

INSERT INTO credit_card VALUES
  (1,1,'5565 2892 7759 8674','Apr 17, 2025','Maisie Dotson','217'),
  (2,2,'533625 8957627473','Apr 2, 2022','Kuame Santiago','317'),
  (3,3,'4485765644573','Jul 17, 2022','Hunter Bowers','539'),
  (4,4,'4024007126139','Feb 15, 2021','Oren Huffman','286'),
  (5,5,'4556627955231','Jun 1, 2022','Amity Kirkland','337'),
  (6,6,'4859452577660','Nov 29, 2022','Destiny Raymond','301'),
  (7,7,'5582584595636381','Sep 17, 2021','Rebecca Buchanan','114'),
  (8,8,'542765 576623 4757','Aug 1, 2021','Roth Logan','713'),
  (9,9,'4024007182264','Jul 11, 2021','Mikayla Floyd','933'),
  (10,10,'4539385369480','Mar 4, 2021','Cecilia Michael','244'),
  (11,11,'4556726347686','Mar 4, 2021','Phoebe Nielsen','850'),
  (12,12,'4485675464641','Nov 11, 2022','Sierra Decker','833'),
  (13,13,'4916773898389','Jan 30, 2023','Marny Bennett','537'),
  (14,14,'552 13432 43325 580','May 15, 2024','Germaine Newton','134'),
  (15,15,'4024007125230','Dec 17, 2022','Myra Simpson','676'),
  (16,16,'5427 8567 2817 6520','Aug 30, 2025','Abigail Franco','119'),
  (17,17,'4878621233856','Sep 20, 2024','Faith Jenkins','426'),
  (18,18,'532 24481 77122 373','May 29, 2025','Ursula Daugherty','681'),
  (19,19,'5142897532188479','Dec 1, 2025','Maxwell Solis','302'),
  (20,20,'5163311635839867','Aug 2, 2022','Ori Gamble','240');

INSERT INTO bank_account VALUES
  (1,1,'AL45224467617442431038918441'),
  (2,6,'CY09733586151233296471351186'),
  (3,7,'HU84397413777346817846363475'),
  (4,8,'KW8072242473923335116101016740'),
  (5,9,'AL82136485515625161316579924'),
  (6,10,'AL45224467617442431038918441'),
  (7,12,'CY09733586151233296471351186'),
  (8,15,'HU84397413777346817846363475'),
  (9,16,'KW8072242473923335116101016740'),
  (10,17,'AL82136485515625161316579924'),
  (11,18,'AL45224467617442431038918441');



SELECT DISTINCT customer_id FROM "order"
INNER JOIN package p ON p.order_id = "order".id
INNER JOIN operation o ON o.package_id = p.id
INNER JOIN transportation t on o.id = t.operation_id
LEFT JOIN transport tt ON tt.id = t.transport_id
WHERE t.start_date IN (SELECT transportation.start_date FROM transportation WHERE transportation.transport_id = 1721 ORDER BY start_date desc limit(1))
AND t.transport_id = 1721;

SELECT customer_id, count(1) as number FROM "order", package
WHERE package.order_id = "order".id GROUP BY customer_id ORDER BY number limit (1);

SELECT customer_id, sum(cost) as total FROM "order", package
WHERE package.order_id = "order".id GROUP BY customer_id ORDER BY total desc limit (1);

SELECT street_address, count(1) as num FROM customer
group by street_address order by num desc limit(1);

SELECT id FROM "order" WHERE expected_date < delivery_date;

SELECT customer_id,street_address, SUM(cost) FROM "order", customer
WHERE "order".customer_id = customer.id group by customer_id, street_address;

SELECT customer_id, type, SUM(cost) FROM "order", customer
WHERE "order".customer_id = customer.id group by customer_id, type;