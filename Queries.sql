-- Queries :

-- Q1:
SELECT BillingCountry, COUNT(*) AS invoices_number
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC

-- Q2:
SELECT BillingCity, SUM(Total) AS invoices_total
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Q3:
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       sum(inv.UnitPrice) AS invoices
FROM Invoice i
JOIN InvoiceLine il
ON il.Invoiceid = i.Invoiceid
JOIN Customer c
ON c.CustomerId = i.CustomerId
GROUP BY 1,2,3
ORDER BY i.Total DESC
LIMIT 1

-- Q4:
SELECT c.Email,
       c.FirstName,
       c.LastName,
       g.Name
FROM Customer c
JOIN Invoice i
ON c.CustomerId= i.CustomerId
JOIN InvoiceLine il
ON i.InvoiceId= il.InvoiceId
JOIN Track t
ON t.TrackId = il.TrackId
JOIN Genre g
ON g.GenreId = t.GenreId
WHERE g.Name = 'Rock'
GROUP BY 1

-- Q5:
WITH c AS (SELECT Invoice.CustomerId AS id_cst, 
                 Invoice.BillingCountry AS Country, 
                 SUM(Invoice.Total) AS som 
           FROM Invoice
           JOIN Customer 
           ON Invoice.BillingCountry = Customer.Country AND Invoice.CustomerId = Customer.CustomerId
           GROUP BY 1,2
           ORDER BY 2 ),
          
    Customers AS (SELECT Customer.CustomerId as cust_id, 
                         Customer.FirstName as name_customer, 
                         Customer.LastName as lastname_customer 
              FROM Customer)

SELECT customers.cust_id, 
       customers.name_customer,
       customers.lastname_customer, 
       b.country, 
       b.max_som 
FROM Customers, (SELECT a.country AS country, 
                        max(a.som) AS max_som 
                 FROM (SELECT Invoice.CustomerId AS id_cst, 
                              Invoice.BillingCountry AS Country, 
                              SUM(Invoice.Total) AS som 
                       FROM Invoice 
                       JOIN Customer 
                       ON Invoice.BillingCountry = Customer.Country AND Invoice.CustomerId = Customer.CustomerId
                       GROUP BY 1,2
                       ORDER BY 2 ) AS a
                 GROUP BY 1
                 ORDER BY 2 ) AS b
JOIN c
ON c.country = b.country AND c.som = b.max_som
WHERE Customers.cust_id = c.id_cst

-- The end !