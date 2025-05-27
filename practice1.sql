-- Active: 1747415487712@@127.0.0.1@5432@ph
 CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  role VARCHAR(20) CHECK (role IN ('worker', 'buyer', 'admin'))
);

drop TABLE users

CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100),
  description TEXT,
  coin_reward INTEGER,
  created_by INTEGER REFERENCES users(id),
  assigned_to INTEGER REFERENCES users(id) on delete CASCADE ,
  status VARCHAR(20) CHECK (status IN ('pending', 'completed')) DEFAULT 'pending'
);

drop TABLE tasks ;
CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  worker_id INTEGER REFERENCES users(id) on delete CASCADE,
  coin_withdrawn INTEGER,
  payment_method VARCHAR(50),
  account_number VARCHAR(50),
  status VARCHAR(20) DEFAULT 'pending',
  withdraw_date DATE
);

drop TABLE payments;
-- Users
INSERT INTO users (name, email, role) VALUES 
('Munna Khan', 'mk8761174@gmail.com', 'worker'),
('Sarah Ali', 'sarah@example.com', 'buyer'),
('Admin User', 'admin@example.com', 'admin'),
('Faisal Ahmed', 'faisal@example.com', 'worker');

-- Tasks
INSERT INTO tasks (title, description, coin_reward, created_by, assigned_to) VALUES 
('Facebook Like Task', 'Like a specific page on Facebook', 20, 2, 1),
('YouTube Commenting', 'Comment on a video', 25, 2, 4),
('Reddit Upvote', 'Upvote a thread in a subreddit', 30, 2, 1);

-- Payments
INSERT INTO payments (worker_id, coin_withdrawn, payment_method, account_number, withdraw_date) VALUES 
(1, 200, 'Bkash', '017xxxxxxxx', '2025-05-20'),
(4, 400, 'Nagad', '018xxxxxxxx', '2025-05-21');

SELECT * from  users;
SELECT * from  tasks;
SELECT * from  payments;


--Practice Questions (based on your level)
-- List all users with role = 'worker'.
SELECT * from users WHERE role= 'worker';

-- Find all tasks assigned to 'Munna Khan'.
SELECT * from tasks 
join users on tasks.assigned_to=users.id
WHERE name = 'Munna Khan'

-- Show total coins withdrawn by each worker.
SELECT worker_id,sum(coin_withdrawn)as total_coins
from payments
GROUP BY worker_id


-- Which users have not been assigned any task yet?
SELECT * from users
LEFT join tasks on users.id=tasks.assigned_to
where tasks. assigned_to is  NULL;

-- Count how many tasks are completed and pending.
SELECT status ,count(*)  from tasks GROUP BY status;

-- Show all tasks with their creator’s and assignee’s names (use JOIN).
SELECT *  from  users
JOIN tasks on  tasks.id =users.id ;

-- Find workers who have withdrawn more than 300 coins.
SELECT payments.worker_id,users.name from payments
join users on payments.worker_id= users.id
GROUP BY payments.worker_id,users.name
 HAVING sum(coin_withdrawn)>300




-- Update a task status to 'completed' for task ID 1.
SELECT * from tasks;
UPDATE tasks set status ='completed'
WHERE id=1  ;

-- Delete a user and cascade their tasks and payments. (Think: How would you design this?)
SELECT *,assigned_to from users 
join tasks on users.id=tasks.id


DELETE from users  WHERE id = 1

-- Find the total coins rewarded to each worker from tasks.
SELECT  worker_id, sum(coin_reward) from tasks
join payments on tasks.id=payments.worker_id
GROUP BY  worker_id 
