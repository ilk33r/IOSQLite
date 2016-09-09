//
//  TestCreateTable.swift
//  IOSQLite
//
//  Created by ilker özcan on 08/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

let listTables_query = "SELECT name FROM sqlite_master WHERE type='table';"

let createTable_query1 = "CREATE TABLE \"test_table_1\""
+ "("
	+ "id INTEGER PRIMARY KEY, "
	+ "table_2_id INTEGER NOT NULL, "
	+ "table_3_id INTEGER NOT NULL, "
	+ "table_4_id INTEGER NOT NULL, "
	+ "t1_col_intval INTEGER NOT NULL, "
	+ "t1_col_doubleval REAL DEFAULT 0, "
	+ "t1_col_strval_1 TEXT NOT NULL, "
	+ "t1_col_strval_2 TEXT, "
	+ "CONSTRAINT test_table_1_table_2_fk FOREIGN KEY (table_2_id) REFERENCES test_table_2 (id) DEFERRABLE INITIALLY DEFERRED, "
	+ "CONSTRAINT test_table_1_table_3_fk FOREIGN KEY (table_3_id) REFERENCES test_table_3 (id) DEFERRABLE INITIALLY DEFERRED, "
	+ "CONSTRAINT test_table_1_table_4_fk FOREIGN KEY (table_4_id) REFERENCES test_table_4 (id) DEFERRABLE INITIALLY DEFERRED"
 + ");"

let createTable_query2 = "CREATE TABLE \"test_table_2\""
+ "("
	+ "id INTEGER PRIMARY KEY, "
	+ "t2_col_intval INTEGER NOT NULL, "
	+ "t2_col_strval_1 TEXT NOT NULL"
+ ");"

let createTable_query3 = "CREATE TABLE \"test_table_3\""
+ "("
	+ "id INTEGER PRIMARY KEY, "
	+ "t3_col_intval INTEGER NOT NULL, "
	+ "t3_col_strval_1 TEXT NOT NULL"
+ ");"

