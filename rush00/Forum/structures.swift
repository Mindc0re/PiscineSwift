//
//  structures.swift
//  Forum
//
//  Created by Jordan MUNOZ on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import Foundation


struct Author: Decodable {
    var id: Int?
    var login: String?
    var url: String?
    
    init(id: Int? = nil, login: String? = nil, url: String? = nil) {
        self.id = id
        self.login = login
        self.url = url
    }
}

struct Message: Decodable {
    var id: Int?
    var author: Author?
    var content: String?
    var created_at: String?
    var updated_at: String?
    
    init(id: Int? = nil, author: Author? = nil, content: String? = nil, created_at: String? = nil, updated_at: String? = nil) {
        self.id = id
        self.author = author
        self.content = content
        self.created_at = created_at
        self.updated_at = updated_at
    }
}

struct Messages_Attributes: Decodable{
    var content: String?
    var messageable_id: String?
    var messageable_type: String?
    
    init(content: String? = nil, messageable_id: String? = nil, messageable_type: String? = nil) {
        self.content = content
        self.messageable_id = messageable_id
        self.messageable_type = messageable_type
    }
}

struct Topic: Decodable{
    var kind: String?
    var language_id: String?;
    var name: String?
    var author: Author?
    var messages_attributes: [Messages_Attributes]?
    var tag_ids: [String]?
    var date: String?
    var updated_at: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "created_at"
        case kind, language_id, name, author, messages_attributes, tag_ids, updated_at
    }
    
    init(kind: String? = nil, language_id: String? = nil, name: String? = nil, author: Author? = nil, messages_attributes: [Messages_Attributes]? = nil, tag_ids: [String]? = nil, date: String? = nil, updated_at: String? = nil) {
        self.kind = kind
        self.language_id = language_id
        self.name = name
        self.author = author
        self.messages_attributes = messages_attributes
        self.tag_ids = tag_ids
        self.date = date
        self.updated_at = updated_at
    }
}

