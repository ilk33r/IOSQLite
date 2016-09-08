//
//  IOSQLiteError.swift
//  IOPaymentCalculator
//
//  Created by ilker özcan on 03/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public enum IOSQLiteError: Error {
	
	case SQLiteOpenError(err: String)
	case SQLiteActiveRecordQueryTypeError(err: String)
	case SQLiteParameterErrorError(err: String)
}
