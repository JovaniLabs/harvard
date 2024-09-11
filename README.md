"Specififcation"

"In indexes.sql, write a set of SQL statements that create indexes which will speed up typical queries on the harvard.db database. The number of indexes you create, as well as the columns they include, is entirely up to you. Be sure to balance speed with disk space, only creating indexes you need.

When engineers optimize a database, they often care about the typical queries run on the database. Such queries highlight patterns with which a database is accessed, thus revealing the best columns and tables on which to create indexes. Click the spoiler tag below to see the set of typical SELECT queries run on harvard.db.

Typical SELECT queries on harvard.db
Be sure to consider the Advice section as you get started!


Advice
In this problem, you’ll take the opposite perspective you did while working on In a Snap: rather than design a query that takes advantage of existing indexes, your task is to design indexes which existing queries can take advantage of.

Use EXPLAIN QUERY PLAN on each SELECT query to assess where best to create indexes
Minimize the number of indexes you've created


Usage
To load your indexes as you write them in indexes.sql, you can use

.read indexes.sql
Keep in mind you can also use

DROP INDEX name;
where name is the name of your index, to remove an index before creating it anew.

You may want to use VACUUM to free up disk space after you delete an index!
"
