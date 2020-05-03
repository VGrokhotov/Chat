//
//  ChannelsSorter.swift
//  Chat
//
//  Created by Владислав on 03.05.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import XCTest
@testable import Chat

protocol IChannelsSorter {
    func sort(_ channels: [Channel]) -> [Channel]
}

final class ChannelsSorter: IChannelsSorter {
    func sort(_ channels: [Channel]) -> [Channel] {
        channels.sorted { (first, second) -> Bool in
            
            guard let firstLastActivity = first.lastActivity else { return false }
            
            guard let secondLastActivity = second.lastActivity else { return true }
            
            let firstLastActivityPlusTenMinutes = firstLastActivity.addingTimeInterval(600)
            let secondLastActivityPlusTenMinutes = secondLastActivity.addingTimeInterval(600)

            if firstLastActivityPlusTenMinutes > Date()
                || secondLastActivityPlusTenMinutes > Date() {
                return firstLastActivity > secondLastActivity
            }
            
            if firstLastActivityPlusTenMinutes > Date() {
                return true
            }
            
            if secondLastActivityPlusTenMinutes > Date() {
                return false
            }
            
            return firstLastActivity > secondLastActivity
        }
    }
}

final class ChannelsSorterTests: XCTestCase {
    
    var channelsSorter: IChannelsSorter!
    
    //MARK: Lifecycle
    
    override func setUp() {
        self.channelsSorter = ChannelsSorter()
    }
    
    //MARK: Tests
    
    func testDataSorting() {
        
        //Given
        let channel1 = Channel(identifier: "lel", name: "lel", lastMessage: "lel", lastActivity: Date().addingTimeInterval(-592), section: "Active")
        let channel2 = Channel(identifier: "lol", name: "lol", lastMessage: "lol", lastActivity: Date().addingTimeInterval(-593), section: "Active")
        let channel3 = Channel(identifier: "gg", name: "gg", lastMessage: "gg", lastActivity: Date().addingTimeInterval(-594), section: "Active")
        let channel4 = Channel(identifier: "kk", name: "kk", lastMessage: "kk", lastActivity: Date().addingTimeInterval(-595), section: "Active")
        let channel5 = Channel(identifier: "vp", name: "vp", lastMessage: "vp", lastActivity: Date().addingTimeInterval(-596), section: "Active")
        let channel6 = Channel(identifier: "gl", name: "gl", lastMessage: "gl", lastActivity: Date().addingTimeInterval(-597), section: "Active")
        let channel7 = Channel(identifier: "hf", name: "hf", lastMessage: "hf", lastActivity: Date().addingTimeInterval(-598), section: "Active")
        let channel8 = Channel(identifier: "afk", name: "afk", lastMessage: "afk", lastActivity: nil, section: "Unknown")
        
        
        let expectedResult: [Channel] = [channel1, channel2, channel3, channel4, channel5, channel6, channel7, channel8]
        
        let unsorted: [Channel] = [channel7, channel4, channel2, channel3, channel1, channel8, channel6, channel5]
        
        //When
        let result = channelsSorter.sort(unsorted)
        
        //Then
        XCTAssertEqual(expectedResult, result)
    }
    
    func testActivitySorting() {
        
        //Given
        let channel1 = Channel(identifier: "lel", name: "lel", lastMessage: "lel", lastActivity: Date().addingTimeInterval(-595), section: "Active")
        let channel2 = Channel(identifier: "lol", name: "lol", lastMessage: "lol", lastActivity: Date().addingTimeInterval(-596), section: "Active")
        let channel3 = Channel(identifier: "gg", name: "gg", lastMessage: "gg", lastActivity: Date().addingTimeInterval(-597), section: "Active")
        let channel4 = Channel(identifier: "kk", name: "kk", lastMessage: "kk", lastActivity: Date().addingTimeInterval(-598), section: "Active")
        let channel5 = Channel(identifier: "vp", name: "vp", lastMessage: "vp", lastActivity: Date().addingTimeInterval(-608), section: "Not Active")
        let channel6 = Channel(identifier: "gl", name: "gl", lastMessage: "gl", lastActivity: Date().addingTimeInterval(-609), section: "Not Active")
        let channel7 = Channel(identifier: "hf", name: "hf", lastMessage: "hf", lastActivity: Date().addingTimeInterval(-610), section: "Not Active")
        let channel8 = Channel(identifier: "afk", name: "afk", lastMessage: "afk", lastActivity: nil, section: "Unknown")
    
        
        let expectedResult: [Channel] = [channel1, channel2, channel3, channel4, channel5, channel6, channel7, channel8]
        
        let unsorted: [Channel] = [channel8, channel3, channel4, channel7, channel5, channel2, channel6, channel1]
        
        //When
        let result = channelsSorter.sort(unsorted)
        
        //Then
        XCTAssertEqual(expectedResult, result)
        
    }
    
    
}
