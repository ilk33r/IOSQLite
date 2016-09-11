//
//  SelectTest5.swift
//  IOSQLite
//
//  Created by ilker özcan on 11/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

/*
Select columns from table1 left join table 2 LIMIT x OFFSET y
*/

func SelectTest5(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	
	let expectedData_1 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "2"),
		IOUnitTestExpected(columnNumber: 1, columnData: "2"),
		IOUnitTestExpected(columnNumber: 2, columnData: "1.5"),
		IOUnitTestExpected(columnNumber: 3, columnData: "Str 1"),
		IOUnitTestExpected(columnNumber: 4, columnData: "Str 2"),
	]
	
	let expectedData_2 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "3"),
		IOUnitTestExpected(columnNumber: 1, columnData: "3"),
		IOUnitTestExpected(columnNumber: 2, columnData: "2.5"),
		IOUnitTestExpected(columnNumber: 3, columnData: "Str 2"),
		IOUnitTestExpected(columnNumber: 4, columnData: "Str 3"),
		]
	
	let expectedData_3 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "4"),
		IOUnitTestExpected(columnNumber: 1, columnData: "1"),
		IOUnitTestExpected(columnNumber: 2, columnData: "NULL"),
		IOUnitTestExpected(columnNumber: 3, columnData: "NULL"),
		IOUnitTestExpected(columnNumber: 4, columnData: "Str 1"),
		]
	
	var selectEntity_5 = IOSQLiteEntity(tableName: "test_table_1")
	selectEntity_5.addSelect(singleColumn: "id")
	selectEntity_5.addSelect(singleColumn: "table_2_id")
	selectEntity_5.addSelect(singleColumn: "t1_col_doubleval")
	selectEntity_5.addSelect(singleColumn: "t1_col_strval_2")
	selectEntity_5.addSelect(select: IOSQLiteSelect(tableName: "test_table_2", columnName: "t2_col_strval_1", isDistinct: false))
	
	selectEntity_5.addJoin(leftJoin: "test_table_2", withTable: "test_table_1", column1: "id", column2: "table_2_id")
	selectEntity_5.setStartRow(startRow: 1)
	selectEntity_5.setMaxRows(maxRows: 3)
	
	do {
		let query = try selectEntity_5.getQuery()
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
			print("Select test 5 [OK]!")
		}else{
			continueToNextTest = false
			print("Select test 5 [FAIL]!")
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
