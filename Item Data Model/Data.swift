//
//  Data.swift
//  Todoay
//
//  Created by Abdulrahman Alangari on 2019-07-16.
//  Copyright © 2019 Dhoo00m. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
