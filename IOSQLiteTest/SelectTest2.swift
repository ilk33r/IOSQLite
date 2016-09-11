//
//  SelectTest2.swift
//  IOSQLite
//
//  Created by ilker özcan on 09/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

/*
Select columns, COUNT from table Where =
*/

func SelectTest2(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true

	let expectedData_1 = [IOUnitTestExpected(columnNumber: 0, columnData: "2"), IOUnitTestExpected(columnNumber: 1, columnData: "32"), IOUnitTestExpected(columnNumber: 2, columnData: "1")]
	
	var selectEntity_2 = IOSQLiteEntity(tableName: "test_table_3")
	selectEntity_2.addSelect(singleColumn: "id")
	selectEntity_2.addSelect(singleColumn: "t3_col_intval")
	var count_1 = IOSQLiteSelect(tableName: "test_table_3", columnName: "COUNT(id)", isDistinct: false)
	count_1.alias = "c1"
	selectEntity_2.addSelect(select: count_1)
	selectEntity_2.addWhere(withColumn: "id")
	selectEntity_2.setParam(intParam: 2)
	
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
		
		let unitTest = IOUnitTest(result: queryResult, ecpectedData: [ expectedData_1 ])
		
		if(unitTest.test()) {
			print("Select test 2 [OK]!")
		}else{
			continueToNextTest = false
			print("Select test 2 [FAIL]!")
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
