/*
Find a student’s historical course enrollments, based on their ID:

sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "courses"."title", "courses"."semester"
   ...> FROM "enrollments"
   ...> JOIN "courses" ON "enrollments"."course_id" = "courses"."id"
   ...> JOIN "students" ON "enrollments"."student_id" = "students"."id"
   ...> WHERE "students"."id" = 3;
QUERY PLAN
|--SEARCH students USING INTEGER PRIMARY KEY (rowid=?)
|--SCAN enrollments
`--SEARCH courses USING INTEGER PRIMARY KEY (rowid=?)
*/

CREATE INDEX IF NOT EXISTS "index_enrollments_on_course_id"
ON "enrollments" ("course_id");

CREATE INDEX IF NOT EXISTS "index_courses_on_id"
ON "courses" ("id");

CREATE INDEX IF NOT EXISTS "index_enrollments_on_student_id"
ON "enrollments" ("student_id");

CREATE INDEX IF NOT EXISTS "index_students_on_id"
ON "students" ("id");

/*
Find all students who enrolled in Computer Science 50 in Fall 2023:

sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "courses"."title", "courses"."semester"
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "id", "name"
   ...> FROM "students"
   ...> WHERE "id" IN (
   ...>     SELECT "student_id"
   ...>     FROM "enrollments"
   ...>     WHERE "course_id" = (
   ...>         SELECT "id"
   ...>         FROM "courses"
   ...>         WHERE "courses"."department" = 'Computer Science'
   ...>         AND "courses"."number" = 50
   ...>         AND "courses"."semester" = 'Fall 2023'
   ...>     )
   ...> );
QUERY PLAN
|--SEARCH students USING INTEGER PRIMARY KEY (rowid=?)
`--LIST SUBQUERY 2
   |--SCAN enrollments
   `--SCALAR SUBQUERY 1
      `--SCAN courses
*/

CREATE INDEX IF NOT EXISTS "index_courses_on_department_number_semester"
ON "courses" ("department", "number", "semester");

CREATE INDEX IF NOT EXISTS "index_enrollments_on_course_id"
ON "enrollments" ("course_id");

CREATE INDEX IF NOT EXISTS "index_enrollments_on_student_id"
ON "enrollments" ("student_id");

/*
Sort courses by most- to least-enrolled in Fall 2023:

sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "courses"."id", "courses"."department", "courses"."number", "courses"."title", COUNT(*) AS "enrollment"
   ...> FROM "courses"
   ...> JOIN "enrollments" ON "enrollments"."course_id" = "courses"."id"
   ...> WHERE "courses"."semester" = 'Fall 2023'
   ...> GROUP BY "courses"."id"
   ...> ORDER BY "enrollment" DESC;
QUERY PLAN
|--SCAN enrollments
|--SEARCH courses USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
`--USE TEMP B-TREE FOR ORDER BY
*/

CREATE INDEX IF NOT EXISTS "index_courses_on_semester"
ON "courses" ("semester");

CREATE INDEX IF NOT EXISTS "index_enrollments_on_course_id"
ON "enrollments" ("course_id");

/*
Find all computer science courses taught in Spring 2024:

sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "courses"."id", "courses"."department", "courses"."number", "courses"."title"
   ...> FROM "courses"
   ...> WHERE "courses"."department" = 'Computer Science'
   ...> AND "courses"."semester" = 'Spring 2024';
QUERY PLAN
`--SCAN courses
*/

CREATE INDEX IF NOT EXISTS "index_courses_on_department_and_semester"
ON "courses" ("department", "semester");

/*

Find the requirement satisfied by “Advanced Databases” in Fall 2023:

sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "requirements"."name"
   ...> FROM "requirements"
   ...> WHERE "requirements"."id" = (
   ...>     SELECT "requirement_id"
   ...>     FROM "satisfies"
   ...>     WHERE "course_id" = (
   ...>         SELECT "id"
   ...>         FROM "courses"
   ...>         WHERE "title" = 'Advanced Databases'
   ...>         AND "semester" = 'Fall 2023'
   ...>     )
   ...> );
QUERY PLAN
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--SCALAR SUBQUERY 2
   |--SCAN satisfies
   `--SCALAR SUBQUERY 1
      `--SCAN courses
*/

CREATE INDEX IF NOT EXISTS "index_satisfies_on_courses_id"
ON "satisfies" ("course_id");

CREATE INDEX IF NOT EXISTS "index_courses_on_title_and_semester"
ON "courses" ("title", "semester");
/*
Find how many courses in each requirement a student has satisfied:

sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "requirements"."name", COUNT(*) AS "courses"
   ...> FROM "requirements"
   ...> JOIN "satisfies" ON "requirements"."id" = "satisfies"."requirement_id"
   ...> WHERE "satisfies"."course_id" IN (
   ...>     SELECT "course_id"
   ...>     FROM "enrollments"
   ...>     WHERE "enrollments"."student_id" = 8
   ...> )
   ...> GROUP BY "requirements"."name";
QUERY PLAN
|--SCAN satisfies
|--LIST SUBQUERY 1
|  `--SCAN enrollments
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--USE TEMP B-TREE FOR GROUP BY
*/
CREATE INDEX IF NOT EXISTS "index_satisfies_on_requirements_id_and_course_id"
ON "satisfies" ("requirements_id", "course_id");

CREATE INDEX IF NOT EXISTS "index_enrollments_on_student_id"
ON "enrollments" ("student_id");
/*

Search for a course by title and semester:

sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "department", "number", "title"
   ...> FROM "courses"
   ...> WHERE "title" LIKE "History%"
   ...> AND "semester" = 'Fall 2023';
QUERY PLAN
`--SCAN courses
*/
CREATE INDEX IF NOT EXISTS "index_courses_on_title_and_semester"
ON "courses" ("title", "semester");

