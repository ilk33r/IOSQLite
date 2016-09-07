//
//  IOSQLiteActiveRecord.swift
//  IOPaymentCalculator
//
//  Created by ilker özcan on 06/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

internal class IOSQLiteActiveRecord {
	
	private enum QUERY_TYPE: String {
		case NONE = ""
		case SELECT = "SELECT"
		case INSERT = "INSERT"
		case UPDATE = "UPDATE"
		case DELETE = "DELETE"
	}
	
	private var tableName: String
	private var selectColumns: [(String, String)]
	private var whereQueries: [IOSQLiteWhere]
	private var whereGroups: [ [Int] ]
	private var params = [(Any, PARAM_TYPES)]()
	
	private var currentQueryType: QUERY_TYPE
	private var lastException: Error?
	
	init(tableName: String) {
		
		self.tableName = tableName
		self.selectColumns = [(String, String)]()
		self.whereQueries = [IOSQLiteWhere]()
		self.whereGroups = [ [Int] ]()
		self.currentQueryType = QUERY_TYPE.NONE
	}
	
	public func addSelect(selectData: (String, String)) {
		
		if(self.currentQueryType == QUERY_TYPE.NONE) {
			self.currentQueryType = QUERY_TYPE.SELECT
		}
		
		if(self.currentQueryType == QUERY_TYPE.SELECT) {
			
			self.selectColumns.append(selectData)
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use SELECT and \(self.currentQueryType.rawValue) together")
		}
	}
	
	public func addWhere(whereData: IOSQLiteWhere) {
	
		if(self.currentQueryType == QUERY_TYPE.INSERT) {
	
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use WHERE and \(self.currentQueryType.rawValue) together")
		}
	
		self.whereQueries.append(whereData)
	}
	
	public func addWhereGroup(whereDatas: [IOSQLiteWhere]) {
		
		var currentIdx = whereQueries.count
		var groupArray = [Int]()
		
		for whereData in whereDatas {
			
			self.addWhere(whereData: whereData)
			groupArray.append(currentIdx)
			currentIdx += 1
		}
		
		whereGroups.append(groupArray)
	}
}
