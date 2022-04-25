-- Constraints --
/*
PRIMARY KEY
unique/not null

Foreign KEY
must exist in the original table

Check constraint to put a condition
CONSTRAINT check_salary_not_below_zero CHECK (salary >= 0)

UNIQUE
value in the column must be unique (Not repeated)
email text UNIQUE

NOT NULL 
The value must exist and to add this constraint we do it directly when creating the column
last_name text NOT NULL

*/