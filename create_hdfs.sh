###########################
# HDFS file of the format:
#
# id (integer), 
# product_id (integer), 
# customer_id (integer),
# time (YYYY-MM-DD)
#
# where all fields are comma delimited.
#
###########################

# 1. create file with data
sh create_hdfs_file.sh

# 2. copy file to hdfs
hdfs dfs -rm -r /pxf_demo
hdfs dfs -mkdir /pxf_demo
hdfs dfs -copyFromLocal `pwd`/transactions.csv /pxf_demo/.

# view data
hdfs dfs -cat /pxf_demo/transactions.csv | head
hdfs dfs -cat /pxf_demo/transactions.csv | wc


 
