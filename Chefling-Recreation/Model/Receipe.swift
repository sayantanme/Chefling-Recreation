//
//  GitHubUser.swift
//  Git-it
//
//  Created by Sayantan Chakraborty on 24/11/17.
//  Copyright © 2017 Sayantan Chakraborty. All rights reserved.
//

import Foundation.NSURL

// Query service creates Track objects
struct Receipe {
    
    let recipename: String?
    let recipephoto: String?
    let rid: Int?
    let recipetype: Int?
    
    init(recipename: String?, recipephoto: String?,rid: Int?, recipetype: Int?) {
        self.recipename = recipename
        self.recipephoto = recipephoto
        self.rid = rid
        self.recipetype = recipetype
    }
    
}
