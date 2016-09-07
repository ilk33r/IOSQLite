//
//  IOSQL-Bridging-Header.h
//  IOPaymentCalculator
//
//  Created by ilker özcan on 25/08/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

#ifndef IOSQL_Bridging_Header_h
#define IOSQL_Bridging_Header_h

#ifndef _XOPEN_SOURCE
#	define _XOPEN_SOURCE
#endif

#ifndef _XOPEN_SOURCE_EXTENDED
#	define _XOPEN_SOURCE_EXTENDED
#endif

#ifndef NCURSES_WIDECHAR
#	define NCURSES_WIDECHAR 1
#endif

#ifdef Linux
#endif

#ifdef Darwin
#	import <sqlite3.h>
#endif

#endif /* IOSQL_Bridging_Header_h */
