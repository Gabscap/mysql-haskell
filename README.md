mysql-haskell
=============

[![Build Status](https://travis-ci.org/winterland1989/mysql-haskell.svg)](https://travis-ci.org/winterland1989/mysql-haskell)

`mysql-haskell` is a MySQL driver written entirely in haskell by @winterland1989 at infrastructure department of Didi group, it's going to be used in projects aiming at replacing old java based MySQL middlewares.

This project is still in experimental stage and lack of produciton tests, use on your own risk, any form of contributions are welcomed!

Is it fast?
----------

In short, it's about 2 times slower than pure c/c++, but 5 times faster than old FFI bindings(mysql by Bryan O'Sullivan).

<img src="https://github.com/winterland1989/mysql-haskell/blob/master/benchmark/benchmark2016-08-14.png?raw=true">

Above figures showed the time to perform a "select * from employees" from a [sample table](https://github.com/datacharmer/test_db).

Motivation
----------

While MySQL may not be the most advanced sql database, it's widely used among China companies, including but not limited to Baidu, Alibaba, Tecent etc., but haskell's MySQL support is not ideal, we only have a very basic MySQL binding written by Bryan O'Sullivan, and some higher level wrapper built on it, which have some problems:

+ lack of prepared statment and binary protocol support.

+ limited concurrency due to FFI.

+ no replication protocol support.

`mysql-haskell` is intended to solve these problems, and provide foundation for higher level libraries such as groundhog and persistent, so that accessing MySQL is both fast and easy in haskell.

Build Test Benchmark
--------------------

Just use the old way:

```bash
git clone https://github.com/winterland1989/mysql-haskell.git
cd mysql-haskell
cabal install --only-dependencies
cabal build
```

Running tests require a local MySQL server, a user `testMySQLHaskell` and a database `testMySQLHaskell`, you can do it use following script:

```bash
mysql -u root -e "CREATE DATABASE IF NOT EXISTS testMySQLHaskell;"
mysql -u root -e "CREATE USER 'testMySQLHaskell'@'localhost' IDENTIFIED BY ''"
mysql -u root -e "GRANT ALL PRIVILEGES ON testMySQLHaskell.* TO 'testMySQLHaskell'@'localhost'"
mysql -u root -e "FLUSH PRIVILEGES"
```

You should enable binlog by adding `log_bin = filename` to `my.cnf` or add `--log-bin=filename` to the server, and grant replication access to `testMySQLHaskell` with:

```bash
mysql -u root -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'testMySQLHaskell'@'localhost';"
```

And you should set binlog to `row` by adding `binlog_format = ROW` to `my.cnf`.

New features in MySQL 5.7 are tested seperately, you can run them by setting environment varible `MYSQLVER=5.7`, travis is keeping
an eye on following combinations:

+ CABALVER=1.18 GHCVER=7.8.4  MYSQLVER=5.5
+ CABALVER=1.22 GHCVER=7.10.2 MYSQLVER=5.5
+ CABALVER=1.24 GHCVER=8.0.1  MYSQLVER=5.5
+ CABALVER=1.24 GHCVER=8.0.1  MYSQLVER=5.6
+ CABALVER=1.24 GHCVER=8.0.1  MYSQLVER=5.7

Please reference `.travis.yml` if you have problems with setting up test environment.

Enter benchmark directory and run `./bench.sh` to benchmark 1) c++ version 2) mysql-haskell 3) FFI version mysql, you may need to modify `bench.sh`(change the include path) to get c++ version compiled.

Guide
-----

Run `cabal haddock` and you will get pretty decent document.

Reference
---------

[MySQL official site](https://dev.mysql.com/doc/internals/en/) provided intensive document, but without following project, `mysql-haskell` may not be written at all:

+ [mysql-binlog-connector-java](https://github.com/shyiko/mysql-binlog-connector-java)

+ [canal](https://github.com/alibaba/canal)

+ [go mysql toolkit](https://github.com/siddontang/go-mysql)

+ [python binlog parser](https://github.com/noplay/python-mysql-replication)

License
-------

Copyright (c) 2016, winterland1989

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.

    * Neither the name of winterland1989 nor the names of other
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
