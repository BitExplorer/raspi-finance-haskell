stack install postgresql-simple


CREATE TABLE books (
  isbn TEXT PRIMARY KEY,
  guid TEXT NULL,
  title TEXT NOT NULL,
  authors TEXT NOT NULL
);

insert into books(isbn,title,authors) values(1,'test','test');
