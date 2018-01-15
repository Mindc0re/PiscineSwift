//
//  structures.swift
//  Forum
//
//  Created by Jordan MUNOZ on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import Foundation


struct TopicWrap: Codable {
    var topic: Topic
}

struct MessageWrap: Codable {
    var message: Message
}

struct TopicMessage: Codable {
    var id: Int?
    var content: TopicMessageContent?
    
    init(id: Int? = nil, content: TopicMessageContent? = nil) {
        self.id = id
        self.content = content
    }
}

struct TopicMessageContent: Codable {
    var markdown: String?
    
    init(markdown: String? = nil) {
        self.markdown = markdown
    }
}


struct Author: Codable {
    var id: Int?
    var login: String?
    var url: String?
    
    init(id: Int? = nil, login: String? = nil, url: String? = nil) {
        self.id = id
        self.login = login
        self.url = url
    }
}

struct Message: Codable {
    var id: Int?
    var author: Author?
    var content: String?
    var created_at: String?
    var updated_at: String?
    var replies: [Message]?
    
    init(id: Int? = nil, author: Author? = nil, content: String? = nil, created_at: String? = nil, updated_at: String? = nil, replies: [Message]? = nil) {
        self.id = id
        self.author = author
        self.content = content
        self.created_at = created_at
        self.updated_at = updated_at
        self.replies = replies
    }
}

struct Messages_Attributes: Codable {
    var content: String?
    var messageable_id: String?
    var messageable_type: String?
    
    init(content: String? = nil, messageable_id: String? = nil, messageable_type: String? = nil) {
        self.content = content
        self.messageable_id = messageable_id
        self.messageable_type = messageable_type
    }
}


struct Topic: Codable {
    var id: Int?
    var kind: String?
    var language_id: String?;
    var name: String?
    var author: Author?
    var messages_attributes: [Messages_Attributes]?
    var message: TopicMessage?
    var tag_ids: [String]?
    var date: String?
    var updated_at: String?
    var cursus_ids: [String]?
    
    enum CodingKeys: String, CodingKey {
        case date = "created_at"
        case kind, language_id, name, author, messages_attributes, tag_ids, updated_at, id, message, cursus_ids
    }
    
    init(id: Int? = nil, kind: String? = nil, language_id: String? = nil, name: String? = nil, author: Author? = nil, messages_attributes: [Messages_Attributes]? = nil, tag_ids: [String]? = nil, date: String? = nil, updated_at: String? = nil, message: TopicMessage? = nil, cursus_ids: [String]? = nil) {
        self.id = id
        self.kind = kind
        self.language_id = language_id
        self.name = name
        self.author = author
        self.messages_attributes = messages_attributes
        self.message = message
        self.tag_ids = tag_ids
        self.date = date
        self.updated_at = updated_at
        self.cursus_ids = cursus_ids
    }
}
