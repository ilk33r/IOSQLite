//
//  SelectTest4.swift
//  IOSQLite
//
//  Created by ilker özcan on 11/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

/*
Select columns from table Where != and <
*/

func SelectTest4(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	
	let expectedData_1 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "1"),
		IOUnitTestExpected(columnNumber: 1, columnData: "31"),
		IOUnitTestExpected(columnNumber: 2, columnData: "Str 31")
	]
	
	var selectEntity_4 = IOSQLiteEntity(tableName: "test_table_3")
	selectEntity_4.addSelect(singleColumn: "id")
	selectEntity_4.addSelect(singleColumn: "t3_col_intval")
	selectEntity_4.addSelect(singleColumn: "t3_col_strval_1")
	
	selectEntity_4.addWhere(withType: "id", comparsionType: IOSQLiteWhere.COMPARSION_TYPES.NOT_EQUAL, whereType: IOSQLiteWhere.WHERE_TYPES.AND)
	selectEntity_4.addWhere(withType: "t3_col_intval", comparsionType: IOSQLiteWhere.COMPARSION_TYPES.LESS_THAN, whereType: IOSQLiteWhere.WHERE_TYPES.AND)
	selectEntity_4.setParam(intParam: 2)
	selectEntity_4.setParam(intParam: 32)
	
	do {
		let query = try selectEntity_4.getQuery()
		if(testType.verbose) {
			
			print("Executing query \(query) \n")
		}
		try sqlite.query(queryString: query)
		let queryResult = try sqlite.getResults()
		
		if(testType.verbose) {
			let resultPrinter = PrintResultAsTable(resultData: queryResult)
			resultPrinter.printResult()
		}
		
		let unitTest = IOUnitTest(result: queryResult, ecpectedData: [ expectedData_1 ])
		
		if(unitTest.test()) {
			print("Select test 4 [OK]!")
		}else{
			continueToNextTest = false
			print("Select test 4 [FAIL]!")
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
