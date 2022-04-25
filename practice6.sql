-- You can have small wait times for QUERYS using Data Structures like Index

-- Before creating the index

EXPLAIN ANALYZE SELECT * FROM new_york_addresses 
WHERE street = 'BROADWAY'; -- 2776 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = '52 STREET'; -- Time Cost: 1152 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE'; -- Time Cost: 1121 ms

/*An index can shorten QUERY times, saves information as 
pointers and lowers the search time (Similar to a hash table)*/

CREATE INDEX street_idx ON new_york_addresses (street);

-- After creating the index
EXPLAIN ANALYZE SELECT * FROM new_york_addresses 
WHERE street = 'BROADWAY'; -- Time Cost: 421 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = '52 STREET'; -- Time Cost: 574 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE'; -- Time Cost: 565 ms