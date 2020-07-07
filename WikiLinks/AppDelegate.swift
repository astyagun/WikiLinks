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
            let decodedUrl = url.absoluteString.removingPercentEncoding!.replacingOccurrences(of: "%20", with: " ")
            let filePath = removeSchemeFromUrl(decodedUrl)
            let absoluteUrl = absoluteWikiUrlFromRelativePath(filePath)
            let openConfiguration = NSWorkspace.OpenConfiguration()
            openConfiguration.promptsUserIfNeeded = false
            
            NSWorkspace.shared.open(absoluteUrl, configuration: openConfiguration, completionHandler: { app, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.displayFileOpenErrorAlert(error)
                        exit(0)
                    }
                } else {
                    exit(0)
                }
            })
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

    fileprivate func displayFileOpenErrorAlert(_ error: Error?) {
        let alert = NSAlert()
        alert.messageText = "Error opening wiki file"
        alert.informativeText = error?.localizedDescription ?? "Unknown error"
        alert.alertStyle = NSAlert.Style.warning
        
        alert.runModal()
    }
}
