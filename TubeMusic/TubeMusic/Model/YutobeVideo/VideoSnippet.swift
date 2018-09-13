//
//	videoSnippet.swift
//
//	Create by 智鹏 古 on 8/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON
class VideoSnippet:HandyJSON{

    required init() {
    }
    
	var categoryId : String!
	var channelId : String!
	var channelTitle : String!
	var defaultAudioLanguage : String!
	var descriptionField : String!
	var liveBroadcastContent : String!
	var localized : VideoLocalized!
	var publishedAt : String!
	var tags : [String]!
	var thumbnails : VideoThumbnail!
	var title : String!


}
