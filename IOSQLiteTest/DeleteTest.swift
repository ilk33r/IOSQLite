//
//  DeleteTest.swift
//  IOSQLite
//
//  Created by ilker özcan on 11/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

func DeleteTest(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	
	var deleteEntity = IOSQLiteEntity(tableName: "test_table_1")
	
	deleteEntity.delete()
	deleteEntity.addWhere(withColumn: "id")
	deleteEntity.setParam(intParam: 7)
	
	do {
		let query = try deleteEntity.getQuery()
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
	} catch IOSQLiteError.SQLiteResultDoesNotExists(let err) {
		
		print("ERROR! SQLiteResultDoesNotExists: \n\(err)\n")
		continueToNextTest = false
	} catch {
		continueToNextTest = false
		print("An error occured")
	}
	
	var deleteEntitySelect = IOSQLiteEntity(tableName: "test_table_1")
	deleteEntitySelect.addSelect(singleColumn: "*")
	
	deleteEntitySelect.addWhere(withColumn: "id")
	deleteEntitySelect.setParam(intParam: 7)
	
	do {
		let query = try deleteEntitySelect.getQuery()
		if(testType.verbose) {
			
			print("Executing query \(query) \n")
		}
		try sqlite.query(queryString: query)
		let queryResult = try sqlite.getResults()
		
		if(testType.verbose) {
			let resultPrinter = PrintResultAsTable(resultData: queryResult)
			resultPrinter.printResult()
		}
		
	} catch IOSQLiteError.SQLiteActiveRecordQueryTypeError(let err) {
		
		print("ERROR! SQLiteFreeError: \n\(err)\n")
		continueToNextTest = false
		
	} catch IOSQLiteError.SQLiteParameterErrorError(let err) {
		
		print("ERROR! SQLiteParameterErrorError: \n\(err)\n")
		continueToNextTest = false
	} catch IOSQLiteError.SQLiteExecuteError(let err) {
		
		print("ERROR! SQLiteExecuteError: \n\(err)\n")
		continueToNextTest = false
	} catch IOSQLiteError.SQLiteResultDoesNotExists {
		
		print("Delete test [OK]!")
		continueToNextTest = true

	} catch {
		continueToNextTest = false
		print("An error occured")
	}
	
	if(!continueToNextTest) {
		
		do {
			try sqlite.freeResult()
			
		} catch IOSQLiteError.SQLiteFreeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			print("An error occured")
		}
		
		print("Delete test [FAIL]!")
	}
	
	return continueToNextTest
}
