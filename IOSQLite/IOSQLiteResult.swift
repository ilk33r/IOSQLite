//
//  IOSQLiteResult.swift
//  IOSQLite
//
//  Created by ilker özcan on 08/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public struct IOSQLiteResult {

	private var _colCount: Int
	private var _colNames: [String]
	private var _allData: [ [String] ]
	private var _rowCount: Int
	private var _queryId: Int
	
	public var columnCount: Int {
		
		get {
			return _colCount
		}
	}
	
	public var rowCount: Int {
		
		get {
			return _rowCount
		}
	}
	
	public var queryId: Int {
		
		get {
			return _queryId
		}
	}
	
	public init(queryId: Int, columnCount: Int, columnNames: [String], columnData: [String]?) {
		
		self._queryId = queryId
		self._colCount = columnCount
		self._colNames = columnNames
		self._allData = [ [String] ]()
		self._rowCount = 0
		
		guard columnData != nil else {
			return
		}
		
		self._allData.append(columnData!)
		self._rowCount += 1
	}
	
	public func getColumnName(columnIdx: Int) throws -> String {
		
		if(columnIdx < self._colCount) {
			return self._colNames[columnIdx]
		}else{
			throw IOSQLiteError.SQLiteInvalidColumnIndexError(err: "Column index \(columnIdx) must be smaller than \(self._colCount)")
		}
	}
	
	public mutating func appendRow(columnData: [String]) {
		
		self._allData.append(columnData)
		self._rowCount += 1
	}
	
	public subscript(index: Int) -> [String]? {
		
		if(index < self._rowCount) {
			
			return self._allData[index]
		}else{
			
			return nil
		}
	}
	
	public func isNull(rowIdx: Int, columnIdx: Int) -> Bool {
		
		let rowData = self._allData[rowIdx]
		let currentColumnData = rowData[columnIdx]
		
		if(currentColumnData == "NULL") {
			return true
		}else{
			return false
		}
	}
	
	public func getDateVal(rowIdx: Int, columnIdx: Int) -> Date {
		
		let rowData = self._allData[rowIdx]
		let currentColumnData = rowData[columnIdx]
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
		if let dateValue = dateFormatter.date(from: currentColumnData) {
			
			return dateValue
		}else{
			
			return Date()
		}
	}
}

internal func SqlExecCallback(queryId: UnsafeMutableRawPointer?, argc: Int32, argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?, azColName: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?) -> Int32 {
	
	let currentQueryId: Int
	if let currentQueryIdPTR = queryId {
		
		currentQueryId = currentQueryIdPTR.load(as: Int.self)
	}else{
		currentQueryId = -1
	}
	
	IOSQLiteResultHandler.sharedInstance.setData(queryId: currentQueryId, argc: argc, argv: argv, azColName: azColName)
	
	//queryId!.deallocate(bytes: MemoryLayout<Int>.size, alignedTo: 0)
	
	if(argv != nil) {
		
		for i in 0..<Int(argc) {
		
			if let columnValue = argv![i] {
				
				columnValue.deinitialize()
			}
		
		}
		
		argv!.deinitialize()
	}
	
	if(azColName != nil) {
		
		for j in 0..<Int(argc) {
			
			if let columnName = azColName![j] {
				
				columnName.deinitialize()
			}
		}
		
		azColName!.deinitialize()
	}
	
	return 0
}

internal class IOSQLiteResultHandler {
	
	private var currentResult: IOSQLiteResult?
	private var argc: Int32 = 0
	private var argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?
	private var azColName: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?
	
	private var hasResultError = false
	
	class var sharedInstance: IOSQLiteResultHandler {
		
		struct Singleton {
			static let instance = IOSQLiteResultHandler()
		}
		
		return Singleton.instance
	}
	
	public func setData(queryId: Int, argc: Int32, argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?, azColName: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?) {
		
		if(self.currentResult != nil && self.currentResult!.queryId != queryId) {
			
			hasResultError = true
			return
		}
		
		hasResultError = false
		self.argc = argc
		self.argv = argv
		self.azColName = azColName
		self.generateResult(queryId: queryId)
	}
	
	public func freeLastResult() throws {
		
		guard self.currentResult != nil else {
			
			throw IOSQLiteError.SQLiteFreeError(err: "Result does not exists.")
		}
		
		currentResult = nil
	}
	
	public func safeFree() {
		
		do {
			try self.freeLastResult()
		} catch _ {
			
		}
	}
	
	public func getResults() throws -> IOSQLiteResult {
		
		guard self.currentResult != nil else {
			
			throw IOSQLiteError.SQLiteResultDoesNotExists(err: "Result does not exists.")
		}
		
		return self.currentResult!
	}
	
	private func generateResult(queryId: Int) {
		
		if(self.currentResult == nil) {
			
			var columnNames = [String]()
			var columnDatas = [String]()
			for i in 0..<self.argc {
				
				if let colNameArg = self.azColName {
					
					let columnNameString: String
					if let currentColumnName = colNameArg[Int(i)] {
						
						columnNameString = String(cString: currentColumnName)
					}else{
						columnNameString = "NULL"
					}
					
					columnNames.append(columnNameString)
				}
				
				if let colValueArg = self.argv {
					
					let columnValueString: String
					if let currentColumnValue = colValueArg[Int(i)] {
						
						columnValueString = String(cString: currentColumnValue)
					}else{
						columnValueString = "NULL"
					}
					
					columnDatas.append(columnValueString)
				}
			}
			
			self.currentResult = IOSQLiteResult(queryId: queryId, columnCount: Int(self.argc), columnNames: columnNames, columnData: columnDatas)
		}else{
			
			var columnDatas = [String]()
			for i in 0..<self.argc {
				
				if let colValueArg = self.argv {
					
					let columnValueString: String
					if let currentColumnValue = colValueArg[Int(i)] {
						
						columnValueString = String(cString: currentColumnValue)
					}else{
						columnValueString = "NULL"
					}
					
					columnDatas.append(columnValueString)
				}
			}
			
			self.currentResult?.appendRow(columnData: columnDatas)
		}
	}
}
