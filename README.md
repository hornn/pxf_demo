# Demo Instructions
## Prerequsites
1. Hdfs, Hive, HBase setup
2. HAWQ/PXF (https://github.com/apache/incubator-hawq) setup

## Tables

1. 1 HDFS file
2. 1 HBase table 
3. 1 Hive table with partitions
To create HDFS file and data:
```
sh create_hdfs.sh
```

## In Hive
To create Hive table and data:
```
hive -f create_hive.sql
```

View Hive table on HDFS:
```
hdfs dfs -ls /hive/warehouse/demo.db/customers/
```

## In HBase
To create HBase table and data:
```
sh create_hbase.sh
```

## In HAWQ

1. Readable table for HDFS file
2. Readable table for HBase table
3. Readable table for Hive table
4. Writable table for HDFS file

To create HAWQ tables:
```
createdb demo
psql -d demo -f create_hawq_tables.sql
```

Join between all 3 readable table and a local HAWQ table.
HBase table query with filter on text/int fields
Hive table query with filter on partition fields
Write the results into HDFS table

To run queries via HAWQ:

Top 10 products of a specific country (Belgium)
```
SELECT count(*) AS number_of_purchases, products."product:name"
FROM products, customers, transactions
WHERE products.recordkey = transactions.product_id
AND   customers.customer_id = transactions.customer_id
AND   customers.country = 'Belgium'
GROUP BY products."product:name"
ORDER BY number_of_purchases DESC
LIMIT 10;
```

Top 10 Customers by revenue, who bought items below 50$
```
SELECT customers.first_name|| ' ' || customers.last_name as customer_name, SUM(products."product:price") as revenue
FROM products, customers, transactions
WHERE products.recordkey = transactions.product_id
AND   customers.customer_id = transactions.customer_id
AND   products."product:price" < 50
GROUP BY customers.customer_id, customers.first_name, customers.last_name
ORDER BY revenue DESC
LIMIT 10;
```

Push aggreagate result form HAWQ to HDFS via Writable table

```
INSERT INTO customer_spend
SELECT customers.first_name|| ' ' || customers.last_name as customer_name, SUM(products."product:price") as revenue
FROM products, customers, transactions
WHERE products.recordkey = transactions.product_id
AND   customers.customer_id = transactions.customer_id
GROUP BY customers.customer_id, customers.first_name, customers.last_name
ORDER BY revenue DESC;
```

Check output on HDFS
```
hadoop fs -cat /pxf_demo/customer_spend/*
```
