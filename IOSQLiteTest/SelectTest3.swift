//
//  SelectTest3.swift
//  IOSQLite
//
//  Created by ilker özcan on 09/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

/*
Select columns from table Where Like and Between
*/

func SelectTest3(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	
	let expectedData_1 = [
		IOUnitTestExpected(columnNumber: 0, columnData: "1"),
		IOUnitTestExpected(columnNumber: 1, columnData: "31"),
		IOUnitTestExpected(columnNumber: 2, columnData: "Str 31")
	]
	
	let expectedData_2 = [
		IOUnitTestExpected(columnNumber: 0, columnData: "2"),
		IOUnitTestExpected(columnNumber: 1, columnData: "32"),
		IOUnitTestExpected(columnNumber: 2, columnData: "Str 32")
	]
	
	let expectedData_3 = [
		IOUnitTestExpected(columnNumber: 0, columnData: "3"),
		IOUnitTestExpected(columnNumber: 1, columnData: "33"),
		IOUnitTestExpected(columnNumber: 2, columnData: "Str 33")
	]
	
	var selectEntity_2 = IOSQLiteEntity(tableName: "test_table_3")
	selectEntity_2.addSelect(singleColumn: "id")
	selectEntity_2.addSelect(singleColumn: "t3_col_intval")
	selectEntity_2.addSelect(singleColumn: "t3_col_strval_1")
	selectEntity_2.addWhere(withType: "t3_col_strval_1", comparsionType: IOSQLiteWhere.COMPARSION_TYPES.LIKE, whereType: IOSQLiteWhere.WHERE_TYPES.AND)
	selectEntity_2.addWhere(withType: "id", comparsionType: IOSQLiteWhere.COMPARSION_TYPES.BETWEEN, whereType: IOSQLiteWhere.WHERE_TYPES.AND)
	selectEntity_2.setParam(strParam: "Str%")
	selectEntity_2.setParam(intParam: 1)
	selectEntity_2.setParam(intParam: 3)
	
	do {
		let query = try selectEntity_2.getQuery()
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
			print("Select test 3 [OK]!")
		}else{
			continueToNextTest = false
			print("Select test 3 [FAIL]!")
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
