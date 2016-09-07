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
	private var databaseHandle: UnsafeMutablePointer<OpaquePointer?>!
	
	init(databasePath: String) throws {
		
		self.logger = logger
		self.databasePath = databasePath
		
		let dbStatus = sqlite3_open(self.databasePath, self.databaseHandle)
		if(dbStatus != 0) {
			
			let dbMEssage = "Can't open database: \(sqlite3_errmsg(self.databaseHandle.move()))"
			sqlite3_close(self.databaseHandle.move())
			throw IOSQLiteError.SQLiteOpenError(err: dbMEssage)
		}
	}
	
	
}
