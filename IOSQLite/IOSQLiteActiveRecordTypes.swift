//
//  IOSQLiteActiveRecordTypes.swift
//  IOSQLite
//
//  Created by ilker özcan on 07/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public struct IOSQLiteSelect {

	private var _tableName: String
	private var _columnName: String
	private var _isDistinct: Bool
	private var _alias: String?
	
	public var tableName: String {
		
		get {
			return _tableName
		}
	}
	
	public var columnName: String {
		
		get {
			return _columnName
		}
	}
	
	public var isDistinct: Bool {
		
		get {
			return _isDistinct
		}
	}
	
	public var alias: String? {
		
		set {
			self._alias = newValue
		}
		
		get {
			return _alias
		}
	}
	
	public init(tableName: String, columnName: String, isDistinct: Bool) {
		
		self._tableName = tableName
		self._columnName = columnName
		self._isDistinct = isDistinct
	}
}

public struct IOSQLiteWhere {
	
	public enum WHERE_TYPES: String {
		case AND = "AND"
		case OR = "OR"
		case IN = "IN"
		case NOT_IN = "NOT IN"
		case IS = "IS"
		case IS_NOT = "IS NOT"
	}
	
	public enum COMPARSION_TYPES: String {
		
		case EQUAL = "="
		case LIKE = "LIKE"
		case NOT_EQUAL = "!="
		case EQUAL_OR_NOT = "<>"
		case GREATER_THAN = ">"
		case LESS_THAN = "<"
		case GREATER_EQUAL_THAN = ">="
		case LESS_EQUAL_THAN = "<="
		case BETWEEN = "BETWEEN"
	}

	private var _tableName: String
	private var _columnName: String
	private var _comparsionType: COMPARSION_TYPES
	private var _whereType: WHERE_TYPES
	private var _paramCount: Int
	
	public var tableName: String {
	
		get {
			return _tableName
		}
	}
	
	public var columnName: String {
		
		get {
			return _columnName
		}
	}
	
	public var comparsionType: COMPARSION_TYPES {
		
		get {
			return _comparsionType
		}
	}
	
	public var whereType: WHERE_TYPES {
		
		get {
			return _whereType
		}
	}
	
	public var paramCount: Int {
		
		get {
			return _paramCount
		}
	}
	
	public init(tableName: String, columnName: String, comparsionType: COMPARSION_TYPES, whereType: WHERE_TYPES, paramCount: Int) {
		
		self._tableName = tableName
		self._columnName = columnName
		self._comparsionType = comparsionType
		self._whereType = whereType
		self._paramCount = paramCount
	}
}

public struct IOSQLiteParam {
	
	public enum PARAM_TYPES {
		case INT
		case NUMBER
		case STRING
		case DATETIME
		case NULL
	}
	
	private var _intParam: Int?
	private var _strParam: String?
	private var _doubLeParam: Double?
	private var _dateTimeParam: Date?
	private var _currentParamType: PARAM_TYPES = PARAM_TYPES.NULL
	
	public var paramType: PARAM_TYPES {
		
		get {
			return _currentParamType
		}
	}
	
	public var intParam: Int? {
		
		set {
			_currentParamType = PARAM_TYPES.INT
			_intParam = newValue
		}
		
		get {
			return _intParam
		}
	}
	
	public var strParam: String? {
		
		set {
			_currentParamType = PARAM_TYPES.STRING
			_strParam = newValue
		}
		
		get {
			return _strParam
		}
	}
	
	public var doubleParam: Double? {
		
		set {
			_currentParamType = PARAM_TYPES.NUMBER
			_doubLeParam = newValue
		}
		
		get {
			return _doubLeParam
		}
	}
	
	public var dateParam: Date? {
		
		set {
			_currentParamType = PARAM_TYPES.DATETIME
			_dateTimeParam = newValue
		}
		
		get {
			return _dateTimeParam
		}
	}
	
	public var dateStrParam: String? {
		
		set {
			_currentParamType = PARAM_TYPES.DATETIME
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
			if let dateValue = dateFormatter.date(from: newValue!) {
				
				_dateTimeParam = dateValue
			}else{
				
				_dateTimeParam = Date()
			}
		}
		
		get {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
			
			return dateFormatter.string(from: _dateTimeParam!)
		}
	}
	
	public init(withInt intParam: Int) {
		
		self.intParam = intParam
	}
	
	public init(withStr strParam: String) {
		
		self.strParam = strParam
	}
	
	public init(withDouble doubleParam: Double) {
		
		self.doubleParam = doubleParam
	}
	
	public init(withDate dateParam: Date) {
		
		self.dateParam = dateParam
	}
	
	public init() {
		
		self._currentParamType = PARAM_TYPES.NULL
	}
}

public struct IOSQLiteOrder {

	public enum IOSQLITE_ORDER_TYPES: String {
		case ASC = "ASC"
		case DESC = "DESC"
	}

	private var _tableName: String
	private var _columnName: String
	private var _currentOrder: IOSQLITE_ORDER_TYPES
	
	public var tableName: String {
		
		get {
			return _tableName
		}
	}
	
	public var columnName: String {
		
		get {
			return _columnName
		}
	}
	
	public var currentOrder: IOSQLITE_ORDER_TYPES {
		
		get {
			return _currentOrder
		}
	}
	
	public init(tableName: String, columnName: String, orderType: IOSQLITE_ORDER_TYPES) {
		
		self._tableName = tableName
		self._columnName = columnName
		self._currentOrder = orderType
	}
}

public struct IOSQLiteJoin {
	
	public enum JOIN_TYPES: String {
		
		case LEFT = "LEFT OUTER JOIN"
		case CROSS = "CROSS JOIN"
		case INNER = "INNER JOIN"
		
	}
	
	private var _tableName: String
	private var _expressionColumn_1: String
	private var _expressionTable: String
	private var _expressionColumn_2: String
	private var _currentJoinType: JOIN_TYPES
	
	public var tableName: String {
		
		get {
			return _tableName
		}
	}
	
	public var expressionTable: String {
		
		get {
			return _expressionTable
		}
	}
	
	public var expressionColumn_1: String {
		
		get {
			return _expressionColumn_1
		}
	}
	
	public var expressionColumn_2: String {
		
		get {
			return _expressionColumn_2
		}
	}
	
	public var joinType: JOIN_TYPES {
		
		get {
			return _currentJoinType
		}
	}
	
	public init(tableName: String, withTable: String, column1: String, column2: String, joinType: JOIN_TYPES) {
		
		self._tableName = tableName
		self._expressionTable = withTable
		self._expressionColumn_1 = column1
		self._expressionColumn_2 = column2
		self._currentJoinType = joinType
	}
}
