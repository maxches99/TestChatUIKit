//
//  MessageType.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import Foundation

enum MessageType: Codable, Hashable {
    case Incoming
    case Outgoing
}

extension MessageType {
    var avatarURL: URL {
        switch self {
        case .Incoming:
            return URL(string: "https://cdn2.thecatapi.com/images/-H99qH2RF.png")!
        case .Outgoing:
            return URL(string: "https://cdn2.thecatapi.com/images/d9m.jpg")!
        }
    }
}

// так как было указано откуда угодно брать картинки - взял из двух источников
// но наверное если бы это был экран В который проваливаются после списка чатов, я бы сначала скачивал картинки аватрок а потом уже открывал
