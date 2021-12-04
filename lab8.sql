-- 1.a

CREATE OR REPLACE FUNCTION increment(_number numeric) returns numeric as
	$$
	begin
		_number := _number + 1;
		return _number;
	end;
	$$
language plpgsql;

SELECT increment(1235);

-- 1.b

CREATE OR REPLACE FUNCTION sum_of_two_numbers(first numeric, second numeric) returns numeric as
	$$
	begin
		return first + second;
	end;
	$$
language plpgsql;

SELECT sum_of_two_numbers(100, 235);

-- 1.c

CREATE OR REPLACE FUNCTION is_even(_number numeric) returns bool as
	$$
	begin
		return (1 - _number % 2);
	end;
	$$
language plpgsql;

SELECT is_even(1235);

-- 1.d

CREATE OR REPLACE FUNCTION is_valid(password varchar) returns bool as
	$$
	begin
        if length(a) >= 8 then
	        return true;
		else
            return false;
       	end if;
    end;
	$$
language plpgsql;

SELECT is_valid("sdgokonknaog");

-- 1.e

CREATE OR REPLACE FUNCTION square_and_cube(_number numeric, out square numeric, out cube numeric) as
	$$
	begin
		square := _number * _number;
		cube := square * _number;
	end;
	$$
language plpgsql;

SELECT * FROM square_and_cube(15);

-- 2.a

CREATE TABLE some_table(
    id INT NOT NULL UNIQUE,
    some_date date,
    some_num int,
    some_string varchar,
    logtime timestamp,
    primary key (id)
);

CREATE OR REPLACE FUNCTION trigger_on_changes1() returns trigger AS $trigger_on_changes$
    begin
    	new.logtime := current_timestamp;
        return new;
    end;
    $trigger_on_changes$
language plpgsql;

CREATE TRIGGER trigger_on_changes before INSERT OR UPDATE ON some_table
    for each row execute function trigger_on_changes1();

INSERT INTO some_table VALUES(1, '2002-12-12', 15, 'aoginadsg');

SELECT * FROM some_table;

-- 2.b

CREATE TABLE person (
   id int unique,
   date_of_birth date,
   age int,
   primary key(id)
);

CREATE OR REPLACE FUNCTION ages() returns trigger as
    $$
    begin
        new.age = extract(years from age(current_date, new.date_of_birth ));
        return new;
    end;
    $$
language plpgsql;

CREATE TRIGGER compute_age before INSERT ON
    person for each row execute procedure ages();

INSERT INTO person VALUES (1, '2003-10-05');

SELECT * FROM person;

-- 2.c

CREATE TABLE account(
  price int not null,
  tax double precision
);

CREATE FUNCTION tax_calc() returns trigger as
    $$
        begin
            new.tax = new.price * 0.12;
            return new;
        end;
    $$
language plpgsql;

CREATE TRIGGER set_tax before INSERT ON account
	for each row execute procedure tax_calc();

INSERT INTO account(price) values (15);

SELECT * FROM account;

-- 3
-- What is the difference between procedure and function
-- Function is used to calculate something from a given input.
-- While procedure is the set of commands, which are executed in a order.

-- 4.a

CREATE TABLE employee(
    id int unique,
    name varchar,
    date_of_birth date,
    age int,
    salary int,
    workexperience int,
    discount int
);

CREATE OR REPLACE PROCEDURE increase() AS
    $$
        begin
            UPDATE employee
            SET salary = salary * (workexperience/2)*1.1,
            discount = 10
            WHERE workexperience >= 2;

            UPDATE employee
            SET discount = discount + (workexperience / 5)
            WHERE workexperience >= 5;
            COMMIT;
        end;
    $$
language plpgsql;

INSERT INTO employee VALUES (1,'Zhandos', '2003-06-05', 15, 50000,16, 0);

call increase();

SELECT * FROM employee;

-- 4.b

CREATE OR REPLACE PROCEDURE increase_salary() AS
    $$
        begin
            UPDATE employee
            SET salary = salary * 1.15
            WHERE age >= 40;

            UPDATE employee 
            SET
            salary = salary * 1.15,
            discount = 20
            WHERE age >= 40 and workexperience >= 8;
            COMMIT ;
        end;
    $$
language plpgsql;

INSERT INTO employee VALUES ( 2, 'Kanat', '1965-08-03', 51, 40000, 20,0);

call increase_salary();

SELECT * FROM employee;

