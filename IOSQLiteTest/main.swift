//
//  main.swift
//  IOSQLiteTest
//
//  Created by ilker özcan on 08/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

let args = ProcessInfo.processInfo.arguments

if(args.count < 2) {
	
	print("Usage \nIOSQLiteTest [Database Path]\n")
	exit(1)
	
}else{
	
	var continueToNextTest = true
	do {
		try FileManager.default.copyItem(atPath: args[1], toPath: "/tmp/TestDatabase.db")
	} catch let error {
		print("ERROR: \(error.localizedDescription) \n")
		exit(1)
	}
	
	let sqlite: IOSQLite
	do {
		
		sqlite = try IOSQLite(databasePath: "/tmp/TestDatabase.db")
		
	} catch IOSQLiteError.SQLiteOpenError(let err) {
		
		print("ERROR! SQLiteOpenError: \n\(err)\n")
		exit(1)
	}
	
	do {
		
		try sqlite.query(queryString: createTable_query1)
	} catch IOSQLiteError.SQLiteExecuteError(let err) {
		
		print("ERROR! SQLiteExecuteError: \n\(err)\n")
		continueToNextTest = false
	}
	
	if(continueToNextTest) {
		
		do {
			
			try sqlite.query(queryString: createTable_query2)
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		}
	}
	
	if(continueToNextTest) {
		
		do {
			
			try sqlite.query(queryString: createTable_query3)
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
			
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		}
	}
	
	if(continueToNextTest) {
		
		do {
		
			try sqlite.query(queryString: listTables_query)
		} catch IOSQLiteError.SQLiteExecuteError(let err) {
		
			print("ERROR! SQLiteExecuteError: \n\(err)\n")
			continueToNextTest = false
		}
	}
	
	if(continueToNextTest) {
		
		let expectedData_1 = [IOUnitTestExpected(columnNumber: 0, columnData: "test_table_1")]
		let expectedData_2 = [IOUnitTestExpected(columnNumber: 0, columnData: "test_table_2")]
		let expectedData_3 = [IOUnitTestExpected(columnNumber: 0, columnData: "test_table_3")]
		
		do {
			let tableList = try sqlite.getResults()
			let resultPrinter = PrintResultAsTable(resultData: tableList)
			resultPrinter.printResult()
			
			let unitTest = IOUnitTest(result: tableList, ecpectedData: [ expectedData_1, expectedData_2, expectedData_3 ])
			
			if(unitTest.test()) {
				print("Create table test [OK]!")
			}else{
				continueToNextTest = false
				print("Create table test [FAIL]!")
			}

		} catch IOSQLiteError.SQLiteResultDoesNotExists(let err) {
			
			print("ERROR! SQLiteResultDoesNotExists: \n\(err)\n")
			continueToNextTest = false
		}
		
		if(continueToNextTest) {
			do {
				try sqlite.freeResult()
			
			} catch IOSQLiteError.SQLiteFreeError(let err) {
			
				print("ERROR! SQLiteFreeError: \n\(err)\n")
				continueToNextTest = false
			}
		}
	}
	
	sqlite.closeConnection()
	
	do {
		try FileManager.default.removeItem(atPath: "/tmp/TestDatabase.db")
	} catch let error {
		print("ERROR! \(error.localizedDescription) \n")
		exit(1)
	}
	
	exit(0)
}
