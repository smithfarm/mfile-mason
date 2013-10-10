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
CREATE TABLE mfiledb.users (
   id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   name CHAR(32) CHARACTER SET ascii NOT NULL UNIQUE,
   admin BOOLEAN NOT NULL,
   disabled BOOLEAN NOT NULL,
   created DATETIME NOT NULL,
   last_login DATETIME
);
CREATE TABLE mfiledb.mac_addresses (
   id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   address CHAR(17) CHARACTER SET ascii NOT NULL UNIQUE,
   owner_id MEDIUMINT UNSIGNED NOT NULL,
   ts TIMESTAMP
);
INSERT INTO mfiledb.users (name, admin, disabled, created) 
   VALUES ('smithfarm', 1, 0, NOW());
