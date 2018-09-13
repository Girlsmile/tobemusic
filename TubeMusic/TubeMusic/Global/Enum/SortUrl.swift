//
//  sortUrl.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/6.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
enum SortUrl:String{
 case Trending = "Trending"
 case PopMusic
 case LatinMusic
 case HouseMusic
 case ElectronicMusic
 case HipHopMusic
 case Reggae
 case Trap
 case PopRock
 case Country
 case RwithB = "R&B"
 case AsianMusic
 case MexicanMusic
 case Soul
 case RhythmBlues
 case ChristianMusic
 case HardRock
 case HeavyMetal
 case ClassicalMusic
 case AlternativeRock
    
 func getUrlId()->String{
        switch self {
        case .Trending:
         return "PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI"
        case .PopMusic:
         return "PLDcnymzs18LWrKzHmzrGH1JzLBqrHi3xQ"
        case .HouseMusic:
        return "PLhInz4M-OzRUsuBj8wF6383E7zm2dJfqZ"
        case .LatinMusic:
        return "PLcfQmtiAG0X-fmM85dPlql5wfYbmFumzQ"
        case .ElectronicMusic:
        return "PLFPg_IUxqnZNnACUGsfn50DySIOVSkiKI"
        case .HipHopMusic:
        return "PLH6pfBXQXHEC2uDmDy5oi3tHW6X8kZ2Jo"
        case .Reggae:
        return "PLYAYp5OI4lRLf_oZapf5T5RUZeUcF9eRO"
        case .Trap:
        return "PLL4IwRtlZcbvbCM7OmXGtzNoSR0IyVT02"
        case .PopRock:
        return "PLr8RdoI29cXIlkmTAQDgOuwBhDh3yJDBQ"
        case .Country:
        return "PLvLX2y1VZ-tFJCfRG7hi_OjIAyCriNUT2"
        case .RwithB:
        return "PLFRSDckdQc1th9sUu8hpV1pIbjjBgRmDw"
        case .AsianMusic:
        return "PL0zQrw6ZA60Z6JT4lFH-lAq5AfDnO2-aE"
        case .MexicanMusic:
        return "PLXupg6NyTvTxw5-_rzIsBgqJ2tysQFYt5"
        case .Soul:
        return  "PLQog_FHUHAFUDDQPOTeAWSHwzFV1Zz5PZ"
        case .RhythmBlues:
        return  "PLWNXn_iQ2yrKzFcUarHPdC4c_LPm-kjQy"
        case .ChristianMusic:
        return "PLLMA7Sh3JsOQQFAtj1no-_keicrqjEZDm"
        case .HardRock:
        return "PL9NMEBQcQqlzwlwLWRz5DMowimCk88FJk"
        case .HeavyMetal:
        return  "PLfY-m4YMsF-OM1zG80pMguej_Ufm8t0VC"
        case .ClassicalMusic:
        return  "PLVXq77mXV53-Np39jM456si2PeTrEm9Mj"
        case .AlternativeRock:
        return "PL47oRh0-pTouthHPv6AbALWPvPJHlKiF7"
        }
    }
}
