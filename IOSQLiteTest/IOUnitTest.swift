//
//  IOUnitTest.swift
//  IOSQLite
//
//  Created by ilker özcan on 09/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

struct IOUnitTestExpected {
	
	let columnNumber: Int
	let columnData: String
	
	init(columnNumber: Int, columnData: String) {
		
		self.columnNumber = columnNumber
		self.columnData = columnData
	}
}

class IOUnitTest {
	
	private var result: IOSQLiteResult
	private var ecpectedData: [ [IOUnitTestExpected] ]
	
	init(result: IOSQLiteResult, ecpectedData: [ [IOUnitTestExpected] ]) {
		
		self.result = result
		self.ecpectedData = ecpectedData
		
	}
	
	func test() -> Bool {
		
		if(result.rowCount != ecpectedData.count) {
			return false
		}
		
		var testResult = true
		
		for i in 0..<result.rowCount {
			
			let rowData = result[i]
			
			if(result.columnCount != ecpectedData[i].count) {
				
				testResult = false
				break
			}

			for j in 0..<result.columnCount {
				
				if(rowData![j] != ecpectedData[i][j].columnData) {
					
					testResult = false
					break
				}
			}
			
			if(!testResult) {
				break
			}
		}
		
		return testResult
	}
}
