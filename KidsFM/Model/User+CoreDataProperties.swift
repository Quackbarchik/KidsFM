//
//  User+CoreDataProperties.swift
//  KidsFM
//
//  Created by Zakhar R on 16.12.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var avatar: String?
    @NSManaged public var nickname: String?
    @NSManaged public var email: String?

}
