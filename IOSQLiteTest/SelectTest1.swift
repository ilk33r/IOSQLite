//
//  SelectTest.swift
//  IOSQLite
//
//  Created by ilker özcan on 09/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

/*
	Select columns from table
*/

func SelectTest1(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	
	let expectedData_1 = [IOUnitTestExpected(columnNumber: 0, columnData: "1"), IOUnitTestExpected(columnNumber: 1, columnData: "1"), IOUnitTestExpected(columnNumber: 2, columnData: "Str 1")]
	let expectedData_2 = [IOUnitTestExpected(columnNumber: 0, columnData: "2"), IOUnitTestExpected(columnNumber: 1, columnData: "2"), IOUnitTestExpected(columnNumber: 2, columnData: "Str 2")]
	let expectedData_3 = [IOUnitTestExpected(columnNumber: 0, columnData: "3"), IOUnitTestExpected(columnNumber: 1, columnData: "3"), IOUnitTestExpected(columnNumber: 2, columnData: "Str 3")]
	
	var selectEntity_1 = IOSQLiteEntity(tableName: "test_table_2")
	selectEntity_1.addSelect(singleColumn: "id")
	selectEntity_1.addSelect(singleColumn: "t2_col_intval")
	selectEntity_1.addSelect(singleColumn: "t2_col_strval_1")
	
	do {
		let query = try selectEntity_1.getQuery()
		
		if(testType.verbose) {
			
			print("Executing query \(query) \n")
		}
		try sqlite.query(queryString: query)
		
		let queryResult = try sqlite.getResults()
		
		if(testType.verbose) {
			let resultPrinter = PrintResultAsTable(resultData: queryResult)
			resultPrinter.printResult()
		}
		
		let unitTest = IOUnitTest(result: queryResult, ecpectedData: [ expectedData_1, expectedData_2, expectedData_3 ])
		
		if(unitTest.test()) {
			print("Select test 1 [OK]!")
		}else{
			continueToNextTest = false
			print("Select test 1 [FAIL]!")
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
	} catch IOSQLiteError.SQLiteResultDoesNotExists(let err) {
		
		print("ERROR! SQLiteResultDoesNotExists: \n\(err)\n")
		continueToNextTest = false
	} catch {
		print("An error occured")
	}
	
	if(continueToNextTest) {
		do {
			try sqlite.freeResult()
			
		} catch IOSQLiteError.SQLiteFreeError(let err) {
			
			print("ERROR! SQLiteFreeError: \n\(err)\n")
			continueToNextTest = false
		} catch {
			print("An error occured")
		}
	}
	
	return continueToNextTest
}
