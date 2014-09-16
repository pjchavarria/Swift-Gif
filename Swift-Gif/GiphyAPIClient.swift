//
//  GiphyAPIClient.swift
//  Swift-Gif
//
//  Created by Paul Chavarria Podoliako on 9/11/14.
//  Copyright (c) 2014 AnyTap. All rights reserved.
//

import Foundation

class GiphyAPIClient {
    let URL = "http://api.giphy.com/v1/gifs/search"
    let betaKey = "dc6zaTOxFJmzC"
    
    class var sharedInstance : GiphyAPIClient {
    struct Static {
        static let instance : GiphyAPIClient = GiphyAPIClient()
        }
        return Static.instance
    }

    
    func gifsForQuery(query: String, offset: Int, callback: ([Gif], NSError?)->()) {
        let params = ["q": query, "offset":String(offset), "api_key": betaKey]
        request(.GET, URL, parameters: params).responseJSON({
            (request, response, data, error) in
            let gifs = Gif.translateFromJSON(data)
            callback(gifs, error)
        })
    }
}
