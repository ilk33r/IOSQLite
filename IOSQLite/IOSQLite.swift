//
//  IOSQLite.swift
//  IOPaymentCalculator
//
//  Created by ilker özcan on 03/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public class IOSQLite {
	
	private var databasePath: String
	private var databaseHandle: OpaquePointer?
	private var queryId: Int = 0
	
	public init(databasePath: String) throws {
		
		self.databasePath = databasePath
		
		let dbStatus = sqlite3_open(self.databasePath, &self.databaseHandle)
		if(dbStatus != SQLITE_OK) {
			
			let dbMEssage = "Can't open database: \(sqlite3_errmsg(self.databaseHandle))"
			sqlite3_close(self.databaseHandle)
			throw IOSQLiteError.SQLiteOpenError(err: dbMEssage)
		}
	}
	
	public func query(queryString: String) throws {
		
		var zErrMsg: UnsafeMutablePointer<CChar>? = nil
		var clonedQueryId = self.queryId
		let dataIdx: UnsafeMutableRawPointer? = UnsafeMutableRawPointer(&clonedQueryId)
		
		let queryStatus = sqlite3_exec(self.databaseHandle, queryString, SqlExecCallback, dataIdx, &zErrMsg)
		
		if( queryStatus != SQLITE_OK ){
			
			let dbErrMessage = "\(String(cString: zErrMsg!))\nQuery: \(queryString)"
			sqlite3_free(zErrMsg)
			throw IOSQLiteError.SQLiteExecuteError(err: dbErrMessage)
			
		}
		
		queryId += 1
	}
	
	public func getResults() throws -> IOSQLiteResult {
	
		return try IOSQLiteResultHandler.sharedInstance.getResults()
	}
	
	public func freeResult() throws {
		
		try IOSQLiteResultHandler.sharedInstance.freeLastResult()
	}
	
	public func lastInsertId() -> Int64 {
		
		return sqlite3_last_insert_rowid(databaseHandle)
	}
	
	public func closeConnection() {
		
		IOSQLiteResultHandler.sharedInstance.safeFree()
		sqlite3_close(databaseHandle)
	}
}
