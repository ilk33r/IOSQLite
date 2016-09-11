//
//  SelectTest7.swift
//  IOSQLite
//
//  Created by ilker özcan on 11/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

/*
Select columns from table1 left join table 2 left join table 3 where in order by
*/

func SelectTest7(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	
	let expectedData_1 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "6"),
		IOUnitTestExpected(columnNumber: 1, columnData: "2"),
		IOUnitTestExpected(columnNumber: 2, columnData: "NULL"),
		IOUnitTestExpected(columnNumber: 3, columnData: "NULL"),
		IOUnitTestExpected(columnNumber: 4, columnData: "3"),
		IOUnitTestExpected(columnNumber: 5, columnData: "33"),
		]
	
	let expectedData_2 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "5"),
		IOUnitTestExpected(columnNumber: 1, columnData: "1"),
		IOUnitTestExpected(columnNumber: 2, columnData: "NULL"),
		IOUnitTestExpected(columnNumber: 3, columnData: "NULL"),
		IOUnitTestExpected(columnNumber: 4, columnData: "2"),
		IOUnitTestExpected(columnNumber: 5, columnData: "32"),
		]
	
	let expectedData_3 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "3"),
		IOUnitTestExpected(columnNumber: 1, columnData: "2"),
		IOUnitTestExpected(columnNumber: 2, columnData: "2.5"),
		IOUnitTestExpected(columnNumber: 3, columnData: "Str 2"),
		IOUnitTestExpected(columnNumber: 4, columnData: "3"),
		IOUnitTestExpected(columnNumber: 5, columnData: "33"),
		]
	
	let expectedData_4 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "2"),
		IOUnitTestExpected(columnNumber: 1, columnData: "1"),
		IOUnitTestExpected(columnNumber: 2, columnData: "1.5"),
		IOUnitTestExpected(columnNumber: 3, columnData: "Str 1"),
		IOUnitTestExpected(columnNumber: 4, columnData: "2"),
		IOUnitTestExpected(columnNumber: 5, columnData: "32"),
		]
	
	var selectEntity_7 = IOSQLiteEntity(tableName: "test_table_1")
	selectEntity_7.addSelect(singleColumn: "id")
	selectEntity_7.addSelect(singleColumn: "t1_col_intval")
	selectEntity_7.addSelect(singleColumn: "t1_col_doubleval")
	selectEntity_7.addSelect(singleColumn: "t1_col_strval_2")
	selectEntity_7.addSelect(select: IOSQLiteSelect(tableName: "test_table_2", columnName: "t2_col_intval", isDistinct: false))
	selectEntity_7.addSelect(select: IOSQLiteSelect(tableName: "test_table_3", columnName: "t3_col_intval", isDistinct: false))
	
	selectEntity_7.addJoin(leftJoin: "test_table_2", withTable: "test_table_1", column1: "id", column2: "table_2_id")
	selectEntity_7.addJoin(join: IOSQLiteJoin(tableName: "test_table_3", withTable: "test_table_1", column1: "id", column2: "table_3_id", joinType: IOSQLiteJoin.JOIN_TYPES.LEFT))
	
	
	selectEntity_7.addWhere(withTypeOtherTable: IOSQLiteWhere(tableName: "test_table_1", columnName: "t1_col_intval", comparsionType: IOSQLiteWhere.COMPARSION_TYPES.IN, whereType: IOSQLiteWhere.WHERE_TYPES.AND, paramCount: 2))
	
	selectEntity_7.setParam(intParam: 1)
	selectEntity_7.setParam(intParam: 2)
	selectEntity_7.addOrder(orderByDesc: "id")
	
	do {
		let query = try selectEntity_7.getQuery()
		if(testType.verbose) {
			
			print("Executing query \(query) \n")
		}
		try sqlite.query(queryString: query)
		let queryResult = try sqlite.getResults()
		
		if(testType.verbose) {
			let resultPrinter = PrintResultAsTable(resultData: queryResult)
			resultPrinter.printResult()
		}
		
		let unitTest = IOUnitTest(result: queryResult, ecpectedData: [ expectedData_1, expectedData_2, expectedData_3, expectedData_4 ])
		
		if(unitTest.test()) {
			print("Select test 7 [OK]!")
		}else{
			continueToNextTest = false
			print("Select test 7 [FAIL]!")
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
