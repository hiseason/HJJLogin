//
//  FileHelper.swift
//  HJJLogin
//
//  Created by 郝旭姗 on 2021/1/20.
//

import Foundation

enum FileHelper {
    
    static func writeJSON<T: Encodable>(_ value: T, to url: URL) throws {
        let data = try appEncoder.encode(value)
        try data.write(to: url)
    }

    static func writeJSON<T: Encodable>(
        _ value: T,
        to directory: FileManager.SearchPathDirectory,
        fileName: String
    ) throws
    {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else {
            return
        }
        print("directory: \(url)")
        try writeJSON(value, to: url.appendingPathComponent(fileName))
    }

    static func delete(from directory: FileManager.SearchPathDirectory, fileName: String) throws {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else {
            return
        }
        try FileManager.default.removeItem(at: url.appendingPathComponent(fileName))
    }

    static func loadJSON<T: Decodable>(from url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        return try appDecoder.decode(T.self, from: data)
    }

    static func loadJSON<T: Decodable>(
        from directory: FileManager.SearchPathDirectory,
        fileName: String
    ) throws -> T
    {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else {
            throw AppError.fileError
        }
        return try loadJSON(from: url.appendingPathComponent(fileName))
    }

}

