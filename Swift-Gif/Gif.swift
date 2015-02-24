//
//  Gif.swift
//  Swift-Gif
//
//  Created by Paul Chavarria Podoliako on 9/11/14.
//  Copyright (c) 2014 AnyTap. All rights reserved.
//

import Foundation

class Gif {
    
    var id: String = ""
    var source: String?
    var fixedWidthUrl: String?
    var originalUrl: String?
    var width: Int = 0
    var height: Int = 0
    var rating: String?
    
}

extension Gif {
    class func translateFromJSON(data: AnyObject?) -> [Gif] {
        if let data = data as? NSDictionary {
            let json = JSONValue(data)
            if let jsonGifs = json["data"].array {
                
                //JSONValue it self confirm to Protocol "LogicValue", with JSONValue.JInvalid produce false and others produce true
                var gifs = [Gif]()
                for jsonGif in jsonGifs {
                    let gif = Gif()
                    gif.id = jsonGif["id"].string!
                    gif.source = jsonGif["source"].string
                    gif.rating = jsonGif["rating"].string
                    gif.originalUrl = jsonGif["images"]["original"]["url"].string
                    gif.fixedWidthUrl = jsonGif["images"]["fixed_width"]["url"].string
                    gif.width = jsonGif["images"]["original"]["width"].integer!
                    gif.height = jsonGif["images"]["original"]["height"].integer!
                    gifs.append(gif)
                }
                return gifs
            }else{
                println(json)
            }
        }
        return [Gif]()
    }
}