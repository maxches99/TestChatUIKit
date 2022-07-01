//
//  MessageModel.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

struct MessageModel: Codable {
    let id: UUID
    let text: String
    let type: MessageType
    let avatarData: Data?
    let date: Date = Date()
}
