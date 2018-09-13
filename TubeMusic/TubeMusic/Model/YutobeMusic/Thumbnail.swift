//
//	Thumbnail.swift
//
//	Create by 智鹏 古 on 2/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON
class Thumbnail:HandyJSON{
    required init() {
    
    }
    

	var defaultField : Default!
	var high : Default!
	var medium : Default!
   func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &defaultField, name: "default")
    }

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		if let defaultFieldData = dictionary["default"] as? NSDictionary{
			defaultField = Default(fromDictionary: defaultFieldData)
		}
		if let highData = dictionary["high"] as? NSDictionary{
			high = Default(fromDictionary: highData)
		}
		if let mediumData = dictionary["medium"] as? NSDictionary{
			medium = Default(fromDictionary: mediumData)
		}
	}

}
