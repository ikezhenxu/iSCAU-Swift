//
//  ActivityHttpManager.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/7/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class ActivityHttpManager: BaseHttpManager {
    
    class func activityList(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "http://iscaucms.sinaapp.com/index.php/Api/getActivities?time=\(Utils.activityLastUpdateTimeStamp!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
}
