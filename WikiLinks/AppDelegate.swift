//
//  AppDelegate.swift
//  WikiLinks
//
//  Created by Anton Styagun on 19.06.2020.
//  Copyright © 2020 Anton Styagun. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            let decodedUrl = url.absoluteString.removingPercentEncoding!
            let filePath = removeSchemeFromUrl(decodedUrl)
            let absoluteUrl = absoluteWikiUrlFromRelativePath(filePath)
            
            NSWorkspace.shared.open(absoluteUrl)
        }
    }
    
    fileprivate func removeSchemeFromUrl(_ url: String) -> String {
        var result = url
        
        if result.hasPrefix("wiki:") {
            result = String(result.dropFirst(5))
            
            if result.hasPrefix("//") {
                result = String(result.dropFirst(2))
            }
        }
        
        return result
    }
    
    fileprivate func absoluteWikiUrlFromRelativePath(_ filePath: String) -> URL {
        return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Nextcloud").appendingPathComponent(filePath)
    }
}
