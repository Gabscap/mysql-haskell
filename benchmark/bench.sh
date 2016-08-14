#!/bin/bash

mysql -utestMySQLHaskell < employees.sql

g++ ./libmysql.cpp -lmysqlclient -lpthread -lz -lm -lssl -lcrypto -ldl -I/usr/local/include/mysql -o libmysql
echo "=============== start benchmark c++ client ================"
time ./libmysql 1
time ./libmysql 2
time ./libmysql 3
time ./libmysql 4
time ./libmysql 10
rm ./libmysql
echo "=============== benchmark c++ client end ================"

g++ ./libmysql_prepared.cpp -lmysqlclient -lpthread -lz -lm -lssl -lcrypto -ldl -I/usr/local/include/mysql -o libmysql_prepared
echo "=============== start benchmark c++ client prepared ================"
time ./libmysql_prepared 1
time ./libmysql_prepared 2
time ./libmysql_prepared 3
time ./libmysql_prepared 4
time ./libmysql_prepared 10
rm ./libmysql_prepared
echo "=============== benchmark c++ client prepared end ================"

cabal build
echo "=============== start benchmark haskell client ============="
time ./dist/build/bench/bench 1  
time ./dist/build/bench/bench 2  
time ./dist/build/bench/bench 3  
time ./dist/build/bench/bench 4  
time ./dist/build/bench/bench 10 
echo "=============== benchmark haskell client end ================"

echo "=============== start benchmark haskell client FFI ============="
time ./dist/build/benchFFI/benchFFI 1  
time ./dist/build/benchFFI/benchFFI 2  
time ./dist/build/benchFFI/benchFFI 3  
time ./dist/build/benchFFI/benchFFI 4  
time ./dist/build/benchFFI/benchFFI 10
echo "=============== benchmark haskell client FFI end ================"

echo "=============== start benchmark haskell client prepared ============="
time ./dist/build/benchPrepared/benchPrepared 1  
time ./dist/build/benchPrepared/benchPrepared 2  
time ./dist/build/benchPrepared/benchPrepared 3  
time ./dist/build/benchPrepared/benchPrepared 4  
time ./dist/build/benchPrepared/benchPrepared 10 
echo "=============== benchmark haskell client prepared end ================"

mysql -utestMySQLHaskell -DtestMySQLHaskell -e "DROP TABLE employees;"
