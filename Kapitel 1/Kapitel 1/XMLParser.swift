//
//  XMLParser.swift
//  Kapitel 1
//
//  Created by Udemy on 27.12.14.
//  Copyright (c) 2014 Udemy. All rights reserved.
//

import UIKit

class XMLParser: NSObject, NSXMLParserDelegate {
    
    let ITEM_TRENNER = "item"
   
    var url: NSURL
    var handler: ([[String:String]] -> Void)!
    
    var daten = [[String:String]]()
    
    init(url: String) {
        self.url = NSURL(string: url)!
        super.init()
    }
    
    func parse(fertig: [[String:String]] -> Void = {daten in }) {
        handler = fertig
        
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            _, data, _ in
            
            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
    }
    
    var inItem = false
    var currentElement = ""
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        if elementName == ITEM_TRENNER {
            daten.append([String:String]())
            inItem = true
        }
        currentElement = elementName
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if inItem {
            if daten[daten.count - 1][currentElement] != nil {
                daten[daten.count - 1][currentElement]! += string
            }
            else {
                daten[daten.count - 1][currentElement] = string
            }
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == ITEM_TRENNER {
            inItem = false
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        handler(daten)
    }
}

















