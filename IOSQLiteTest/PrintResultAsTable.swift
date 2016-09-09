//
//  PrintResultAsTable.swift
//  IOSQLite
//
//  Created by ilker özcan on 09/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import IOSQLite

final class PrintResultAsTable {
	
	private var result: IOSQLiteResult
	let bashSize = 80
	var colSize = 0
	
	init(resultData: IOSQLiteResult) {
		
		self.result = resultData
	}
	
	func printResult() {
		
		self.printHeader()
		colSize = self.bashSize / result.columnCount
		printTableStart()
		printLine()
		printRows()
		printLine()
		print("\n")
	}
	
	private func printHeader() {
		
		print("\nTable List Result\n   Column Count: \(self.result.columnCount)\n   Row Count: \(self.result.rowCount)\n   Query Id: \(self.result.queryId)\n")
	}
	
	private func printTableStart() {
		
		for i in 0..<self.result.columnCount {
			
			do {
				
				let colName = try self.result.getColumnName(columnIdx: i)
				printRow(rowString: colName)
				
			} catch IOSQLiteError.SQLiteInvalidColumnIndexError(let err) {
				
				print("ERROR! SQLiteInvalidColumnIndexError \n\(err)\n")
				break
			} catch {
				print("ERROR! an error occured\n")
				break
			}
		}
	}
	
	private func printRows() {
		
		for i in 0..<self.result.rowCount {
			
			let rowData = self.result[i]
			for j in 0..<self.result.columnCount {
				
				printRow(rowString: rowData![j])
			}
		}
	}
	
	private func printRow(rowString: String) {
		
		let rowStr = "|\(rowString)"
		let rowStrLen = rowStr.characters.count
		let charLeft = colSize - rowStrLen
		
		if (charLeft > 0) {
			
			let colSpaceStr = String(repeating: " ", count: charLeft)
			print("\(rowStr)\(colSpaceStr)")
			
		}else if (charLeft == 0) {
			
			print("\(rowStr)")
			
		}else{
			
			let strStartIdx = rowStr.startIndex
			let _startIdx = rowStr.index(strStartIdx, offsetBy: 0)
			let _endIdx = rowStr.index(strStartIdx, offsetBy: colSize)
			let colRange = Range<String.Index>(_startIdx..<_endIdx)
			let colTrimmedStr = rowStr.substring(with: colRange)
			print("\(colTrimmedStr)")
		}
	}
	
	private func printLine() {
		
		let lineStr = String(repeating: "-", count: self.colSize - 2)
		print("\n\(lineStr)\n")
	}
}
