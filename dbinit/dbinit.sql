# 
# dbinit.sql
#
# Run like this:
# $ sudo mysql -u root <dbinit.sql
#
# (this assumes you have set the root password in the [client] section
# of /etc/my.cnf)
#
CREATE DATABASE IF NOT EXISTS mfiledb;
CREATE USER 'mfile'@'localhost' IDENTIFIED BY 'mfile';
GRANT ALL ON mfiledb.* TO 'mfile'@'localhost';
