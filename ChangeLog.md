# Revision history for mysql-haskell

## 0.8.3.0  -- 2017-10-09

* Remove unnecessary exports from `Database.MySQL.Base`.
* Reuse TCP connection when using TLS.
* Clean up some compiler warnings.

## 0.8.2.0  -- 2017-10-09

Courtesy of naushadh, `mysql-haskell` will be on stackage again.

* Update to use `tcp-streams-1.x`.
* Fix compatibility with new  `tls/memory` version.

## 0.8.1.0  -- 2016-11-09

* Add `Show` instance to `ConnectInfo`.
* Add proper version bound for `binary`.

## 0.8.0.0  -- 2016-11-09

* Add `ciCharset` field to support `utf8mb4` charset.
* Add `BitMap` field to `COM_STMT_EXECUTE`, and [#8](https://github.com/winterland1989/mysql-haskell/pull/8) by [alexbiehl](https://github.com/alexbiehl).

## 0.7.1.0 -- 2016-11-21

* Add `QueryParam` class and `Param` datatype for multi-valued parameter(s) by [naushadh](https://github.com/naushadh).

## 0.7.0.0 -- 2016-11-09

* Split openssl support to [mysql-haskell-openssl](http://hackage.haskell.org/package/mysql-haskell-openssl).
* Expose `Database.MySQL.Connection` module due to this split, it shouldn't be used by user directly.

## 0.6.0.0 -- 2016-10-25

* Use binary-ieee754 for older binary compatibility.
* Clean up `Database.MySQL.Protocol.MySQLValue` 's export.

## 0.5.1.0 -- 2016-10-20

* Add `queryVector`, `queryVector_` and `queryStmtVector`.
* Use binary-parsers to speed up binary parsers.

## 0.5.0.0 -- 2016-8-22

* Export exception types.
* Fix a regression cause password authentication failed, add tests.
* Fix a reading order bug cause 'prepareStmt/prepareStmtDetail' failed.

## 0.4.0.0 -- 2016-8-22

* Enable TLS support via `tls` package, add benchmarks.

## 0.3.0.0  -- 2016-8-22

* Fix tls connection, change TLS implementation to HsOpenSSL, add benchmarks.
* Fix a bug in 'putLenEncInt' which cause sending large field fail.
* Various optimizations.

## 0.2.0.0  -- 2016-8-19

* Fix OK packet decoder.
* Fix sending large packet(>16M).
* Add `executeMany`, `withTransaction` to Base module.
* Add timestamp field to `RowBinLogEvent`.
* Add test, add insert benchmark.

## 0.1.0.0  -- 2016-8-16

* First version. Released on an unsuspecting world.
