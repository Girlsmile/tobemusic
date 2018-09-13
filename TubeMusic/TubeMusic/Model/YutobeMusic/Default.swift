//
//	Default.swift
//
//	Create by 智鹏 古 on 2/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON
class Default:HandyJSON{
    required init() {
    }
    
	var height : Int!
	var url : String!
	var width : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
   init(fromDictionary dictionary: NSDictionary){
		height = dictionary["height"] as? Int
		url = dictionary["url"] as? String
		width = dictionary["width"] as? Int
	}

}
