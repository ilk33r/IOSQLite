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
	
	public init (tableName: String) {
		
		self._tableName = tableName
		self.activeRecord = IOSQLiteActiveRecord(tableName: self.getTableName)
	}
	
	public func addSelect(singleColumn columnName: String) {
		
		let selectData = IOSQLiteSelect(tableName: self.getTableName, columnName: columnName, isDistinct: false)
		self.activeRecord!.addSelect(selectData: selectData)
	}
	
	public func addSelect(select selectData: IOSQLiteSelect) {
		
		self.activeRecord!.addSelect(selectData: selectData)
	}
	
	public func addWhere(withColumn columnName: String) {
		
		let whereDataType = IOSQLiteWhere(tableName: self.getTableName, columnName: columnName, comparsionType: IOSQLiteWhere.COMPARSION_TYPES.EQUAL, whereType: IOSQLiteWhere.WHERE_TYPES.AND)
		self.activeRecord!.addWhere(whereData: whereDataType)
	}
	
	public func addWhere(withType columnName: String, comparsionType: IOSQLiteWhere.COMPARSION_TYPES, whereType: IOSQLiteWhere.WHERE_TYPES) {
		
		let whereDataType = IOSQLiteWhere(tableName: self.getTableName, columnName: columnName, comparsionType: comparsionType, whereType: whereType)
		self.activeRecord!.addWhere(whereData: whereDataType)
	}
	
	public func addWhere(withTypeOtherTable whereData: IOSQLiteWhere) {
		
		self.activeRecord!.addWhere(whereData: whereData)
	}
	
	public func addWhere(withGroup whereData: [IOSQLiteWhere]) {
		
		self.activeRecord!.addWhereGroup(whereDatas: whereData)
	}
	
	public func setParam(ioSQLiteParam param: IOSQLiteParam) {
	
		self.activeRecord!.setParam(param: param)
	}
	
	public func setParam(intParam param: Int) {
		
		let tmpParam = IOSQLiteParam(withInt: param)
		self.activeRecord!.setParam(param: tmpParam)
	}
	
	public func setParam(strParam param: String) {
		
		let tmpParam = IOSQLiteParam(withStr: param)
		self.activeRecord!.setParam(param: tmpParam)
	}
	
	public func setParam(doubleParam param: Double) {
		
		let tmpParam = IOSQLiteParam(withDouble: param)
		self.activeRecord!.setParam(param: tmpParam)
	}
	
	public func setParam(dateParam param: Date) {
		
		let tmpParam = IOSQLiteParam(withDate: param)
		self.activeRecord!.setParam(param: tmpParam)
	}
	
	public func addOrder(orderByAsc column: String) {
		
		let order = IOSQLiteOrder(tableName: self.getTableName, columnName: column, orderType: IOSQLiteOrder.IOSQLITE_ORDER_TYPES.ASC)
		self.activeRecord!.addOrder(order: order)
	}
	
	public func addOrder(orderByDesc column: String) {
		
		let order = IOSQLiteOrder(tableName: self.getTableName, columnName: column, orderType: IOSQLiteOrder.IOSQLITE_ORDER_TYPES.DESC)
		self.activeRecord!.addOrder(order: order)
	}
	
	public func addOrder(order orderData: IOSQLiteOrder) {
		
		self.activeRecord!.addOrder(order: orderData)
	}
	
	public func setStartRow(startRow: Int) {
		
		self.activeRecord!.startRow = startRow
	}
	
	public func setMaxRows(maxRows: Int) {
		
		self.activeRecord!.maxRows = maxRows
	}
	
	public func addGroupBy(groupColumnName: String) {
		
		self.activeRecord!.addGroupBy(groupColumn: groupColumnName)
	}
	
	public func addHavingClause(havingClause: IOSQLiteWhere) {
		
		self.activeRecord!.addHavingClause(condition: havingClause)
	}
	
	public func addJoin(leftJoin tableName: String, withTable: String, column1: String, column2: String) {
		
		let joinData = IOSQLiteJoin(tableName: tableName, withTable: withTable, column1: column1, column2: column2, joinType: IOSQLiteJoin.JOIN_TYPES.LEFT)
		self.activeRecord!.addJoin(joinData: joinData)
	}
	
	public func addJoin(join joinData: IOSQLiteJoin) {
		
		self.activeRecord!.addJoin(joinData: joinData)
	}
	
	public func delete() {
		
		self.activeRecord!.delete()
	}
	
	public func addInsert(forColumn columnName: String) {
		
		self.activeRecord!.addInsert(columnNames: [columnName])
	}
	
	public func addInsert(columns columnNames: [String]) {
		
		self.activeRecord!.addInsert(columnNames: columnNames)
	}
	
	public mutating func getQuery() throws -> String {
		
		do {
			let queryStr = try self.activeRecord!.getQuery()
			self.flush()
			return queryStr
		} catch let error {
			self.flush()
			throw error
		}
	}
	
	public mutating func flush() {
		
		self.activeRecord = nil
	}
}
