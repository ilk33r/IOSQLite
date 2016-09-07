//
//  IOSQLiteEntity.swift
//  IOPaymentCalculator
//
//  Created by ilker özcan on 06/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public struct IOSQLiteEntity {
	
	private var _tableName: String
	public var getTableName: String {
		get {
			return _tableName
		}
	}
	
	private var activeRecord: IOSQLiteActiveRecord?
	private var orders = [(String, ORDER_TYPES)]()
	private var maxRows = -1
	private var startRow = -1
	
	public init (tableName: String) {
		
		self._tableName = tableName
		self.activeRecord = IOSQLiteActiveRecord(tableName: self.getTableName)
	}
	
	public func addSelect(singleColumn columnName: String) {
		
		self.activeRecord!.addSelect(selectData: (self.getTableName, columnName))
	}
	
	public func addSelect(singleColumnOtherTable tableName: String, columnName: String) {
		
		self.activeRecord!.addSelect(selectData: (tableName, columnName))
	}
	
	public func addSelect(withColumns columns: [String]) {
		
		for column in columns {
			
			self.activeRecord!.addSelect(selectData: (self.getTableName, column))
		}
	}
	
	public func addSelect(columnsOtherTable tableName: String, columns: [String]) {
		
		for column in columns {
			
			self.activeRecord!.addSelect(selectData: (tableName, column))
		}
	}
	
	public func addWhere(withColumn columnName: String) {
		
		let whereDataType = IOSQLiteWhere(tableName: self.getTableName, columnName: columnName, comparsionType: IOSQLiteWhere.COMPARSION_TYPES.EQUAL, whereType: IOSQLiteWhere.WHERE_TYPES.AND)
		self.activeRecord!.addWhere(whereData: whereDataType)
	}
	
	public func addWhere(withType columnName: String, comparsionType: IOSQLiteWhere.COMPARSION_TYPES, whereType: IOSQLiteWhere.WHERE_TYPES) {
		
		let whereDataType = IOSQLiteWhere(tableName: self.getTableName, columnName: columnName, comparsionType: comparsionType, whereType: whereType)
		self.activeRecord!.addWhere(whereData: whereDataType)
	}
	
	public func addWhere(withColumnOtherTable tableName: String, columnName: String) {
		
		let whereDataType = IOSQLiteWhere(tableName: tableName, columnName: columnName, comparsionType: IOSQLiteWhere.COMPARSION_TYPES.EQUAL, whereType: IOSQLiteWhere.WHERE_TYPES.AND)
		self.activeRecord!.addWhere(whereData: whereDataType)
	}
	
	public func addWhere(withTypeOtherTable tableName: String, columnName: String, comparsionType: IOSQLiteWhere.COMPARSION_TYPES, whereType: IOSQLiteWhere.WHERE_TYPES) {
		
		let whereDataType = IOSQLiteWhere(tableName: tableName, columnName: columnName, comparsionType: comparsionType, whereType: whereType)
		self.activeRecord!.addWhere(whereData: whereDataType)
	}
	
	public func addWhere(withGroup whereData: [IOSQLiteWhere]) {
		
		self.activeRecord!.addWhereGroup(whereDatas: whereData)
	}
	
	public mutating func setParam(integerParam paramValue: Int) {
	
		self.whereValues.append((paramValue as Any, PARAM_TYPES.INT))
	}
	
	public mutating func setParam(stringParam paramValue: String) {
		
		self.whereValues.append((paramValue as Any, PARAM_TYPES.STRING))
	}
	
	public mutating func setParam(numberParam paramValue: Double) {
		
		self.whereValues.append((paramValue as Any, PARAM_TYPES.NUMBER))
	}
	
	public mutating func setParam(nullParam paramValue: NSNull) {
		
		self.whereValues.append((paramValue as Any, PARAM_TYPES.NULL))
	}
	
	public mutating func addOrder(column: String, orderType: ORDER_TYPES) {
		
		self.orders.append((column, orderType))
	}
	
	public mutating func setStartRow(startRow: Int) {
		
		self.startRow = startRow
	}
	
	public mutating func setMaxRows(maxRows: Int) {
		
		self.maxRows = maxRows
	}
}
