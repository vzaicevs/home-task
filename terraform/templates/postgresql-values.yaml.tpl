primary:
  initdb:
    scripts:
      00_create_database.sql: |
        CREATE USER ${db_user} WITH ENCRYPTED PASSWORD '${db_password}';
        CREATE DATABASE ${db_name} OWNER ${db_user};

global:
  storageClass: ${db_storageclass}
