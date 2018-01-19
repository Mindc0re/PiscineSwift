//
//  Article+CoreDataProperties.swift
//  sgaudin2018
//
//  Created by Simon GAUDIN on 1/18/18.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

}
