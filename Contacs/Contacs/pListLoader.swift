//
//  pListLoader.swift
//  Contacs
//
//  Created by Baran on 11.01.2026.
//

import Foundation

enum PListLoader : Error {
    
    case invalidResource
    case parsingFailure
    
}

class pListLoader {
    
    static func array(fileName : String, extension_ : String ) throws -> [[String:String]] {
        
        // Dosyanın yolunu bulma
        guard let path = Bundle.main.path(forResource: fileName, ofType: extension_) else{
            throw PListLoader.invalidResource
        }
        
        guard let data = NSArray(contentsOfFile: path) as? [[String : String]] else {
            throw PListLoader.parsingFailure
        }
        return data
    }
}

class ContactSource{
    
    
    static var contacs : [Contact]{
        
        let data = try! pListLoader.array(fileName: "ContactsDB", extension_: "plist")
        return data.compactMap{
            Contact(data: $0)
        }
        
    }
}


