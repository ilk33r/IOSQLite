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
	private var selectColumns: [IOSQLiteSelect]
	private var whereQueries: [IOSQLiteWhere]
	private var params: [IOSQLiteParam]
	private var orders: [IOSQLiteOrder]
	private var groupBy: [String]
	private var havingClause: [IOSQLiteWhere]
	private var joins: [IOSQLiteJoin]
	private var insertColumns: [String]
	private var updateColumns: [String]
	
	private var _maxRows = -1
	private var _startRow = -1
	
	var maxRows: Int {
		
		set {
			self._maxRows = newValue
		}
		
		get {
			return self._maxRows
		}
	}
	
	var startRow: Int {
		
		set {
			self._startRow = newValue
		}
		
		get {
			return self._startRow
		}
	}
	
	private var currentQueryType: QUERY_TYPE
	private var currentParamIdx = 0
	private var lastException: Error?
	
	private let SqliteDefaultFunctions = [
		"COUNT",
		"MAX",
		"MIN",
		"AVG",
		"SUM",
		"RANDOM",
		"ABS",
		"UPPER",
		"LOWER",
		"LENGTH"
	]
	
	init(tableName: String) {
		
		self.tableName = tableName
		self.selectColumns = [IOSQLiteSelect]()
		self.whereQueries = [IOSQLiteWhere]()
		self.params = [IOSQLiteParam]()
		self.orders = [IOSQLiteOrder]()
		self.groupBy = [String] ()
		self.havingClause = [IOSQLiteWhere]()
		self.joins = [IOSQLiteJoin]()
		self.insertColumns = [String]()
		self.updateColumns = [String]()
		self.currentQueryType = QUERY_TYPE.NONE
	}
	
	func addSelect(selectData: IOSQLiteSelect) {
		
		if(self.currentQueryType == QUERY_TYPE.NONE) {
			self.currentQueryType = QUERY_TYPE.SELECT
		}
		
		if(self.currentQueryType == QUERY_TYPE.SELECT) {
			
			self.selectColumns.append(selectData)
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use SELECT and \(self.currentQueryType.rawValue) together")
		}
	}
	
	func addWhere(whereData: IOSQLiteWhere) {
	
		if(self.currentQueryType == QUERY_TYPE.INSERT) {
	
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use WHERE and \(self.currentQueryType.rawValue) together")
		}
	
		self.whereQueries.append(whereData)
	}
	
	func setParam(param: IOSQLiteParam) {
		
		self.params.append(param)
	}
	
	func addOrder(order: IOSQLiteOrder) {
		
		if(self.currentQueryType == QUERY_TYPE.SELECT) {
			
			self.orders.append(order)
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use ORDER with \(self.currentQueryType.rawValue) query")
		}
	}
	
	func addGroupBy(groupColumn: String) {
		
		if(self.currentQueryType == QUERY_TYPE.SELECT) {
			
			self.groupBy.append(groupColumn)
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use GROUP BY with \(self.currentQueryType.rawValue) query")
		}
	}
	
	func addHavingClause(condition: IOSQLiteWhere) {
		
		if(self.currentQueryType == QUERY_TYPE.SELECT) {
			
			self.havingClause.append(condition)
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use HAVING with \(self.currentQueryType.rawValue) query")
		}
	}
	
	func addJoin(joinData: IOSQLiteJoin) {
		
		if(self.currentQueryType == QUERY_TYPE.SELECT) {
			
			self.joins.append(joinData)
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use JOIN with \(self.currentQueryType.rawValue) query")
		}
	}
	
	func delete() {
		
		if(self.currentQueryType == QUERY_TYPE.NONE) {
			self.currentQueryType = QUERY_TYPE.DELETE
		}
		
		if(self.currentQueryType != QUERY_TYPE.DELETE) {
			
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use DELETE and \(self.currentQueryType.rawValue) together")
		}
		
	}
	
	func addInsert(columnNames: [String]) {
		
		if(self.currentQueryType == QUERY_TYPE.NONE) {
			self.currentQueryType = QUERY_TYPE.INSERT
		}
		
		if(self.currentQueryType == QUERY_TYPE.INSERT) {
			
			for columnName in columnNames {
				self.insertColumns.append(columnName)
			}
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use INSERT and \(self.currentQueryType.rawValue) together")
		}
	}
	
	func addUpdate(columnNames: [String]) {
		
		if(self.currentQueryType == QUERY_TYPE.NONE) {
			self.currentQueryType = QUERY_TYPE.UPDATE
		}
		
		if(self.currentQueryType == QUERY_TYPE.UPDATE) {
			
			for columnName in columnNames {
				self.updateColumns.append(columnName)
			}
		}else{
			self.lastException = IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "You can not use UPDATE and \(self.currentQueryType.rawValue) together")
		}
	}
	
	func getQuery() throws -> String {
		
		if (self.lastException != nil) {
			
			throw self.lastException!
		}
		
		switch self.currentQueryType {
		case .SELECT:
			
			let queryStr = self.generateSelectQuery()
			if (self.lastException != nil) {
				
				throw self.lastException!
			}
			return queryStr
			
		case .DELETE:
			
			let queryStr = self.generateDeleteQuery()
			if (self.lastException != nil) {
				
				throw self.lastException!
			}
			return queryStr
			
		case .INSERT:
			
			let queryStr = self.generateInsertQuery()
			if (self.lastException != nil) {
				
				throw self.lastException!
			}
			return queryStr
			
		case .UPDATE:
			
			let queryStr = self.generateUpdateQuery()
			if (self.lastException != nil) {
				
				throw self.lastException!
			}
			return queryStr
			
		default:
			throw IOSQLiteError.SQLiteActiveRecordQueryTypeError(err: "Invalid query")
		}
	}
	
	private func generateSelectQuery() -> String {
		
		var queryString = "SELECT"
		
		var columnLoopIdx = 0
		for selectColumn in self.selectColumns {
			
			if(columnLoopIdx > 0) {
				
				queryString += ","
			}
			
			if(selectColumn.isDistinct) {
				
				queryString += " DISTINCT("
			}
			
			if(self.isSQLiteFunc(columnName: selectColumn.columnName)) {
				
				queryString += " \(selectColumn.columnName)"
			}else{
				
				queryString += " \(selectColumn.tableName).\(selectColumn.columnName)"
			}
			
			if(selectColumn.isDistinct) {
				
				queryString += " )"
			}
			
			if let columnAlias = selectColumn.alias {
				
				queryString += " AS \(columnAlias)"
			}
			
			columnLoopIdx += 1
		}
		
		queryString += " FROM \(self.tableName)"
		
		
		for joinData in self.joins {
			
			queryString += " \(joinData.joinType.rawValue) \(joinData.tableName) ON \(joinData.tableName).\(joinData.expressionColumn_1) = \(joinData.expressionTable).\(joinData.expressionColumn_2)"
		}
		
		if(self.lastException == nil && self.whereQueries.count > 0) {
			
			queryString += " WHERE \(self.getWhereString())"
			
		}else if(self.lastException != nil) {
		
			return queryString
		}
		
		if let groupByString = self.getGroupByString() {
			
			queryString += " GROUP BY \(groupByString)"
		}
		
		if let havingString = self.getHavingString() {
			
			queryString += " HAVING \(havingString)"
		}
		
		if let orderString = self.getOrderString() {
			
			queryString += " ORDER BY \(orderString)"
		}
		
		if(self._maxRows != -1) {
			
			queryString += " LIMIT \(self._maxRows)"
		}
		
		if(self._startRow != -1) {
			
			queryString += " OFFSET \(self._startRow)"
		}
		
		queryString += ";"
		return queryString
	}
	
	private func getWhereString() -> String {
		
		var responseString = ""
			
		var loopIdx = 0
		for whereData in self.whereQueries {
				
			if let appendStr = getStandartWhereString(loopIdx: loopIdx, whereData: whereData) {
					
				responseString += appendStr
			}else{
				break
			}
			loopIdx += 1
		}
		
		return responseString
	}
	
	private func getStandartWhereString(loopIdx: Int, whereData: IOSQLiteWhere) -> String? {
		
		var responseString = ""
		
		if(loopIdx == 0) {
			
			if(self.isSQLiteFunc(columnName: whereData.columnName)) {
				responseString += " \(whereData.columnName) \(whereData.comparsionType.rawValue)"
			}else{
				responseString += " \(whereData.tableName).\(whereData.columnName) \(whereData.comparsionType.rawValue)"
			}
			
		}else{
			
			if(self.isSQLiteFunc(columnName: whereData.columnName)) {
				responseString += " \(whereData.whereType.rawValue) \(whereData.columnName) \(whereData.comparsionType.rawValue)"
			}else{
				responseString += " \(whereData.whereType.rawValue) \(whereData.tableName).\(whereData.columnName) \(whereData.comparsionType.rawValue)"
			}
		}
		
		if(currentParamIdx >= self.params.count) {
			
			self.lastException = IOSQLiteError.SQLiteParameterErrorError(err: "Invalid parameter count!")
			return nil
		}else{
			
			let paramCount = whereData.paramCount
			for i in 0..<paramCount {
				
				if(i == 0 && paramCount > 1 && (whereData.comparsionType == IOSQLiteWhere.COMPARSION_TYPES.IN || whereData.comparsionType == IOSQLiteWhere.COMPARSION_TYPES.NOT_IN)) {
					
					responseString += " ("
					
				}else if(i > 0) {
					
					if (whereData.comparsionType == IOSQLiteWhere.COMPARSION_TYPES.BETWEEN) {
						
						responseString += " AND "
					}else{
						
						responseString += ","
					}
					
				}
				
				let param = self.params[currentParamIdx]
				
				switch param.paramType {
				case .INT:
					responseString += " \(param.intParam!)"
					break
				case .NUMBER:
					responseString += " \(param.doubleParam!)"
					break
				case .STRING:
					responseString += " '\(param.strParam!)'"
					break
				case .DATETIME:
					responseString += " '\(param.dateStrParam!)'"
					break
				default:
					responseString += " NULL"
					break
				}
				
				currentParamIdx += 1
			}
			
			if(paramCount > 1 && (whereData.comparsionType == IOSQLiteWhere.COMPARSION_TYPES.IN || whereData.comparsionType == IOSQLiteWhere.COMPARSION_TYPES.NOT_IN)) {
				
				responseString += " )"
			}
		}
		
		return responseString
	}
	
	private func getGroupByString() -> String? {
		
		if(self.groupBy.count > 0) {
			
			var responseStr = ""
			var loopIdx = 0
			
			for groupByData in self.groupBy {
				
				if(loopIdx > 0) {
					responseStr += ","
				}
				
				responseStr += " \(groupByData)"
				
				loopIdx += 1
			}
			
			return responseStr
			
		}else{
		
			return nil
		}
	}
	
	private func getHavingString() -> String? {
		
		if(self.havingClause.count > 0) {
			
			var responseString = ""
		
			var loopIdx = 0
			for whereData in self.havingClause {
			
				if let appendStr = getStandartWhereString(loopIdx: loopIdx, whereData: whereData) {
			
					responseString += appendStr
				}else{
					break
				}
				loopIdx += 1
			}
		
			return responseString
		}else{
			return nil
		}
	}
	
	private func getOrderString() -> String? {
		
		if(self.orders.count > 0) {
			
			var responseString = ""
			
			var loopIdx = 0
			var lastOrder = self.orders[0].currentOrder
			
			for orderData in self.orders {
				
				if(loopIdx > 0) {
					responseString += ","
				}
				
				if(lastOrder != orderData.currentOrder) {
					responseString += " \(lastOrder.rawValue)"
				}
				
				if(self.isSQLiteFunc(columnName: orderData.columnName)) {
					responseString += "   \(orderData.columnName)"
				}else{
					responseString += " \(orderData.tableName).\(orderData.columnName)"
				}
				lastOrder = orderData.currentOrder
				
				loopIdx += 1
			}
			responseString += " \(lastOrder.rawValue)"
			
			return responseString
		}else{
			return nil
		}
	}
	
	private func generateDeleteQuery() -> String {
		
		var queryString = "DELETE FROM \(self.tableName)"
		
		if(self.lastException == nil) {
			
			queryString += " WHERE \(self.getWhereString())"
			
		}else{
			return queryString
		}
		
		return queryString
	}
	
	private func generateInsertQuery() -> String {
		
		var queryString = "INSERT INTO \(self.tableName)"
		
		var columnLoopIdx = 0
		for insertColumn in self.insertColumns {
			
			if(columnLoopIdx > 0) {
				
				queryString += ","
			}else{
				queryString += " ("
			}
			
			queryString += " \"\(insertColumn)\""
			columnLoopIdx += 1
		}
		
		let paramCount = self.params.count
		if(paramCount % self.insertColumns.count != 0) {
			
			self.lastException = IOSQLiteError.SQLiteParameterErrorError(err: "Invalid parameter count!")
			return queryString
		}
		
		queryString += " ) VALUES "
		
		var currentParamIdx = 0
		for i in 0..<paramCount {
			
			if(currentParamIdx == 0 && i == 0) {
				
				currentParamIdx += 1
				queryString += " ("
			
			}else if(i > 0 && currentParamIdx > 0 && currentParamIdx % self.insertColumns.count == 0 && i < (paramCount - 1)) {
				
				queryString += " ), ("
				currentParamIdx = 1
				
			}else{
				
				currentParamIdx += 1
				queryString += ","
			}
			
			let param = self.params[i]
			
			switch param.paramType {
			case .INT:
				queryString += " \(param.intParam!)"
				break
			case .NUMBER:
				queryString += " \(param.doubleParam!)"
				break
			case .STRING:
				queryString += " '\(param.strParam!)'"
				break
			case .DATETIME:
				queryString += " '\(param.dateStrParam!)'"
				break
			default:
				queryString += " NULL"
				break
			}
			
		}
		
		queryString += " );"
		
		return queryString
	}
	
	private func generateUpdateQuery() -> String {
		
		var queryString = "UPDATE \(self.tableName) SET"
		
		self.currentParamIdx = 0
		let paramCount = self.params.count
		if(paramCount < self.updateColumns.count) {
			
			self.lastException = IOSQLiteError.SQLiteParameterErrorError(err: "Invalid parameter count!")
			return queryString
		}
		
		
		for updateColumn in self.updateColumns {
			
			if(self.currentParamIdx > 0) {
				
				queryString += ","
			}
			
			queryString += " \"\(updateColumn)\" = "
			
			let param = self.params[currentParamIdx]
			
			switch param.paramType {
			case .INT:
				queryString += " \(param.intParam!)"
				break
			case .NUMBER:
				queryString += " \(param.doubleParam!)"
				break
			case .STRING:
				queryString += " '\(param.strParam!)'"
				break
			case .DATETIME:
				queryString += " '\(param.dateStrParam!)'"
				break
			default:
				queryString += " NULL"
				break
			}
			
			self.currentParamIdx += 1
		}
		
		queryString += " WHERE \(self.getWhereString());"
		
		return queryString
	}
	
	private func isSQLiteFunc(columnName: String) -> Bool {
	
		let columnNameLen = columnName.characters.count
		var statusRetval = false
		
		for sqliteFunction in self.SqliteDefaultFunctions {
			
			let currentFuncLen = sqliteFunction.characters.count
			
			if(columnNameLen < currentFuncLen) {
				
				continue
			}else{
				
				let columnNameStartIdx = columnName.startIndex
				let _start = columnName.index(columnNameStartIdx, offsetBy: 0)
				let _end = columnName.index(columnNameStartIdx, offsetBy: currentFuncLen)
				let columnNameRange = Range<String.Index>(_start..<_end)
				let columnNameStripped = columnName.substring(with: columnNameRange)
				
				if(columnNameStripped == sqliteFunction) {
					
					statusRetval = true
					break
				}
			}
		}
		
		return statusRetval
	}
}
