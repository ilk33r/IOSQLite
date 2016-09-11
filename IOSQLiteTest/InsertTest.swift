//
//  InsertTest.swift
//  IOSQLite
//
//  Created by ilker özcan on 09/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

func insertTest(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	var insertIds_2 = [Int64]()
	var insertIds_3 = [Int64]()
	
	if(continueToNextTest) {
		
		
		var insertEntity_2_1 = IOSQLiteEntity(tableName: "test_table_2")
		insertEntity_2_1.addInsert(columns: ["t2_col_intval", "t2_col_strval_1"])
		insertEntity_2_1.setParam(intParam: 1)
		insertEntity_2_1.setParam(strParam: "Str 1")
		
		do {
			
			let query = try insertEntity_2_1.getQuery()
			
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			insertIds_2.append(sqlite.lastInsertId())
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
		
		
		var insertEntity_2_2 = IOSQLiteEntity(tableName: "test_table_2")
		insertEntity_2_2.addInsert(columns: ["t2_col_intval", "t2_col_strval_1"])
		insertEntity_2_2.setParam(intParam: 2)
		insertEntity_2_2.setParam(strParam: "Str 2")
		
		do {
			
			let query = try insertEntity_2_2.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			insertIds_2.append(sqlite.lastInsertId())
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
		
		var insertEntity_2_3 = IOSQLiteEntity(tableName: "test_table_2")
		insertEntity_2_3.addInsert(columns: ["t2_col_intval", "t2_col_strval_1"])
		insertEntity_2_3.setParam(intParam: 3)
		insertEntity_2_3.setParam(strParam: "Str 3")
		
		do {
			
			let query = try insertEntity_2_3.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			insertIds_2.append(sqlite.lastInsertId())
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
	}
	
	if(continueToNextTest) {
		
		var insertEntity_3_1 = IOSQLiteEntity(tableName: "test_table_3")
		insertEntity_3_1.addInsert(forColumn: "t3_col_intval")
		insertEntity_3_1.addInsert(forColumn: "t3_col_strval_1")
		insertEntity_3_1.setParam(intParam: 31)
		insertEntity_3_1.setParam(strParam: "Str 31")
		
		do {
			
			let query = try insertEntity_3_1.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			insertIds_3.append(sqlite.lastInsertId())
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
		
		var insertEntity_3_2 = IOSQLiteEntity(tableName: "test_table_3")
		insertEntity_3_2.addInsert(forColumn: "t3_col_intval")
		insertEntity_3_2.addInsert(forColumn: "t3_col_strval_1")
		insertEntity_3_2.setParam(intParam: 32)
		insertEntity_3_2.setParam(strParam: "Str 32")
		
		do {
			
			let query = try insertEntity_3_2.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			insertIds_3.append(sqlite.lastInsertId())
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
		
		var insertEntity_3_3 = IOSQLiteEntity(tableName: "test_table_3")
		insertEntity_3_3.addInsert(forColumn: "t3_col_intval")
		insertEntity_3_3.addInsert(forColumn: "t3_col_strval_1")
		insertEntity_3_3.setParam(intParam: 33)
		insertEntity_3_3.setParam(strParam: "Str 33")
		
		do {
			
			let query = try insertEntity_3_3.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			insertIds_3.append(sqlite.lastInsertId())
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
	}
	
	if(continueToNextTest) {
		
		var insertEntity_1_1 = IOSQLiteEntity(tableName: "test_table_1")
		insertEntity_1_1.addInsert(columns: ["table_2_id", "table_3_id", "t1_col_intval", "t1_col_doubleval", "t1_col_strval_1", "t1_col_strval_2"])
		
		for i in 0..<insertIds_2.count {
			
			insertEntity_1_1.setParam(intParam: Int(insertIds_2[i]))
			insertEntity_1_1.setParam(intParam: Int(insertIds_3[i]))
			insertEntity_1_1.setParam(intParam: i)
			let doubleVal = 0.5 + Double(i)
			insertEntity_1_1.setParam(doubleParam: doubleVal)
			insertEntity_1_1.setParam(dateParam: Date())
			insertEntity_1_1.setParam(strParam: "Str \(i)")
		}
		
		do {
			
			let query = try insertEntity_1_1.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
	}
	
	if(continueToNextTest) {
		
		var insertEntity_2_1 = IOSQLiteEntity(tableName: "test_table_1")
		insertEntity_2_1.addInsert(columns: ["table_2_id", "table_3_id", "t1_col_intval", "t1_col_doubleval", "t1_col_strval_1"])
		
		for i in 0..<insertIds_2.count {
			
			insertEntity_2_1.setParam(intParam: Int(insertIds_2[i]))
			insertEntity_2_1.setParam(intParam: Int(insertIds_3[i]))
			insertEntity_2_1.setParam(intParam: i)
			insertEntity_2_1.setParam(ioSQLiteParam: IOSQLiteParam())
			insertEntity_2_1.setParam(dateParam: Date())
		}
		
		do {
			
			let query = try insertEntity_2_1.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
	}
	
	if(continueToNextTest) {
		
		var insertEntity_3_1 = IOSQLiteEntity(tableName: "test_table_1")
		insertEntity_3_1.addInsert(columns: ["table_2_id", "table_3_id", "t1_col_intval", "t1_col_doubleval", "t1_col_strval_1", "t1_col_strval_2"])
		
		insertEntity_3_1.setParam(intParam: Int(insertIds_2[0]))
		insertEntity_3_1.setParam(intParam: Int(insertIds_3[0]))
		insertEntity_3_1.setParam(intParam: 3)
		insertEntity_3_1.setParam(doubleParam: 3.7)
		insertEntity_3_1.setParam(dateParam: Date())
		insertEntity_3_1.setParam(strParam: "Str 3")
		
		do {
			
			let query = try insertEntity_3_1.getQuery()
			if(testType.verbose) {
				
				print("Executing query \(query) \n")
			}
			try sqlite.query(queryString: query)
			
		} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
			
		} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
			
			print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
			continueToNextTest = false
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			
			print("An error occured!")
		}
	}
	
	return continueToNextTest
}
