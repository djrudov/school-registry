CREATE TABLE departments (
  id varchar(4) PRIMARY KEY,
  name varchar(30) NOT NULL UNIQUE,
  chair_email varchar(30) REFERENCES faculty(email)
);

CREATE TABLE faculty (
  id integer,
  email varchar(30) PRIMARY KEY,
  last_name NOT NULL,
  first_name NOT NULL,
  phone varchar(15),
  address varchar(100),
  department varchar(4) REFERENCES departments(id),
  department_2 varchar(4) REFERENCES departments(id)
);

CREATE TABLE staff (
  email varchar(30) PRIMARY KEY,
  last_name varchar(30) NOT NULL,
  first_name varchar(20) NOT NULL,
  role varchar(30) NOT NULL,
  team varchar(30) NOT NULL,
  extension integer,
  phone varchar(15),
  address varchar(100)
);

CREATE TABLE students (
  id integer PRIMARY KEY,
  email varchar(30) NOT NULL UNIQUE,
  last_name varchar(30),
  first_name varchar(20),
  status varchar(15), -- undergraduate, postgraduate, visiting, nondegree
  programme varchar(30) REFERENCES programmes(id), -- or 'major'
  dob date NOT NULL,
  guardian_id integer REFERENCES guardians(id),
  home_student BOOLEAN, -- 'home' or 'international' student
  CONSTRAINT under_18_guardian_info_empty -- require guardian under 18
  CHECK ((EXTRACT year from AGE(dob)) > 18 OR guardian_id IS NOT NULL)
);

CREATE TABLE students_contact_info (
  student_id integer REFERENCES students(id) PRIMARY KEY,
  name varchar(30) NOT NULL,
  phone varchar(15),
  email varchar(30),
  local_address varchar(100),
  permanent_address varchar(100),
  CONSTRAINT address
  CHECK (local_address IS NOT NULL OR permanent_address IS NOT NULL)
);

CREATE TABLE guardians (
  id integer PRIMARY KEY,
  name varchar(30) NOT NULL,
  phone varchar(15) NOT NULL,
  relationship varchar(30)
);

CREATE TABLE programmes (
  id varchar(6) PRIMARY KEY,
  name varchar(30) NOT NULL UNIQUE,
  department varchar(4) REFERENCES departments(id) NOT NULL,
  department_2 varchar(4) REFERENCES departments(id)
);

CREATE TABLE courses (
  id varchar(6) PRIMARY KEY,
  department text(2) REFERENCES departments(id),
  number integer(4) NOT NULL UNIQUE,
  name varchar(30) NOT NULL UNIQUE,
  description text NOT NULL,
  lecturer_id integer REFERENCES faculty(id),
  room varchar(20) REFERENCES rooms(id)
);

CREATE TABLE semester_courses (
  student_id integer REFERENCES students(id) NOT NULL,
  course_id varchar(6) REFERENCES courses(id) NOT NULL,
  grade integer
);

CREATE TABLE past_courses (
  student_id integer REFERENCES students(id) NOT NULL,
  course_id varchar(6) REFERENCES courses(id) NOT NULL,
  grade integer NOT NULL
);

CREATE TABLE rooms (
  id integer PRIMARY KEY,
  type varchar(30), -- Classroom, meeting room, study room, etc
  max_capacity integer, -- per fire code
  computer varchar(15) REFERENCES computers(name),
  projector boolean,
  cameras boolean, -- for recording and distance learning
  seats integer,
  equipment text
);

CREATE TABLE computers (
  name varchar(15) PRIMARY KEY,
  serial varchar(20) NOT NULL UNIQUE,
  location varchar(30),
  department varchar(4),
  mac_address varchar(17) NOT NULL UNIQUE,
  os varchar(12) NOT NULL,
  processor varchar(10) NOT NULL,
  manufacturer varchar(10) NOT NULL,
  model varchar(20) NOT NULL,
  ram integer NOT NULL,
  purchase_date date,
  setup_date date NOT NULL,
  last_update date NOT NULL
);
