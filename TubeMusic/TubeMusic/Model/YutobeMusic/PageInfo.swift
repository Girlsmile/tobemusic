//
//	PageInfo.swift
//
//	Create by 智鹏 古 on 2/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON
class PageInfo:HandyJSON{
    required init() {
    }
    

	var resultsPerPage : Int!
	var totalResults : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		resultsPerPage = dictionary["resultsPerPage"] as? Int
		totalResults = dictionary["totalResults"] as? Int
	}

}
