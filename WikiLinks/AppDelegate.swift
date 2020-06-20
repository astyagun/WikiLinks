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
        // TODO: (optional) Open all URLs at once
        // TODO: (optional) Handle non-MD files differently
        for url in urls {
            openNoteInMacVimWiki(
                removeSchemeFromUrl(url).removingPercentEncoding!
            )
        }
    }
    
    fileprivate func openNoteInMacVimWiki(_ wikiNotePath: String) {
        let configuration = NSWorkspace.OpenConfiguration()
        let nextcloudDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Nextcloud").relativePath
        configuration.arguments = ["+cd \(nextcloudDirectory) | edit \(wikiNotePath)"]
        let appUrl = URL(fileURLWithPath: "/Applications/MacVim.app")

        NSWorkspace.shared.openApplication(
            at: appUrl,
            configuration: configuration,
            completionHandler: { (app, error) -> () in
                if error == nil { exit(0) }
                else { exit(1) }
        })
    }
    
    fileprivate func removeSchemeFromUrl(_ url: URL) -> String {
        var result = url.absoluteString
        
        if result.hasPrefix("wiki:") {
            result = String(result.dropFirst(5))
            
            if result.hasPrefix("//") {
                result = String(result.dropFirst(2))
            }
        }
        
        return result
    }
}
