//
//  Article+CoreDataClass.swift
//  sgaudin2018
//
//  Created by Simon GAUDIN on 1/18/18.
//
//

import Foundation
import CoreData


public class Article: NSManagedObject
{
    @NSManaged public var titre: String?
    @NSManaged public var content: String?
    @NSManaged public var image: NSData?
    @NSManaged public var langue: String?
    @NSManaged public var dateModif: NSDate?
    @NSManaged public var dateCreate: NSDate?
    
    override public var description: String
    {
        return "Article :\nLanguage : \(self.langue)\nTitle : \(self.titre)\nContent : \(self.content)\nImage : \(self.image)\nCreation Date : \(self.dateCreate)\nModification Date : \(self.dateModif)\n"
    }
}
