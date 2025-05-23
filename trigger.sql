-- Table-Level Events:
    -- INSERT, UPDATE, DELETE, TRUNCATE
-- Database-Level Events
    -- Database Startup, Database Shutdown, Connection start and end etc

-- CREATE TRIGGER trigger_name
-- {BEFORE | AFTER | INSTEAD OF} {INSERT | UPDATE | DELETE | TRUNCATE}
-- ON table_name
-- [FOR EACH ROW] 
-- EXECUTE FUNCTION function_name();



CREATE Table my_users
(
    user_name VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO my_users VALUES('Mezba', 'mezba@mail.com'), ('Mir', 'mir@mail.com');

SELECT * from my_users;
SELECT * from deleted_users_audit;

CREATE Table deleted_users_audit
(
    deleted_user_name VARCHAR(50),
    deletedAt TIMESTAMP
);

SELECT * FROM deleted_users_audit;

-- trigger
CREATE or REPLACE FUNCTION save_deleted_user()
RETURNS TRIGGER
LANGUAGE plpgsql
as 
$$
BEGIN
INSERT INTO deleted_users_audit VALUES (OLD.user_name,now());
   RAISE NOTICE 'Deleted user audit log created';
   RETURN OLD;
END
$$

CREATE or REPLACE TRIGGER save_deleted_user_trigger
BEFORE DELETE
on my_users
for EACH row 
EXECUTE FUNCTION save_deleted_user();

DELETE from my_users WHERE user_name = 'Mir';