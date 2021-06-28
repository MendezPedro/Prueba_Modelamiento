\c postgres

DROP DATABASE biblioteca;
CREATE DATABASE biblioteca;

\c biblioteca

create table partners (
    id serial primary key,
    dni varchar(15),
    name_partner varchar(10),
    last_name varchar(10),
    address_partner varchar(50),
    phone int
);

create table authors (
    id serial primary key,
    name_author varchar(10),
    last_name varchar(10),
    birth int,
    die int,
    type_author varchar(10)
);

create table books (
    isbn varchar(15) primary key,
    title varchar(30),
    number_pages int,
    author_id int,
    co_author_id int,
    loan_days int,
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

create table author_books (
    author_id int,
    book_isbn varchar(15),
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (book_isbn) REFERENCES books(isbn)
);

create table loans (
    begin_date date,
    return_true date,
    partner_id int,
    book_isbn varchar(15),
    FOREIGN KEY (partner_id) REFERENCES partners(id),
    FOREIGN KEY (book_isbn) REFERENCES books(isbn)
);

\copy partners from 'socios.csv' csv header;
\copy authors from 'autores.csv' csv header;
\copy books from 'libros.csv' csv header;
\copy author_books from 'autor_libro.csv' csv header;
\copy loans from 'historial_de_prestamos.csv' csv header;

select * from partners;
select * from books;
select * from authors;
select * from author_books;
select * from loans;

--3.- consultas
--A
select title, number_pages from books where number_pages < 300;

--B
select name_author, last_name, birth from authors where birth > 1970;

--C
select title 
from (select book_isbn, count(book_isbn) AS total
from loans P
group by book_isbn
order by total desc) as x
inner join books B 
on B.isbn = x.book_isbn
limit 1;

--D
SELECT name_partner, precio_multa
FROM (SELECT partner_id, begin_date,return_true,loan_days,
    case when DATE_PART('day',  return_true::timestamp -( begin_date + loan_days)::timestamp) <= 0 then 0 
    else
    DATE_PART('day',  return_true::timestamp -( begin_date + loan_days)::timestamp) * 100 end 
    as precio_multa
    FROM loans, books
    WHERE 
    loans.book_isbn = books.isbn) as multados, partners
WHERE multados.partner_id = partners.id;