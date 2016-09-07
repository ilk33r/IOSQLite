//
//  IOSQLiteActiveRecordTypes.swift
//  IOSQLite
//
//  Created by ilker özcan on 07/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public enum IOSQLITE_ORDER_TYPES {
	case ASC
	case DESC
}

public struct IOSQLiteWhere {
	
	public enum WHERE_TYPES: String {
		case AND = "AND"
		case OR = "OR"
		case BETWEEN = "BETWEEN"
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
	}
	
	public enum PARAM_TYPES {
		case INT
		case NUMBER
		case STRING
		case DATETIME
		case NULL
	}

	private var _tableName: String
	private var _columnName: String
	private var _comparsionType: COMPARSION_TYPES
	private var _whereType: WHERE_TYPES
	private var _intParam: Int?
	private var _strParam: String?
	private var _doubLeParam: Double?
	private var _dateTimeParam: Date?
	
	private var _currentParamType: PARAM_TYPES = PARAM_TYPES.NULL
	
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
	
	public init(tableName: String, columnName: String, comparsionType: COMPARSION_TYPES, whereType: WHERE_TYPES) {
		
		self._tableName = tableName
		self._columnName = columnName
		self._comparsionType = comparsionType
		self._whereType = whereType
	}
	
	public mutating func
}

