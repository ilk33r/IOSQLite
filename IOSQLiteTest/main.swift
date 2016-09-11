//
//  main.swift
//  IOSQLiteTest
//
//  Created by ilker özcan on 08/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

struct TestType {
	
	let verbose: Bool
	init(verboseTest: Bool) {
		
		self.verbose = verboseTest
	}
}

let currentTestType: TestType
let args = ProcessInfo.processInfo.arguments

if(args.count < 2) {
	
	print("Usage \nIOSQLiteTest [Database Path]\n")
	exit(1)
	
}else{
	
	if(args.count > 2 && args[2] == "--verbose") {
		
		currentTestType = TestType(verboseTest: true)
	}else{
		currentTestType = TestType(verboseTest: false)
	}
	
	try? FileManager.default.removeItem(atPath: "/tmp/TestDatabase.db")
	
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
			
			if(currentTestType.verbose) {
				
				resultPrinter.printResult()
			}
			
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
	
	if(continueToNextTest) {
		continueToNextTest = insertTest(sqlite: sqlite, testType: currentTestType)
	}
	
	
	if(continueToNextTest) {
		
		print("Insert test [OK]!")
		
		/*
		Select columns from table
		*/
		continueToNextTest = SelectTest1(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		/*
		Select columns, COUNT from table Where =
		*/
		continueToNextTest = SelectTest2(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		/*
		Select columns from table Where Like and Between
		*/
		continueToNextTest = SelectTest3(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		/*
		Select columns from table Where != and <
		*/
		continueToNextTest = SelectTest4(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		/*
		Select columns from table1 left join table 2 LIMIT x OFFSET y
		*/
		continueToNextTest = SelectTest5(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		/*
		Select columns from table1 left join table 2 inner join table 3 where is not null or oqual
		*/
		continueToNextTest = SelectTest6(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		/*
		Select columns from table1 left join table 2 left join table 3 where in order by
		*/
		continueToNextTest = SelectTest7(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		/*
		Select columns, count from table1 left join table 2 left join table 3 where >= group by having count() order by
		*/
		continueToNextTest = SelectTest8(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		continueToNextTest = UpdateTest(sqlite: sqlite, testType: currentTestType)
	}
	
	if(continueToNextTest) {
		
		continueToNextTest = DeleteTest(sqlite: sqlite, testType: currentTestType)
	}
	
	sqlite.closeConnection()
	
	if(!continueToNextTest) {
	
		print("Warning! Test FAILED!")
		exit(1)
	}else{
		print("Test success!")
		exit(0)
	}
}
