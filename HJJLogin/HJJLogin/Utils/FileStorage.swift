//
//  FileStorage.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/20.
//

import Foundation
import Combine

@propertyWrapper
struct FileStorage<T: Codable> {
    var value: T?
    
    let directory: FileManager.SearchPathDirectory
    let fileName: String
    
    init(directory: FileManager.SearchPathDirectory, fileName: String) {
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
    }
    
    var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
            }else {
                try? FileHelper.delete(from: directory, fileName: fileName)
            }
        }
        
        get { value }
    }
}
