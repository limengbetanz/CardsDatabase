//
//  CoreDataCard+CoreDataProperties.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//
//

import Foundation
import CoreData

extension CoreDataCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataCard> {
        return NSFetchRequest<CoreDataCard>(entityName: "CoreDataCard")
    }

    @NSManaged public var id: Int32
    @NSManaged public var uid: String
    @NSManaged public var number: String
    @NSManaged public var expiryDate: String
    @NSManaged public var type: String

}

extension CoreDataCard : Identifiable {

}
