//
//  SelectTest8.swift
//  IOSQLite
//
//  Created by ilker özcan on 11/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

/*
Select columns, count from table1 left join table 2 left join table 3 where >= group by having count() order by
*/

func SelectTest8(sqlite: IOSQLite, testType: TestType) -> Bool {
	
	var continueToNextTest = true
	
	let expectedData_1 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "1"),
		IOUnitTestExpected(columnNumber: 1, columnData: "3"),
		IOUnitTestExpected(columnNumber: 2, columnData: "1"),
		IOUnitTestExpected(columnNumber: 3, columnData: "31"),
		]
	
	let expectedData_2 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "2"),
		IOUnitTestExpected(columnNumber: 1, columnData: "1"),
		IOUnitTestExpected(columnNumber: 2, columnData: "2"),
		IOUnitTestExpected(columnNumber: 3, columnData: "32"),
		]
	
	let expectedData_3 = [
		
		IOUnitTestExpected(columnNumber: 0, columnData: "2"),
		IOUnitTestExpected(columnNumber: 1, columnData: "2"),
		IOUnitTestExpected(columnNumber: 2, columnData: "3"),
		IOUnitTestExpected(columnNumber: 3, columnData: "33"),
		]
	
	var selectEntity_8 = IOSQLiteEntity(tableName: "test_table_1")
	
	var countSelect = IOSQLiteSelect(tableName: "test_table_1", columnName: "COUNT(*)", isDistinct: false)
	countSelect.alias = "count"
	
	selectEntity_8.addSelect(select: countSelect)
	selectEntity_8.addSelect(singleColumn: "t1_col_intval")
	selectEntity_8.addSelect(select: IOSQLiteSelect(tableName: "test_table_2", columnName: "t2_col_intval", isDistinct: false))
	selectEntity_8.addSelect(select: IOSQLiteSelect(tableName: "test_table_3", columnName: "t3_col_intval", isDistinct: false))
	
	
	selectEntity_8.addJoin(leftJoin: "test_table_2", withTable: "test_table_1", column1: "id", column2: "table_2_id")
	selectEntity_8.addJoin(join: IOSQLiteJoin(tableName: "test_table_3", withTable: "test_table_1", column1: "id", column2: "table_3_id", joinType: IOSQLiteJoin.JOIN_TYPES.LEFT))
	
	
	selectEntity_8.addWhere(withTypeOtherTable: IOSQLiteWhere(tableName: "test_table_1", columnName: "t1_col_intval", comparsionType: IOSQLiteWhere.COMPARSION_TYPES.GREATER_EQUAL_THAN, whereType: IOSQLiteWhere.WHERE_TYPES.AND, paramCount: 1))
	selectEntity_8.setParam(intParam: 1)
	
	selectEntity_8.addGroupBy(groupColumnName: "test_table_1.t1_col_intval")
	selectEntity_8.addGroupBy(groupColumnName: "test_table_2.t2_col_intval")
	selectEntity_8.addGroupBy(groupColumnName: "test_table_3.t3_col_intval")
	
	selectEntity_8.addHavingClause(havingClause: IOSQLiteWhere(tableName: "test_table_1", columnName: "COUNT(*)", comparsionType: IOSQLiteWhere.COMPARSION_TYPES.GREATER_THAN, whereType: IOSQLiteWhere.WHERE_TYPES.AND, paramCount: 1))
	selectEntity_8.setParam(intParam: 0)
	
	selectEntity_8.addOrder(orderByAsc: "COUNT(*)")
	
	do {
		let query = try selectEntity_8.getQuery()
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
			print("Select test 8 [OK]!")
		}else{
			continueToNextTest = false
			print("Select test 8 [FAIL]!")
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
