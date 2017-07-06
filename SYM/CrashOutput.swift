// The MIT License (MIT)
//
// Copyright (c) 2017 zqqf16
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Cocoa

struct Style {
    static let plain = Style([.font: NSFont(name: "Menlo", size: 11)!])
    static let keyFrame = Style([
        .foregroundColor: NSColor.red,
        .font: NSFontManager.shared.font(withFamily: "Menlo", traits: .boldFontMask, weight: 0, size: 11)!
    ])
    
    let attrs: [NSAttributedStringKey: AnyObject]
    init(_ attrs: [NSAttributedStringKey: AnyObject]) {
        self.attrs = attrs
    }
}

extension Crash {
    func generateDBDict() -> [String: String] {
        let lines = self.content.components(separatedBy: "\n")
        // the value need to stored in remote mysql
        var dbDict = [StoredToDBKey.Hardware.rawValue:"", StoredToDBKey.BundleId.rawValue:"", StoredToDBKey.UserID.rawValue:"", StoredToDBKey.SDKVersion.rawValue:"", StoredToDBKey.AppVersion.rawValue:"", StoredToDBKey.Time.rawValue:"", StoredToDBKey.ExceptionType.rawValue:"", StoredToDBKey.Description.rawValue:""]
        
        for line in lines {
            if line.contains(StoredToDBKey.Hardware.rawValue) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.Hardware.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.Hardware.rawValue)
            } else if line.contains(StoredToDBKey.BundleId.rawValue) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.BundleId.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.BundleId.rawValue)
            } else if line.contains(StoredToDBKey.UserID.rawValue) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.UserID.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.UserID.rawValue)
            } else if line.contains(StoredToDBKey.SDKVersion.rawValue) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.SDKVersion.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.SDKVersion.rawValue)
            } else if let _ = LineRE.appVersion.match(line) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.AppVersion.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.AppVersion.rawValue)
            } else if line.contains(StoredToDBKey.Time.rawValue) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.Time.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.Time.rawValue)
            } else if line.contains(StoredToDBKey.ExceptionType.rawValue) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.ExceptionType.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.ExceptionType.rawValue)
            } else if line.contains(StoredToDBKey.Description.rawValue) {
                let start = line.index(line.startIndex, offsetBy: StoredToDBKey.Description.rawValue.characters.count)
                dbDict.updateValue(line.substring(from: start).strip(), forKey: StoredToDBKey.Description.rawValue)
            }
            if (dbDict[StoredToDBKey.Description.rawValue]?.characters.count)! < 1 {
                if let group = LineRE.frame.match(line) {
                    let frame = Frame(index: group[0], image: group[1], address: group[2], symbol: group[3])
                    if frame.image == self.appName {
                        dbDict.updateValue(group[3], forKey: StoredToDBKey.Description.rawValue)
                    }
                }
            }
        }
        print(dbDict)
        return dbDict
    }
}
