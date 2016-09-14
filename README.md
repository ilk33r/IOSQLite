# IOSQLite
SQLite framework for iOS, OSX and Linux written with swift.

|| **Build** |
|---|---|
|**macOS Xcode 7.3**       |[![Build Status](https://travis-ci.org/ilk33r/IOSQLite.svg?branch=master)](https://travis-ci.org/ilk33r/IOSQLite)|
|**macOS Xcode 8**         |[![Build Status](https://travis-ci.org/ilk33r/IOSQLite.svg?branch=master)](https://travis-ci.org/ilk33r/IOSQLite)|
|**Ubuntu 14.04**          |[![Build Status](https://travis-ci.org/ilk33r/IOSQLite.svg?branch=master)](https://travis-ci.org/ilk33r/IOSQLite)|
|**Ubuntu 15.10**          |[![Build Status](https://travis-ci.org/ilk33r/IOSQLite.svg?branch=master)](https://travis-ci.org/ilk33r/IOSQLite)|

### Instructions

* **Build**
`:$ make`

* **Test IOSQLite**
`:$ make test`

* **Clean project**
`:$ make dist-clean`

* **For debug build**
`:$ make BUILD=debug`

### Basic Methods
* IOSQLite(databasePath: String) throws
* IOSQLite.query(queryString: String) throws
* IOSQLite.getResults() -> IOSQLiteResult
* IOSQLite.freeResult() throws
* IOSQLite.lastInsertId() -> Int64
* IOSQLite.closeConnection()

### Active record examples

All active record examples inside the IOSQLiteTest project.

* Select examples IOSQLiteTest/SelectTest*
* Update example IOSQLiteTest/UpdateTest.swift
* Delete example IOSQLiteTest/DeleteTest.swift
* Insert example IOSQLiteTest/InsertTest.swift


